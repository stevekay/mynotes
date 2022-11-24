#!/usr/bin/python3

# populate a confluence table with contents of a csv file

from atlassian import Confluence
import pandas as pd

SPACE = 'BOB'
PAGE = 'mytest'

a = pd.read_csv('data.csv')

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

c.update_page(pageid,
              PAGE,
              a.to_html())
