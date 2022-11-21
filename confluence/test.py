#!/usr/bin/python3

import argparse
import os
import sys

PARSER = argparse.ArgumentParser()
PARSER.add_argument('-i', '--input', help='Input CSV filename')
PARSER.add_argument('-c', '--confluence', help='Confluence site name, e.g. https://www.myconfluence.com')

ARGS = PARSER.parse_args()

print("Input filename:", ARGS.input)

if not os.path.exists(ARGS.input):
    print("Input file",ARGS.input,"does not exist")
    sys.exit(1)

print("filename good")
