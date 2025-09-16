#!/usr/bin/env python3
"""
Script to process XML files in ./data/editions/list*.xml and extract xml:id values
to generate a CSV file with id, uri, and domain columns.
"""

import os
import csv
import xml.etree.ElementTree as ET
from pathlib import Path
import glob

def process_xml_files():
    # Find all list*.xml files in data/indices/
    xml_files = glob.glob('./data/indices/list*.xml')
    
    results = []
    
    for xml_file in xml_files:
        try:
            tree = ET.parse(xml_file)
            root = tree.getroot()
            
            # Define namespace (TEI typically uses this namespace)
            namespaces = {
                'tei': 'http://www.tei-c.org/ns/1.0',
                'xml': 'http://www.w3.org/XML/1998/namespace'
            }
            
            # Find all elements matching the XPath pattern
            # /TEI/text/body/*[starts-with(name(), 'list')]/child::*/@xml:id
            body = root.find('.//tei:text/tei:body', namespaces)
            if body is not None:
                for child in body:
                    # Check if element name starts with 'list'
                    if child.tag.endswith('}list') or 'list' in child.tag:
                        for grandchild in child:
                            xml_id = grandchild.get('{http://www.w3.org/XML/1998/namespace}id')
                            if xml_id:
                                # 1) replace(@xml:id, 'pmb', '')
                                id_value = xml_id.replace('pmb', '')
                                
                                # 2) concat('https://schnitzler-briefe.acdh.oeaw.ac.at/', @xml:id, '.html')
                                uri_value = f'https://schnitzler-briefe.acdh.oeaw.ac.at/{xml_id}.html'
                                
                                # 3) "schnitzler-briefe"
                                domain_value = "schnitzler-briefe"
                                
                                results.append([id_value, uri_value, domain_value])
        
        except ET.ParseError as e:
            print(f"Error parsing {xml_file}: {e}")
        except Exception as e:
            print(f"Error processing {xml_file}: {e}")
    
    # Write to CSV
    with open('output.csv', 'w', newline='', encoding='utf-8') as csvfile:
        writer = csv.writer(csvfile)
        # Write header
        writer.writerow(['id', 'uri', 'domain'])
        # Write data
        writer.writerows(results)
    
    print(f"Processed {len(xml_files)} XML files")
    print(f"Extracted {len(results)} entries")
    print("Output written to output.csv")

if __name__ == "__main__":
    process_xml_files()