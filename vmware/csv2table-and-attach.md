Read CSV, populate table, and attach original CSV file

* Install magic module
```
[steve@localhost vmware]$ pip install python-magic
Defaulting to user installation because normal site-packages is not writeable
Collecting python-magic
  Downloading python_magic-0.4.27-py2.py3-none-any.whl (13 kB)
Installing collected packages: python-magic
  WARNING: Value for scheme.platlib does not match. Please report this to <https://github.com/pypa/pip/issues/10151>
  distutils: /home/steve/.local/lib/python3.9/site-packages
  sysconfig: /home/steve/.local/lib64/python3.9/site-packages
  WARNING: Additional context:
  user = True
  home = None
  root = None
  prefix = None
Successfully installed python-magic-0.4.27
[steve@localhost vmware]$ 
```

* Run

```
[steve@localhost vmware]$ cat data.csv
#server,cpu1,cpu2,cpu3
foo,10,20,30
bar,15,25,15
[steve@localhost vmware]$ ./csv2table-and-attach.py
[steve@localhost vmware]$
```

![attach1](images/csv2table-and-attach-1.png?raw=true "attach1")
![attach2](images/csv2table-and-attach-2.png?raw=true "attach2")
