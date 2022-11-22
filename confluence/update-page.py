#!/usr/bin/python3

from atlassian import Confluence
import pandas as pd

SPACE = 'FOO'
PAGE = 'VROPS stats'

a = pd.read_csv('input.csv')

# Add a totals row
a.loc['Total']=a.sum()
a.loc[a.index[-1], 'name'] = ''
a.loc[a.index[-1], 'description'] = ''

confluence = Confluence(url='http://localhost:8090', 
                        username='admin',
                        password='abc123')

if not confluence.page_exists(SPACE, PAGE):
    print('page does not exist, creating')
    confluence.create_page(SPACE, 
                           PAGE,
                           'This page has our vROps stats',
                           parent_id=None,
                           type='page',
                           representation='storage',
                           editor='v2',
                           full_width=False)

pageid = confluence.get_page_id(SPACE, PAGE)

confluence.update_page(pageid,
                       PAGE,
                       a.to_html(),
                       parent_id=None,
                       type='page',
                       representation='storage',
                       minor_edit=False,
                       full_width=False)
