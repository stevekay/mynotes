#!/usr/bin/python3

from atlassian import Confluence

confluence = Confluence(url="http://localhost:8090", username="admin", password="abc123")

content1 = confluence.get_page_by_title(space="FOO", title="Hello World")

print(content1)
