#!/usr/bin/env python3

import argparse
import glob
import os
import subprocess
import sys
import xml.etree.ElementTree as ET
from datetime import datetime, timezone
from pathlib import Path

from wikibaseintegrator import WikibaseIntegrator, wbi_login
from wikibaseintegrator.datatypes import Item as WDItem
from wikibaseintegrator.datatypes import Quantity, Time
from wikibaseintegrator.wbi_enums import ActionIfExists

ITEM_ID = "Q124341526"
REPO_ROOT = Path(__file__).resolve().parent.parent
SAXON_JAR = REPO_ROOT / "saxon" / "saxon.jar"
XSLT = REPO_ROOT / "wikidata" / "extract-correspondents.xsl"
INPUT_XML = REPO_ROOT / "data" / "indices" / "listcorrespondence.xml"
OUTPUT_XML = REPO_ROOT / "wikidata" / "correspondents.xml"
EDITIONS_DIR = REPO_ROOT / "data" / "editions"


def run_xslt():
    result = subprocess.run(
        [
            "java", "-jar", str(SAXON_JAR),
            f"-s:{INPUT_XML}",
            f"-xsl:{XSLT}",
            f"-o:{OUTPUT_XML}",
        ],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        print(f"XSLT failed:\n{result.stderr}", file=sys.stderr)
        sys.exit(1)


def parse_correspondents():
    tree = ET.parse(OUTPUT_XML)
    persons = []
    for p in tree.getroot().findall("person"):
        qid = p.get("qid")
        name = p.get("name")
        if qid:
            persons.append((qid, name))
    return persons


def count_letters():
    return len(glob.glob(str(EDITIONS_DIR / "*.xml")))


def update_wikidata(correspondents, letter_count, dry_run=False):
    username = os.environ.get("WIKIDATA_USERNAME")
    password = os.environ.get("WIKIDATA_PASSWORD")
    if not (username and password):
        print("WIKIDATA_USERNAME and WIKIDATA_PASSWORD must be set", file=sys.stderr)
        sys.exit(1)

    login = wbi_login.Login(user=username, password=password)
    wbi = WikibaseIntegrator(login=login)
    item = wbi.item.get(ITEM_ID)

    # --- P921: add new correspondence partners ---
    existing_p921 = set()
    for claim in item.claims.get("P921") or []:
        try:
            existing_p921.add(claim.mainsnak.datavalue["value"]["id"])
        except (KeyError, AttributeError):
            pass

    to_add = [(qid, name) for qid, name in correspondents if qid not in existing_p921]
    print(f"P921: {len(existing_p921)} already present, {len(to_add)} new")
    for qid, name in to_add:
        print(f"  + {qid}  ({name})")
        item.claims.add(WDItem(prop_nr="P921", value=qid))

    # --- P1114: total letter count ---
    item.claims.add(
        Quantity(prop_nr="P1114", amount=letter_count),
        action_if_exists=ActionIfExists.REPLACE_ALL,
    )
    print(f"P1114: {letter_count} letters")

    # --- P5017: last update ---
    today = datetime.now(timezone.utc).strftime("+%Y-%m-%dT00:00:00Z")
    item.claims.add(
        Time(prop_nr="P5017", time=today, precision=11),
        action_if_exists=ActionIfExists.REPLACE_ALL,
    )
    print(f"P5017: {today}")

    if dry_run:
        print("Dry run — no changes written to Wikidata")
        return

    item.write(
        summary=(
            "Bot: update P921 correspondence partners, "
            "P1114 letter count, P5017 last update "
            "(schnitzler-briefe-data)"
        )
    )
    print("Done — item written to Wikidata")


def main():
    parser = argparse.ArgumentParser(
        description="Sync Wikidata item Q124341526 from TEI index data"
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Extract and show changes without writing to Wikidata",
    )
    args = parser.parse_args()

    print("Running XSLT…")
    run_xslt()

    correspondents = parse_correspondents()
    print(f"Correspondents with Wikidata QID: {len(correspondents)}")

    letter_count = count_letters()
    print(f"Letters in editions/: {letter_count}")

    update_wikidata(correspondents, letter_count, dry_run=args.dry_run)


if __name__ == "__main__":
    main()
