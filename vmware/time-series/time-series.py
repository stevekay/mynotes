#!/usr/bin/python3

from atlassian import Confluence
from datetime import datetime, timezone
import pandas as pd

SPACE = 'BOB'
PAGE = 'gtest2'
VROPSFILE = 'vrops.txt'

# Log onto confluence
c = Confluence(url='http://localhost:8090',
               username='admin',
               password='admin')

x = open(VROPSFILE, 'r')

#vrops.cpu.demand 2.929333448410034 1505122200 source=vm01.foo.com

hosts={}

for line in x:
    print("Line=",line.strip())
    (vname,vval,vdate,vsrc)=line.split()
    vsrc = vsrc[7:]
    print(" name=",vname,"vval=",vval,"vdate=",vdate,"vsrc=",vsrc)
    if not vsrc in hosts:
        hosts[vsrc]={}

    if not vname in hosts[vsrc]:
        hosts[vsrc][vname]={}

    hosts[vsrc][vname][vdate]=vval

x.close()
	
s = '<p class="auto-cursor-target"><br /></p><ac:structured-macro ac:name="chart" ac:schema-version="1" ac:macro-id="88e8443e-37cd-4537-8f62-6a93901b7765"><ac:parameter ac:name="type">line</ac:parameter><ac:rich-text-body>'

print(hosts)

for h in hosts:
    print("processing host",h)
    s = s + "<table><tr><td> </td>\n"
    for v in hosts[h]:
        print("  ",v)
        for d in hosts[h][v]:
            print("    ",d,"=",hosts[h][v][d])
            z = datetime.fromtimestamp(int(d), timezone.utc)
            print(z)
            y = z.strftime("%d/%m/%y %H:%M")
            print(y)
            s = s + '<td>' + y + '</td>'
        s = s + "</tr>\n"
        s = s + '<tr><td>' + h + '</td>'
        # values
        for d in hosts[h][v]:
            s = s + '<td>' + hosts[h][v][d] + '</td>'

        s = s + "</tr>\n"
    s = s + "</table>\n"

# footer
s = s + '</ac:rich-text-body></ac:structured-macro>'

print("s="+s)

pageid = c.get_page_id(SPACE,PAGE)
c.update_page(pageid,PAGE,s)
