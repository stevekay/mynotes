#!/usr/bin/python3


from atlassian import Confluence
import pandas as pd

SPACE = 'BOB'
DATAPAGE = 'mytestdata'
DATAFILE = 'data.csv'
CONTENTPAGE = 'mytest'
CONTENTFILE = 'content.html'


# Log onto confluence
c = Confluence(url='http://localhost:8090',
               username='admin',
               password='admin')

# Write the content page first
x = open(CONTENTFILE, 'r')
if not c.page_exists(SPACE, CONTENTPAGE):
	c.create_page(
		SPACE,
		CONTENTPAGE,
		x.read(),
		type='page',
		representation='storage',
	)
	contentpageid = c.get_page_id(SPACE, CONTENTPAGE)
else:
	contentpageid = c.get_page_id(SPACE, CONTENTPAGE)

	c.update_page(
		contentpageid,
		CONTENTPAGE,
		x.read()
	)

#
# Write the data page
#
a = pd.read_csv('data.csv')
if not c.page_exists(SPACE, DATAPAGE):
	c.create_page(
		SPACE,
		DATAPAGE,
		a.to_html(),
		parent_id=contentpageid,
		type='page',
		representation='storage'
	)
else:
	# Merely update page, as already exists
	pageid = c.get_page_id(SPACE, DATAPAGE)

	c.update_page(
		pageid,
		DATAPAGE,
		a.to_html()
	)

