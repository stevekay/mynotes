# rhel8

## Vanilla RHEL8 box, no subs.

    [root@localhost ~]# subscription-manager identity
    This system is not yet registered. Try 'subscription-manager register --help' for more information.
    [root@localhost ~]# cat /etc/redhat-release
    Red Hat Enterprise Linux release 8.0 (Ootpa)
    [root@localhost ~]#

## Register, attach

    [root@localhost ~]# subscription-manager register
    Registering to: subscription.rhsm.redhat.com:443/subscription
    Username: my-rh-username
    Password: my-rh-password
    The system has been registered with ID: XXXXXXXX-YYYY-ZZZZ-AAAA-BBBBBBBBBBBB
    The registered system name is: localhost.localdomain
    [root@localhost ~]# subscription-manager attach
    Installed Product Current Status:
    Product Name: Red Hat Enterprise Linux for x86_64
    Status:       Subscribed

    [root@localhost ~]#

## Review repos

    [root@localhost ~]# subscription-manager repos|grep "^Repo ID"|sort
    Repo ID:   ansible-2.8-for-rhel-8-x86_64-debug-rpms
    Repo ID:   ansible-2.8-for-rhel-8-x86_64-rpms
    Repo ID:   ansible-2.8-for-rhel-8-x86_64-source-rpms
    Repo ID:   cfme-5.11-for-rhel-8-x86_64-debug-rpms
    Repo ID:   cfme-5.11-for-rhel-8-x86_64-rpms
    Repo ID:   cfme-5.11-for-rhel-8-x86_64-source-rpms
    Repo ID:   codeready-builder-for-rhel-8-x86_64-debug-rpms
    Repo ID:   codeready-builder-for-rhel-8-x86_64-rpms
    Repo ID:   codeready-builder-for-rhel-8-x86_64-source-rpms
    Repo ID:   fast-datapath-beta-for-rhel-8-x86_64-debug-rpms
    Repo ID:   fast-datapath-beta-for-rhel-8-x86_64-rpms
    Repo ID:   fast-datapath-beta-for-rhel-8-x86_64-source-rpms
    Repo ID:   ossm-0-for-rhel-8-x86_64-debug-rpms
    Repo ID:   ossm-0-for-rhel-8-x86_64-rpms
    Repo ID:   ossm-0-for-rhel-8-x86_64-source-rpms
    Repo ID:   rhel-8-for-x86_64-appstream-debug-rpms
    Repo ID:   rhel-8-for-x86_64-appstream-rpms
    Repo ID:   rhel-8-for-x86_64-appstream-source-rpms
    Repo ID:   rhel-8-for-x86_64-baseos-debug-rpms
    Repo ID:   rhel-8-for-x86_64-baseos-rpms
    Repo ID:   rhel-8-for-x86_64-baseos-source-rpms
    Repo ID:   rhel-8-for-x86_64-supplementary-debug-rpms
    Repo ID:   rhel-8-for-x86_64-supplementary-rpms
    Repo ID:   rhel-8-for-x86_64-supplementary-source-rpms
    Repo ID:   RHOCP-4.1-for-rhel-8-x86_64-debug-rpms
    Repo ID:   RHOCP-4.1-for-rhel-8-x86_64-rpms
    Repo ID:   RHOCP-4.1-for-rhel-8-x86_64-source-rpms
    Repo ID:   satellite-tools-6.5-for-rhel-8-x86_64-debug-rpms
    Repo ID:   satellite-tools-6.5-for-rhel-8-x86_64-rpms
    Repo ID:   satellite-tools-6.5-for-rhel-8-x86_64-source-rpms
    [root@localhost ~]#

## Create a RHEL6 container, perform reposync

    [root@localhost ~]# podman pull registry.access.redhat.com/rhel6/rhel
    Trying to pull registry.access.redhat.com/rhel6/rhel...Getting image source signatures
    Copying blob e94c811b9cc4: 87.07 MiB / 87.07 MiB [=========================] 28s
    Copying blob cdefd474e5ab: 1.22 KiB / 1.22 KiB [===========================] 28s
    Copying config c3d7822f2e85: 6.37 KiB / 6.37 KiB [==========================] 0s
    Writing manifest to image destination
    Storing signatures
    c3d7822f2e85d9e4df76c4010e5ba203a5450b5d387f71ff28668181b5d5ab45
    [root@localhost ~]# podman run -it registry.access.redhat.com/rhel6/rhel /bin/bash
    [root@687706d531f2 /]# cat /etc/redhat-release
    Red Hat Enterprise Linux Server release 6.10 (Santiago)
    [root@687706d531f2 /]# yum repolist
    Loaded plugins: ovl, product-id, search-disabled-repos, subscription-manager
    rhel-6-server-rpms                                                                                                                                                                                                    | 3.5 kB     00:00
    rhel-6-server-rpms/primary_db                                                                                                                                                                                         |  59 MB     00:04
    repo id                                                                                                 repo name                                                                                                                      status
    rhel-6-server-rpms                                                                                      Red Hat Enterprise Linux 6 Server (RPMs)                                                                                       20,719
    repolist: 20,719
    [root@687706d531f2 /]# reposync -r rhel-6-server-rpms
    [rhel-6-server-rpms: 1     of 20719 ] Downloading Packages/3/389-ds-base-1.2.8.2-1.el6_1.3.x86_64.rpm
    389-ds-base-1.2.8.2-1.el6_1.3.x86_64.rpm                                                                                                                                                                              | 1.2 MB     00:00
    [rhel-6-server-rpms: 2     of 20719 ] Downloading Packages/3/389-ds-base-1.2.11.15-22.el6_4.x86_64.rpm
    389-ds-base-1.2.11.15-22.el6_4.x86_64.rpm                                                                                                                                                                             | 1.5 MB     00:00
    [rhel-6-server-rpms: 3     of 20719 ] Downloading Packages/3/389-ds-base-1.2.10.2-18.el6_3.x86_64.rpm
    389-ds-base-1.2.10.2-18.el6_3.x86_64.rpm                                                                                                                                                                              | 1.4 MB     00:00
    [rhel-6-server-rpms: 4     of 20719 ] Downloading Packages/3/389-ds-base-1.2.11.15-12.el6_4.x86_64.rpm
    389-ds-base-1.2.11.15-12.el6_4.x86_64.rpm                                                                                                                                                                             | 1.5 MB     00:00
    ^C
    [root@687706d531f2 /]# exit
    [root@localhost ~]#

## Create a RHEL7 container, perform reposync

    [root@localhost ~]# podman pull registry.access.redhat.com/rhel7/rhel
    Trying to pull registry.access.redhat.com/rhel7/rhel...Getting image source signatures
    Copying blob d69140bdce18: 72.34 MiB / 72.34 MiB [=========================] 13s
    Copying blob a82dd37af30d: 1.23 KiB / 1.23 KiB [===========================] 13s
    Copying config 5044f6040ea5: 6.31 KiB / 6.31 KiB [==========================] 0s
    Writing manifest to image destination
    Storing signatures
    5044f6040ea5535b508dcade2cbee564dae54907ed47ee6002c8cd6e39c60c3c
    [root@localhost ~]# podman run -it registry.access.redhat.com/rhel7/rhel /bin/bash
    [root@ce44637e76f3 /]# cat /etc/redhat-release
    Red Hat Enterprise Linux Server release 7.6 (Maipo)
    [root@ce44637e76f3 /]# yum repolist
    Loaded plugins: ovl, product-id, search-disabled-repos, subscription-manager
    rhel-7-server-rpms                                                                                                                                                                                                    | 3.5 kB  00:00:00
    (1/3): rhel-7-server-rpms/7Server/x86_64/group                                                                                                                                                                        | 774 kB  00:00:00
    (2/3): rhel-7-server-rpms/7Server/x86_64/updateinfo                                                                                                                                                                   | 3.1 MB  00:00:00
    (3/3): rhel-7-server-rpms/7Server/x86_64/primary_db                                                                                                                                                                   |  56 MB  00:00:05
    repo id                                                                                                         repo name                                                                                                              status
    rhel-7-server-rpms/7Server/x86_64                                                                               Red Hat Enterprise Linux 7 Server (RPMs)                                                                               24192
    repolist: 24192
    [root@ce44637e76f3 /]# reposync -r rhel-7-server-rpms
    Delta RPMs disabled because /usr/bin/applydeltarpm not installed.
    warning: /rhel-7-server-rpms/Packages/3/389-ds-base-1.3.1.6-25.el7.x86_64.rpm: Header V3 RSA/SHA256 Signature, key ID fd431d51: NOKEY                                                                      ]  0.0 B/s |    0 B  --:--:-- ETA
    Public key for 389-ds-base-1.3.1.6-25.el7.x86_64.rpm is not installed
    (1/24192): 389-ds-base-1.3.1.6-25.el7.x86_64.rpm                                                                                                                                                                      | 1.5 MB  00:00:00
    (2/24192): 389-ds-base-1.3.1.6-26.el7_0.x86_64.rpm                                                                                                                                                                    | 1.5 MB  00:00:00
    (3/24192): 389-ds-base-1.3.3.1-13.el7.x86_64.rpm                                                                                                                                                                      | 1.6 MB  00:00:00
    ^C
    [root@ce44637e76f3 /]# exit
    [root@localhost ~]#
