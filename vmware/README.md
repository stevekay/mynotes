VMware, Confluence stats

* Turn on confluence API

![api](./enable-api.png?raw=true "api")

* Install confluence and pandas modules
```
[steve@localhost vmware]$ pip install atlassian-python-api pandas
Defaulting to user installation because normal site-packages is not writeable
Collecting atlassian-python-api
  Downloading atlassian-python-api-3.31.1.tar.gz (140 kB)
     |████████████████████████████████| 140 kB 1.5 MB/s
  Installing build dependencies ... done
  Getting requirements to build wheel ... done
    Preparing wheel metadata ... done
Collecting pandas
  Downloading pandas-1.5.2-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (12.2 MB)
     |████████████████████████████████| 12.2 MB 9.8 MB/s
Collecting requests-oauthlib
  Downloading requests_oauthlib-1.3.1-py2.py3-none-any.whl (23 kB)
Requirement already satisfied: requests in /usr/lib/python3.9/site-packages (from atlassian-python-api) (2.25.1)
Requirement already satisfied: six in /usr/lib/python3.9/site-packages (from atlassian-python-api) (1.15.0)
Collecting oauthlib
  Downloading oauthlib-3.2.2-py3-none-any.whl (151 kB)
     |████████████████████████████████| 151 kB 41.2 MB/s
Collecting deprecated
  Downloading Deprecated-1.2.13-py2.py3-none-any.whl (9.6 kB)
Requirement already satisfied: python-dateutil>=2.8.1 in /usr/lib/python3.9/site-packages (from pandas) (2.8.1)
Collecting numpy>=1.20.3
  Downloading numpy-1.23.5-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (17.1 MB)
     |████████████████████████████████| 17.1 MB 2.9 MB/s
Collecting pytz>=2020.1
  Downloading pytz-2022.6-py2.py3-none-any.whl (498 kB)
     |████████████████████████████████| 498 kB 15.8 MB/s
Collecting wrapt<2,>=1.10
  Downloading wrapt-1.14.1-cp39-cp39-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_17_x86_64.manylinux2014_x86_64.whl (77 kB)
     |████████████████████████████████| 77 kB 8.8 MB/s
Requirement already satisfied: urllib3<1.27,>=1.21.1 in /usr/lib/python3.9/site-packages (from requests->atlassian-python-api) (1.26.5)
Requirement already satisfied: chardet<5,>=3.0.2 in /usr/lib/python3.9/site-packages (from requests->atlassian-python-api) (4.0.0)
Requirement already satisfied: idna<3,>=2.5 in /usr/lib/python3.9/site-packages (from requests->atlassian-python-api) (2.10)
Building wheels for collected packages: atlassian-python-api
  Building wheel for atlassian-python-api (PEP 517) ... done
  Created wheel for atlassian-python-api: filename=atlassian_python_api-3.31.1-py3-none-any.whl size=142761 sha256=edf551d3174cbceb5e0f656eea3143ca356e3864070e406da8781b7efea918b1
  Stored in directory: /home/steve/.cache/pip/wheels/f7/de/2d/a91d5bce779fc9292fdc9edd1838afd948c611dff3dadafa48
Successfully built atlassian-python-api
Installing collected packages: wrapt, oauthlib, requests-oauthlib, pytz, numpy, deprecated, pandas, atlassian-python-api
  WARNING: Value for scheme.platlib does not match. Please report this to <https://github.com/pypa/pip/issues/10151>
  distutils: /home/steve/.local/lib/python3.9/site-packages
  sysconfig: /home/steve/.local/lib64/python3.9/site-packages
  WARNING: Additional context:
  user = True
  home = None
  root = None
  prefix = None
Successfully installed atlassian-python-api-3.31.1 deprecated-1.2.13 numpy-1.23.5 oauthlib-3.2.2 pandas-1.5.2 pytz-2022.6 requests-oauthlib-1.3.1 wrapt-1.14.1
[steve@localhost vmware]$
```

* Read CSV, populate confluence table, [csv2table](csv2table/README.md) 

* Read CSV, populate confluence table, attach original CSV file, [csv2table-and-attach](csv2table-and-attach/README.md)

# TODO

* graph
* filter / summarize

# References

* https://github.com/atlassian-api/atlassian-python-api
