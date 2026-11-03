#!/usr/bin/env python3
"""
Collect the PMB entities used in a project's TEI index files (list*.xml) and
write them to a CSV that PMB reads to keep its URI registrations up to date.

The script is project-independent; everything project-specific lives in a JSON
config (default: ./pmb-uris.json):

    domain         identifies the project in PMB (scopes additions/deletions)
    uri_template   URI of an entity page, {xml_id} and {pmb_id} are available
    index_glob     glob for the index files
    exclude        file names to skip
    id_pattern     regex applied to @xml:id; group 1 is the numeric PMB id
    output         path of the CSV

Output columns: pmb_id, entity_type, uri, domain
Rows are sorted by (entity_type, pmb_id) so that git diffs stay small.

Usage: process_list_xml.py [config.json]
"""

import csv
import glob
import json
import os
import re
import sys
import xml.etree.ElementTree as ET

TEI = '{http://www.tei-c.org/ns/1.0}'
XML_ID = '{http://www.w3.org/XML/1998/namespace}id'

# TEI list element -> PMB entity type
ENTITY_TYPES = {
    'listPerson': 'person',
    'listPlace': 'place',
    'listOrg': 'org',
    'listBibl': 'bibl',
    'listEvent': 'event',
}


def collect(config):
    id_re = re.compile(config['id_pattern'])
    excluded = set(config.get('exclude', []))
    files = sorted(
        f for f in glob.glob(config['index_glob'])
        if os.path.basename(f) not in excluded
    )

    rows = {}
    for path in files:
        try:
            root = ET.parse(path).getroot()
        except ET.ParseError as e:
            sys.exit(f'Error parsing {path}: {e}')
        body = root.find(f'.//{TEI}text/{TEI}body')
        if body is None:
            continue
        for lst in body:
            entity_type = ENTITY_TYPES.get(lst.tag.removeprefix(TEI))
            if entity_type is None:
                continue
            for entry in lst:
                xml_id = entry.get(XML_ID)
                if not xml_id:
                    continue
                m = id_re.match(xml_id)
                if not m:
                    print(f'Skipping {xml_id} in {path}: does not match id_pattern')
                    continue
                pmb_id = m.group(1)
                uri = config['uri_template'].format(xml_id=xml_id, pmb_id=pmb_id)
                rows[(entity_type, pmb_id)] = [
                    pmb_id, entity_type, uri, config['domain']]
    return files, [rows[k] for k in sorted(rows, key=lambda k: (k[0], int(k[1])))]


def main():
    config_path = sys.argv[1] if len(sys.argv) > 1 else 'pmb-uris.json'
    with open(config_path, encoding='utf-8') as f:
        config = json.load(f)

    files, rows = collect(config)
    if not rows:
        # An empty CSV would make PMB drop every registration of this domain.
        sys.exit('No entities found, refusing to write an empty CSV')

    output = config['output']
    os.makedirs(os.path.dirname(output) or '.', exist_ok=True)
    with open(output, 'w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow(['pmb_id', 'entity_type', 'uri', 'domain'])
        writer.writerows(rows)

    print(f'Processed {len(files)} XML files')
    print(f'Extracted {len(rows)} entries')
    print(f'Output written to {output}')


if __name__ == '__main__':
    main()
