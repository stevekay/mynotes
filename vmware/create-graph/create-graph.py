#!/usr/bin/python3

# create a confluence page with embedded line bar chart

from atlassian import Confluence

SPACE = 'BOB'
PAGE = 'mygraph'
DATA = 'storage.html'

c = Confluence(url='http://localhost:8090',
               username='admin',
               password='admin')

f = open(DATA, 'r')

c.create_page(SPACE,
              PAGE,
              f.read(),
              parent_id=None,
              type='page',
              representation='storage',
              editor='v2',
              full_width=False)

