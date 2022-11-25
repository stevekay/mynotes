#!/usr/bin/python3

# retrieve a confluence page

from atlassian import Confluence

SPACE = 'BOB'
PAGE = 'hello world'

c = Confluence(url='http://localhost:8090',
               username='admin',
               password='admin')


content = c.get_page_by_title(space=SPACE, title=PAGE)

print(content)
