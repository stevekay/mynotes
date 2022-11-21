#!/usr/bin/python3

import argparse
import json
import os
import requests
import sys

PARSER = argparse.ArgumentParser()
PARSER.add_argument('-i', '--input', help='Input CSV filename', required=True)
PARSER.add_argument('-c', '--confluence', help='Confluence site name, e.g. https://www.myconfluence.com', required=True)

ARGS = PARSER.parse_args()

print("Input filename:", ARGS.input)

if not os.path.exists(ARGS.input):
    print("Input file",ARGS.input,"does not exist")
    sys.exit(1)

USERNAME = os.getenv('CONFLUENCE_USERNAME')
if USERNAME is None:
    print('Env var CONFLUENCE_USERNAME not set')
    sys.exit(1)

PASSWORD = os.getenv('CONFLUENCE_PASSWORD')
if PASSWORD is None:
    print('Env var CONFLUENCE_PASSWORD not set')
    sys.exit(1)

print("params good")

url = ARGS.confluence + '/rest/api/content/FOO'

print("url=",url)

session = requests.Session()
session.auth = (USERNAME, PASSWORD)
session.headers.update({'Content-Type': 'application/json'})

new_page = {'type': 'page',
            'title': 'foo',
            'space': {'key': 'FOO'},
            'body': {
                'storage': {
                    'value': '',
                    'representation': 'storage'
                }
            },
            'ancestors': 'foo',
           }

response = session.post(url, data=json.dumps(new_page))

print(response)
