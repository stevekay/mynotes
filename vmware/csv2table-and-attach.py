#!/usr/bin/python3

# populate a confluence table with contents of a csv file

from atlassian import Confluence
import magic
import pandas as pd

FILENAME = 'data.csv'
SPACE = 'BOB'
PAGE = 'mytest'

a = pd.read_csv(FILENAME)

c = Confluence(url='http://localhost:8090',
               username='admin',
               password='admin')

if not c.page_exists(SPACE, PAGE):
    c.create_page(SPACE,
                  PAGE,
                  '',
                  parent_id=None,
                  type='page',
                  representation='storage',
                  editor='v2',
                  full_width=False)

pageid = c.get_page_id(SPACE, PAGE)

content_type = magic.from_file(FILENAME)

c.attach_file(filename=FILENAME,
              name='funkystats.csv',
              content_type=content_type,
              page_id=pageid)
              
c.update_page(pageid,
              PAGE,
              a.to_html())
