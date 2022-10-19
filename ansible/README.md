- [ansiblenotes](#ansiblenotes)
  * [Install](#install)
  * [Setup overview](#setup-overview)
  * [Create inventory](#create-inventory)
  * [Connection test](#connection-test)
  * [Grouping test](#grouping-test)
  * [Run arbitrary command across all hosts](#run-arbitrary-command-across-all-hosts)
  * [Playbook 01 - sudo test](#playbook-01---sudo-test)
  * [Playbook 02 - install zsh](#playbook-02---install-zsh)
  * [Playbook 03 - install multiple packages using items](#playbook-03---install-multiple-packages-using-items)
  * [Play 04 - create motd using template](#play-04---create-motd-using-template)
  * [Play 05 - Create group, user, profile with param based content](#play-05---create-group--user--profile-with-param-based-content)
  * [Playbook 06 - CIS hardening](#playbook-06---cis-hardening)
  * [todo](#todo)

# ansiblenotes

## Install

<details>
 <summary>Install on RHEL7 (RPM name is ansible)</summary><p>

```sh
[steve@localhost ~]$ sudo subscription-manager list --available --matches='Red Hat Developer Subscription for Individuals' --pool-only
8a82c49480fcdc8601810729bc891985
[steve@localhost ~]$ sudo subscription-manager attach --pool=8a82c49480fcdc8601810729bc891985
Successfully attached a subscription for: Red Hat Developer Subscription for Individuals
[steve@localhost ~]$ sudo subscription-manager repos --list|grep '^Repo ID:.*ansible-[0-9\.]*-rpms'|sort
Repo ID:   rhel-7-server-ansible-2.4-rpms
Repo ID:   rhel-7-server-ansible-2.5-rpms
Repo ID:   rhel-7-server-ansible-2.6-rpms
Repo ID:   rhel-7-server-ansible-2.7-rpms
Repo ID:   rhel-7-server-ansible-2.8-rpms
Repo ID:   rhel-7-server-ansible-2.9-rpms
Repo ID:   rhel-7-server-ansible-2-rpms
[steve@localhost ~]$ sudo subscription-manager repos --enable rhel-7-server-ansible-2.9-rpms
[sudo] password for steve:
Repository 'rhel-7-server-ansible-2.9-rpms' is enabled for this system.
[steve@localhost ~]$ sudo yum install -y ansible
Loaded plugins: product-id, search-disabled-repos, subscription-manager
Resolving Dependencies
--> Running transaction check
---> Package ansible.noarch 0:2.9.27-1.el7ae will be installed
--> Processing Dependency: PyYAML for package: ansible-2.9.27-1.el7ae.noarch
--> Processing Dependency: python-jinja2 for package: ansible-2.9.27-1.el7ae.noarch
--> Processing Dependency: python-paramiko for package: ansible-2.9.27-1.el7ae.noarch
--> Processing Dependency: python2-cryptography for package: ansible-2.9.27-1.el7ae.noarch
--> Processing Dependency: sshpass for package: ansible-2.9.27-1.el7ae.noarch
--> Running transaction check
---> Package PyYAML.x86_64 0:3.10-11.el7 will be installed
--> Processing Dependency: libyaml-0.so.2()(64bit) for package: PyYAML-3.10-11.el7.x86_64
---> Package python-jinja2.noarch 0:2.7.2-4.el7 will be installed
--> Processing Dependency: python-babel >= 0.8 for package: python-jinja2-2.7.2-4.el7.noarch
--> Processing Dependency: python-markupsafe for package: python-jinja2-2.7.2-4.el7.noarch
---> Package python-paramiko.noarch 0:2.1.1-9.el7 will be installed
--> Processing Dependency: python2-pyasn1 for package: python-paramiko-2.1.1-9.el7.noarch
---> Package python2-cryptography.x86_64 0:1.7.2-2.el7 will be installed
--> Processing Dependency: python-cffi >= 1.4.1 for package: python2-cryptography-1.7.2-2.el7.x86_64
--> Processing Dependency: python-idna >= 2.0 for package: python2-cryptography-1.7.2-2.el7.x86_64
--> Processing Dependency: python-enum34 for package: python2-cryptography-1.7.2-2.el7.x86_64
---> Package sshpass.x86_64 0:1.06-2.el7 will be installed
--> Running transaction check
---> Package libyaml.x86_64 0:0.1.4-11.el7_0 will be installed
---> Package python-babel.noarch 0:0.9.6-8.el7 will be installed
---> Package python-cffi.x86_64 0:1.6.0-5.el7 will be installed
--> Processing Dependency: python-pycparser for package: python-cffi-1.6.0-5.el7.x86_64
---> Package python-enum34.noarch 0:1.0.4-1.el7 will be installed
---> Package python-idna.noarch 0:2.4-1.el7 will be installed
---> Package python-markupsafe.x86_64 0:0.11-10.el7 will be installed
---> Package python2-pyasn1.noarch 0:0.1.9-7.el7 will be installed
--> Running transaction check
---> Package python-pycparser.noarch 0:2.14-1.el7 will be installed
--> Processing Dependency: python-ply for package: python-pycparser-2.14-1.el7.noarch
--> Running transaction check
---> Package python-ply.noarch 0:3.4-11.el7 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

===================================================================================
 Package              Arch   Version          Repository                      Size
===================================================================================
Installing:
 ansible              noarch 2.9.27-1.el7ae   rhel-7-server-ansible-2.9-rpms  17 M
Installing for dependencies:
 PyYAML               x86_64 3.10-11.el7      rhel-7-server-rpms             153 k
 libyaml              x86_64 0.1.4-11.el7_0   rhel-7-server-rpms              55 k
 python-babel         noarch 0.9.6-8.el7      rhel-7-server-rpms             1.4 M
 python-cffi          x86_64 1.6.0-5.el7      rhel-7-server-rpms             218 k
 python-enum34        noarch 1.0.4-1.el7      rhel-7-server-rpms              52 k
 python-idna          noarch 2.4-1.el7        rhel-7-server-rpms              94 k
 python-jinja2        noarch 2.7.2-4.el7      rhel-7-server-rpms             519 k
 python-markupsafe    x86_64 0.11-10.el7      rhel-7-server-rpms              25 k
 python-paramiko      noarch 2.1.1-9.el7      rhel-7-server-rpms             269 k
 python-ply           noarch 3.4-11.el7       rhel-7-server-rpms             123 k
 python-pycparser     noarch 2.14-1.el7       rhel-7-server-rpms             105 k
 python2-cryptography x86_64 1.7.2-2.el7      rhel-7-server-rpms             503 k
 python2-pyasn1       noarch 0.1.9-7.el7      rhel-7-server-rpms             100 k
 sshpass              x86_64 1.06-2.el7       rhel-7-server-ansible-2.9-rpms  21 k

Transaction Summary
===================================================================================
Install  1 Package (+14 Dependent packages)

Total download size: 21 M
Installed size: 119 M
Downloading packages:
warning: /var/cache/yum/x86_64/7Server/rhel-7-server-rpms/packages/PyYAML-3.10-11.el7.x86_64.rpm: Header V3 RSA/SHA256 Signature, key ID fd431d51: NOKEY
Public key for PyYAML-3.10-11.el7.x86_64.rpm is not installed
(1/15): PyYAML-3.10-11.el7.x86_64.rpm                       | 153 kB  00:00:00
(2/15): libyaml-0.1.4-11.el7_0.x86_64.rpm                   |  55 kB  00:00:00
(3/15): python-cffi-1.6.0-5.el7.x86_64.rpm                  | 218 kB  00:00:00
Public key for ansible-2.9.27-1.el7ae.noarch.rpm is not installed
(4/15): ansible-2.9.27-1.el7ae.noarch.rpm                   |  17 MB  00:00:01
(5/15): python-babel-0.9.6-8.el7.noarch.rpm                 | 1.4 MB  00:00:00
(6/15): python-enum34-1.0.4-1.el7.noarch.rpm                |  52 kB  00:00:00
(7/15): python-idna-2.4-1.el7.noarch.rpm                    |  94 kB  00:00:00
(8/15): python-jinja2-2.7.2-4.el7.noarch.rpm                | 519 kB  00:00:00
(9/15): python-markupsafe-0.11-10.el7.x86_64.rpm            |  25 kB  00:00:00
(10/15): python-paramiko-2.1.1-9.el7.noarch.rpm             | 269 kB  00:00:00
(11/15): python-ply-3.4-11.el7.noarch.rpm                   | 123 kB  00:00:00
(12/15): python-pycparser-2.14-1.el7.noarch.rpm             | 105 kB  00:00:00
(13/15): python2-cryptography-1.7.2-2.el7.x86_64.rpm        | 503 kB  00:00:00
(14/15): python2-pyasn1-0.1.9-7.el7.noarch.rpm              | 100 kB  00:00:00
(15/15): sshpass-1.06-2.el7.x86_64.rpm                      |  21 kB  00:00:01
-----------------------------------------------------------------------------------
Total                                                 4.7 MB/s |  21 MB  00:04
Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
Importing GPG key 0xFD431D51:
 Userid     : "Red Hat, Inc. (release key 2) <security@redhat.com>"
 Fingerprint: 567e 347a d004 4ade 55ba 8a5f 199e 2f91 fd43 1d51
 Package    : redhat-release-server-7.9-3.el7.x86_64 (@anaconda/7.9)
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
Importing GPG key 0x2FA658E0:
 Userid     : "Red Hat, Inc. (auxiliary key) <security@redhat.com>"
 Fingerprint: 43a6 e49c 4a38 f4be 9abf 2a53 4568 9c88 2fa6 58e0
 Package    : redhat-release-server-7.9-3.el7.x86_64 (@anaconda/7.9)
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : python2-pyasn1-0.1.9-7.el7.noarch                              1/15
  Installing : sshpass-1.06-2.el7.x86_64                                      2/15
  Installing : python-babel-0.9.6-8.el7.noarch                                3/15
  Installing : python-markupsafe-0.11-10.el7.x86_64                           4/15
  Installing : python-jinja2-2.7.2-4.el7.noarch                               5/15
  Installing : python-enum34-1.0.4-1.el7.noarch                               6/15
  Installing : python-ply-3.4-11.el7.noarch                                   7/15
  Installing : python-pycparser-2.14-1.el7.noarch                             8/15
  Installing : python-cffi-1.6.0-5.el7.x86_64                                 9/15
  Installing : libyaml-0.1.4-11.el7_0.x86_64                                 10/15
  Installing : PyYAML-3.10-11.el7.x86_64                                     11/15
  Installing : python-idna-2.4-1.el7.noarch                                  12/15
  Installing : python2-cryptography-1.7.2-2.el7.x86_64                       13/15
  Installing : python-paramiko-2.1.1-9.el7.noarch                            14/15
  Installing : ansible-2.9.27-1.el7ae.noarch                                 15/15
  Verifying  : python-idna-2.4-1.el7.noarch                                   1/15
  Verifying  : libyaml-0.1.4-11.el7_0.x86_64                                  2/15
  Verifying  : python-ply-3.4-11.el7.noarch                                   3/15
  Verifying  : python-enum34-1.0.4-1.el7.noarch                               4/15
  Verifying  : ansible-2.9.27-1.el7ae.noarch                                  5/15
  Verifying  : python-paramiko-2.1.1-9.el7.noarch                             6/15
  Verifying  : python-markupsafe-0.11-10.el7.x86_64                           7/15
  Verifying  : python-babel-0.9.6-8.el7.noarch                                8/15
  Verifying  : python-cffi-1.6.0-5.el7.x86_64                                 9/15
  Verifying  : sshpass-1.06-2.el7.x86_64                                     10/15
  Verifying  : python-jinja2-2.7.2-4.el7.noarch                              11/15
  Verifying  : python2-pyasn1-0.1.9-7.el7.noarch                             12/15
  Verifying  : PyYAML-3.10-11.el7.x86_64                                     13/15
  Verifying  : python-pycparser-2.14-1.el7.noarch                            14/15
  Verifying  : python2-cryptography-1.7.2-2.el7.x86_64                       15/15
rhel-7-server-ansible-2.9-rpms/x86_64/productid             | 2.1 kB  00:00:00
rhel-7-server-rpms/7Server/x86_64/productid                 | 2.1 kB  00:00:00

Installed:
  ansible.noarch 0:2.9.27-1.el7ae

Dependency Installed:
  PyYAML.x86_64 0:3.10-11.el7           libyaml.x86_64 0:0.1.4-11.el7_0
  python-babel.noarch 0:0.9.6-8.el7     python-cffi.x86_64 0:1.6.0-5.el7
  python-enum34.noarch 0:1.0.4-1.el7    python-idna.noarch 0:2.4-1.el7
  python-jinja2.noarch 0:2.7.2-4.el7    python-markupsafe.x86_64 0:0.11-10.el7
  python-paramiko.noarch 0:2.1.1-9.el7  python-ply.noarch 0:3.4-11.el7
  python-pycparser.noarch 0:2.14-1.el7  python2-cryptography.x86_64 0:1.7.2-2.el7
  python2-pyasn1.noarch 0:0.1.9-7.el7   sshpass.x86_64 0:1.06-2.el7

Complete!
[steve@localhost ~]$
```
</p></details>

<details>
 <summary>Install on RHEL8/9 (RPM name is ansible-core)</summary><p>

```sh
$ sudo dnf search ansible
Updating Subscription Management repositories.
Last metadata expiration check: 0:07:46 ago on Mon 10 Oct 2022 14:03:10 BST.
========================= Name & Summary Matched: ansible =========================
ansible-collection-microsoft-sql.noarch : The Ansible collection for Microsoft SQL
                                        : Server management
ansible-collection-redhat-rhel_mgmt.noarch : Ansible Collection of general system
     ...: management and utility modules and other plugins
ansible-freeipa-tests.noarch : ansible-freeipa tests
ansible-pcp.noarch : Ansible Metric collection for Performance Co-Pilot
ansible-test.x86_64 : Tool for testing ansible plugin and module code
============================== Name Matched: ansible ==============================
ansible-core.x86_64 : SSH-based configuration management, deployment, and task
                    : execution system
ansible-freeipa.noarch : Roles and playbooks to deploy FreeIPA servers, replicas
                       : and clients
============================ Summary Matched: ansible =============================
rhc-worker-playbook.x86_64 : Python worker for Red Hat connector that launches
                           : Ansible Runner
$ sudo dnf install -y ansible-core
Updating Subscription Management repositories.
Last metadata expiration check: 0:07:59 ago on Mon 10 Oct 2022 14:03:10 BST.
Dependencies resolved.
===================================================================================
 Package              Arch   Version        Repository                        Size
===================================================================================
Installing:
 ansible-core         x86_64 2.12.2-2.el9_0 rhel-9-for-x86_64-appstream-rpms 2.4 M
Installing dependencies:
 python3-babel        noarch 2.9.1-2.el9    rhel-9-for-x86_64-appstream-rpms 6.0 M
 python3-cffi         x86_64 1.14.5-5.el9   rhel-9-for-x86_64-appstream-rpms 257 k
 python3-cryptography x86_64 36.0.1-1.el9_0 rhel-9-for-x86_64-appstream-rpms 1.2 M
 python3-jinja2       noarch 2.11.3-4.el9   rhel-9-for-x86_64-appstream-rpms 253 k
 python3-markupsafe   x86_64 1.1.1-12.el9   rhel-9-for-x86_64-appstream-rpms  39 k
 python3-packaging    noarch 20.9-5.el9     rhel-9-for-x86_64-appstream-rpms  81 k
 python3-ply          noarch 3.11-14.el9    rhel-9-for-x86_64-appstream-rpms 111 k
 python3-pycparser    noarch 2.20-6.el9     rhel-9-for-x86_64-appstream-rpms 139 k
 python3-pyparsing    noarch 2.4.7-9.el9    rhel-9-for-x86_64-baseos-rpms    154 k
 python3-pytz         noarch 2021.1-4.el9   rhel-9-for-x86_64-appstream-rpms  56 k
 python3-resolvelib   noarch 0.5.4-5.el9    rhel-9-for-x86_64-appstream-rpms  38 k

Transaction Summary
===================================================================================
Install  12 Packages

Total download size: 11 M
Installed size: 45 M
Downloading Packages:
(1/12): python3-jinja2-2.11.3-4.el9.noarch.rpm     682 kB/s | 253 kB     00:00
(2/12): python3-cffi-1.14.5-5.el9.x86_64.rpm       641 kB/s | 257 kB     00:00
(3/12): python3-resolvelib-0.5.4-5.el9.noarch.rpm   94 kB/s |  38 kB     00:00
(4/12): python3-pycparser-2.20-6.el9.noarch.rpm    907 kB/s | 139 kB     00:00
(5/12): python3-markupsafe-1.1.1-12.el9.x86_64.rpm 237 kB/s |  39 kB     00:00
(6/12): python3-packaging-20.9-5.el9.noarch.rpm    453 kB/s |  81 kB     00:00
(7/12): python3-pytz-2021.1-4.el9.noarch.rpm       219 kB/s |  56 kB     00:00
(8/12): python3-babel-2.9.1-2.el9.noarch.rpm        12 MB/s | 6.0 MB     00:00
(9/12): python3-cryptography-36.0.1-1.el9_0.x86_64 5.2 MB/s | 1.2 MB     00:00
(10/12): python3-ply-3.11-14.el9.noarch.rpm        662 kB/s | 111 kB     00:00
(11/12): ansible-core-2.12.2-2.el9_0.x86_64.rpm    7.4 MB/s | 2.4 MB     00:00
(12/12): python3-pyparsing-2.4.7-9.el9.noarch.rpm  729 kB/s | 154 kB     00:00
-----------------------------------------------------------------------------------
Total                                              9.1 MB/s |  11 MB     00:01
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                           1/1
  Installing       : python3-pyparsing-2.4.7-9.el9.noarch                     1/12
  Installing       : python3-packaging-20.9-5.el9.noarch                      2/12
  Installing       : python3-ply-3.11-14.el9.noarch                           3/12
  Installing       : python3-pycparser-2.20-6.el9.noarch                      4/12
  Installing       : python3-cffi-1.14.5-5.el9.x86_64                         5/12
  Installing       : python3-cryptography-36.0.1-1.el9_0.x86_64               6/12
  Installing       : python3-pytz-2021.1-4.el9.noarch                         7/12
  Installing       : python3-babel-2.9.1-2.el9.noarch                         8/12
  Installing       : python3-markupsafe-1.1.1-12.el9.x86_64                   9/12
  Installing       : python3-jinja2-2.11.3-4.el9.noarch                      10/12
  Installing       : python3-resolvelib-0.5.4-5.el9.noarch                   11/12
  Installing       : ansible-core-2.12.2-2.el9_0.x86_64                      12/12
  Running scriptlet: ansible-core-2.12.2-2.el9_0.x86_64                      12/12
  Verifying        : python3-cffi-1.14.5-5.el9.x86_64                         1/12
  Verifying        : python3-resolvelib-0.5.4-5.el9.noarch                    2/12
  Verifying        : python3-jinja2-2.11.3-4.el9.noarch                       3/12
  Verifying        : python3-pycparser-2.20-6.el9.noarch                      4/12
  Verifying        : python3-markupsafe-1.1.1-12.el9.x86_64                   5/12
  Verifying        : python3-babel-2.9.1-2.el9.noarch                         6/12
  Verifying        : python3-packaging-20.9-5.el9.noarch                      7/12
  Verifying        : python3-pytz-2021.1-4.el9.noarch                         8/12
  Verifying        : python3-cryptography-36.0.1-1.el9_0.x86_64               9/12
  Verifying        : ansible-core-2.12.2-2.el9_0.x86_64                      10/12
  Verifying        : python3-ply-3.11-14.el9.noarch                          11/12
  Verifying        : python3-pyparsing-2.4.7-9.el9.noarch                    12/12
Installed products updated.

Installed:
  ansible-core-2.12.2-2.el9_0.x86_64   python3-babel-2.9.1-2.el9.noarch
  python3-cffi-1.14.5-5.el9.x86_64     python3-cryptography-36.0.1-1.el9_0.x86_64
  python3-jinja2-2.11.3-4.el9.noarch   python3-markupsafe-1.1.1-12.el9.x86_64
  python3-packaging-20.9-5.el9.noarch  python3-ply-3.11-14.el9.noarch
  python3-pycparser-2.20-6.el9.noarch  python3-pyparsing-2.4.7-9.el9.noarch
  python3-pytz-2021.1-4.el9.noarch     python3-resolvelib-0.5.4-5.el9.noarch

Complete!
$
```
</p></details>

## Setup overview

5 virtualbox VMs, as below

|Host|IP|OS|Description|
|----|--|--|-----------|
|rhel9|192.168.0.54|RHEL9|Control machine|
|ans1|192.168.0.150|RHEL8|-|
|ans2|192.168.0.152|RHEL9|-|
|ans3|192.168.0.153|RHEL7|-|
|ans4|192.168.0.154|Debian11|-|


- User 'steve' created on all 5 VMs.
- sudoers entry added to each VM, `steve ALL=(ALL) NOPASSWD: ALL`.
- ssh creds setup to permit host rhel9 to ssh to each server.

## Create inventory

```sh
$ cat inv
ans1
ans2
ans3
ans4
$
```

## Connection test

```sh
$ ansible all -i inv -m ping
ans4 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
ans3 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
ans1 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/libexec/platform-python"
    },
    "changed": false,
    "ping": "pong"
}
ans2 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
$
```

## Grouping test

```sh
$ cat groupinv
[rhel]
ans1
ans2
ans3

[debian]
ans4
$ ansible rhel -i groupinv -m ping
ans3 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
ans2 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
ans1 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/libexec/platform-python"
    },
    "changed": false,
    "ping": "pong"
}
```

## Run arbitrary command across all hosts

```sh
$ ansible all -i groupinv -a uptime
ans4 | CHANGED | rc=0 >>
 05:02:17 up  1:03,  1 user,  load average: 0.06, 0.03, 0.01
ans3 | CHANGED | rc=0 >>
 05:02:17 up  1:08,  1 user,  load average: 0.00, 0.01, 0.05
ans2 | CHANGED | rc=0 >>
 10:02:17 up  1:08,  1 user,  load average: 0.08, 0.02, 0.01
ans1 | CHANGED | rc=0 >>
 05:02:17 up  1:08,  1 user,  load average: 0.13, 0.10, 0.08
$
```

Needs `-b` to become root on remote host.

```sh
$ ansible debian -a 'tail /var/log/messages'
ans4 | FAILED | rc=1 >>
tail: cannot open '/var/log/messages' for reading: Permission deniednon-zero return code
$ ansible debian -ba 'tail /var/log/messages'
ans4 | CHANGED | rc=0 >>
Oct 11 05:09:33 ans4 pipewire-media-session[5630]: could not set nice-level to -11: Permission denied
Oct 11 05:09:33 ans4 pipewire-media-session[5630]: could not make thread realtime: Permission denied
Oct 11 05:09:33 ans4 tracker-extract[5619]: Setting priority nice level to 19
Oct 11 05:09:33 ans4 tracker-miner-f[5621]: Setting priority nice level to 19
Oct 11 05:09:34 ans4 pulseaudio[5618]: Disabling timer-based scheduling because running inside a VM.
Oct 11 05:09:34 ans4 pulseaudio[5618]: Disabling timer-based scheduling because running inside a VM.
Oct 11 05:09:34 ans4 goa-daemon[5685]: goa-daemon version 3.38.0 starting
Oct 11 05:09:35 ans4 ansible-ansible.legacy.command: Invoked with _raw_params=tail /var/log/messages _uses_shell=False warn=False stdin_add_newline=True strip_empty_ends=True argv=None chdir=None executable=None creates=None removes=None stdin=None
Oct 11 05:09:51 ans4 ansible-ansible.legacy.command: Invoked with _raw_params=tail /var/log/messages _uses_shell=False warn=False stdin_add_newline=True strip_empty_ends=True argv=None chdir=None executable=None creates=None removes=None stdin=None
Oct 11 05:09:57 ans4 ansible-ansible.legacy.command: Invoked with _raw_params=tail /var/log/messages _uses_shell=False warn=False stdin_add_newline=True strip_empty_ends=True argv=None chdir=None executable=None creates=None removes=None stdin=None
$
```

Install packages directly.

```sh
$ ansible rhel -b -m package -a name=foomatic
ans2 | CHANGED => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": true,
    "msg": "",
    "rc": 0,
...
```

## Playbook 01 - sudo test

Test sudo aspect.

```sh
$ cat sudotest.yml
---

- hosts: all
  become: true
  tasks:
    - name: Make sure we can connect
      ping:
$ ansible-playbook -i ../groupinv sudotest.yml

PLAY [all] ***********************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************
ok: [ans4]
ok: [ans3]
ok: [ans1]
ok: [ans2]

TASK [Make sure we can connect] **************************************************************************************
ok: [ans4]
ok: [ans3]
ok: [ans1]
ok: [ans2]

PLAY RECAP ***********************************************************************************************************
ans1                       : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ans2                       : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ans3                       : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ans4                       : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

$
```

## Playbook 02 - install zsh

Use the rhel / debian node group names to determine whether to use yum or apt.

Second run works, shows changed=0.

```sh
$ cat installzsh.yml
---

- hosts: all
  become: true
  tasks:
    - name: Make sure we can connect
      ping:

- hosts: debian
  become: true
  tasks:
    - name: Install zsh on debian
      apt: name=zsh state=present


- hosts: rhel
  become: true
  tasks:
    - name: Install zsh on rhel
      yum: name=zsh state=present


$ ansible-playbook -i ../groupinv installzsh.yml

PLAY [all] **************************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************
ok: [ans4]
ok: [ans3]
ok: [ans2]
ok: [ans1]

TASK [Make sure we can connect] *****************************************************************************************************************************
ok: [ans4]
ok: [ans3]
ok: [ans1]
ok: [ans2]

PLAY [debian] ***********************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************
ok: [ans4]

TASK [Install zsh on debian] ********************************************************************************************************************************
changed: [ans4]

PLAY [rhel] *************************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************
ok: [ans3]
ok: [ans1]
ok: [ans2]

TASK [Install zsh on rhel] **********************************************************************************************************************************
changed: [ans2]
changed: [ans1]
changed: [ans3]

PLAY RECAP **************************************************************************************************************************************************
ans1                       : ok=4    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ans2                       : ok=4    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ans3                       : ok=4    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ans4                       : ok=4    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

$ ansible-playbook -i ../groupinv installzsh.yml

PLAY [all] **************************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************
ok: [ans4]
ok: [ans3]
ok: [ans1]
ok: [ans2]

TASK [Make sure we can connect] *****************************************************************************************************************************
ok: [ans4]
ok: [ans3]
ok: [ans1]
ok: [ans2]

PLAY [debian] ***********************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************
ok: [ans4]

TASK [Install zsh on debian] ********************************************************************************************************************************
ok: [ans4]

PLAY [rhel] *************************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************
ok: [ans3]
ok: [ans1]
ok: [ans2]

TASK [Install zsh on rhel] **********************************************************************************************************************************
ok: [ans2]
ok: [ans3]
ok: [ans1]

PLAY RECAP **************************************************************************************************************************************************
ans1                       : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ans2                       : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ans3                       : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ans4                       : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

$
```

## Playbook 03 - install multiple packages using items

```sh
$ cat installmany.yml
---

- hosts: debian
  become: true
  tasks:
    - name: Install zip tools on debian
      apt: name={{item}} state=present
      with_items:
        - zip
        - zipcmp
        - zipmerge
        - ziptime
$ ansible-playbook -i ../groupinv installmany.yml

PLAY [debian] ***********************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************
ok: [ans4]

TASK [Install zip tools on debian] ********************************************************************************************************************************
changed: [ans4] => (item=zip)
changed: [ans4] => (item=zipcmp)
changed: [ans4] => (item=zipmerge)
changed: [ans4] => (item=ziptime)

PLAY RECAP **************************************************************************************************************************************************
ans4                       : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

$
```

## Play 04 - create motd using template

```sh
$ cat template.yml
---

- hosts: all
  become: true
  tasks:
    - name: Create new motd
      template: src=templates/motd.j2 dest=/etc/motd
$ cat templates/motd.j2
Hello, welcome to {{ansible_hostname}}
$ ansible-playbook -i ../groupinv template.yml

PLAY [all] **************************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************
ok: [ans4]
ok: [ans3]
ok: [ans1]
ok: [ans2]

TASK [Create new motd] **************************************************************************************************************************************
changed: [ans4]
changed: [ans3]
changed: [ans1]
changed: [ans2]

PLAY RECAP **************************************************************************************************************************************************
ans1                       : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ans2                       : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ans3                       : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ans4                       : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

$ ssh ans1 cat /etc/motd
Hello, welcome to ans1
$
```

## Play 05 - Create group, user, profile with param based content

```sh
$ ansible-playbook -i ../groupinv -e msg='foo' user.yml

PLAY [all] *********************************************************************************************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************************************************************
ok: [ans4]
ok: [ans3]
ok: [ans1]
ok: [ans2]

TASK [Create group bobgrp] *****************************************************************************************************************************************************************************
changed: [ans4]
ok: [ans3]
ok: [ans1]
ok: [ans2]

TASK [Create user bob] *********************************************************************************************************************************************************************************
changed: [ans4]
ok: [ans3]
ok: [ans2]
ok: [ans1]

TASK [Create new bash profile] *************************************************************************************************************************************************************************
changed: [ans4]
ok: [ans3]
ok: [ans1]
ok: [ans2]

PLAY RECAP *********************************************************************************************************************************************************************************************
ans1                       : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ans2                       : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ans3                       : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ans4                       : ok=4    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

$ ssh ans4 sudo cat /home/bob/.bash_profile

echo Hello Bob. foo
$
```

## Playbook 06 - CIS hardening

```sh
$ ansible-playbook -i 'ans1,' site.yml

PLAY [all] *********************************************************************

TASK [Gathering Facts] *********************************************************
ok: [ans1]

TASK [cis : include_tasks] *****************************************************
skipping: [ans1]

TASK [cis : include_tasks] *****************************************************
included: /home/steve/mynotes/ansible/play06/cis/tasks/rhel8.yml for ans1

TASK [cis : 1.1.1.1 Ensure mounting of cramfs filesystems is disabled] *********
ok: [ans1]

TASK [cis : 1.1.1.2 Ensure mounting of squashfs filesystems is disabled] *******
ok: [ans1]

TASK [cis : 1.1.1.3 Ensure mounting of udf filesystems is disabled] ************
ok: [ans1]

TASK [cis : 1.1.2.1 Ensure /tmp is a separate partition] ***********************
changed: [ans1]

TASK [cis : 1.1.2.1 Ensure /tmp is a separate partition - check results] *******
ok: [ans1] => {
    "msg": "check"
}

TASK [cis : 1.1.2.2 Ensure nodev option set on /tmp partition] *****************
fatal: [ans1]: FAILED! => {"changed": true, "cmd": "grep -E \"^\\S* /tmp \\S* .*nodev\" /proc/mounts", "delta": "0:00:00.015870", "end": "2022-10-17 15:29:55.753304", "msg": "non-zero return code", "rc": 1, "start": "2022-10-17 15:29:55.737434", "stderr": "", "stderr_lines": [], "stdout": "", "stdout_lines": []}

PLAY RECAP *********************************************************************
ans1                       : ok=7    changed=1    unreachable=0    failed=1    skipped=1    rescued=0    ignored=0

$
```

## todo

* todo
- blah
