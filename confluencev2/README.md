Fresh build of RHEL9, minimal.

With subsequent confluence install.

* Fix cmd history

```
[steve@localhost ~]$ echo 'set -o vi' >> ~/.bashrc
[steve@localhost ~]$
```

* Don't prompt for password

```
[steve@localhost ~]$ sudo sed -i 's/%wheel.*/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
[steve@localhost ~]$
```

* Register, so we get repos

```
[steve@localhost ~]$ sudo subscription-manager register
Registering to: subscription.rhsm.redhat.com:443/subscription
Username: stevekay1970
Password:
The system has been registered with ID: f259d817-e8e5-486b-b02c-62d1fd2e5aa2
The registered system name is: localhost.localdomain
[steve@localhost ~]$ sudo subscription-manager attach
Installed Product Current Status:
Product Name: Red Hat Enterprise Linux for x86_64
Status:       Subscribed

[steve@localhost ~]$
```

* Install git

```
[steve@localhost ~]$ sudo yum install -qy git
Importing GPG key 0xFD431D51:
 Userid     : "Red Hat, Inc. (release key 2) <security@redhat.com>"
 Fingerprint: 567E 347A D004 4ADE 55BA 8A5F 199E 2F91 FD43 1D51
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
Importing GPG key 0x5A6340B3:
 Userid     : "Red Hat, Inc. (auxiliary key 3) <security@redhat.com>"
 Fingerprint: 7E46 2425 8C40 6535 D56D 6F13 5054 E4A4 5A63 40B3
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

Installed:
  emacs-filesystem-1:27.2-6.el9.noarch
  git-2.31.1-2.el9.2.x86_64
  git-core-2.31.1-2.el9.2.x86_64
  git-core-doc-2.31.1-2.el9.2.noarch
...
[steve@localhost ~]$
```

* Create new keypair for our github account

```
[steve@localhost ~]$ ssh-keygen -t rsa -b 4096
Generating public/private rsa key pair.
Enter file in which to save the key (/home/steve/.ssh/id_rsa):
Created directory '/home/steve/.ssh'.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/steve/.ssh/id_rsa
...
[steve@localhost ~]$
```

* Paste public key (~/.ssh/id_rsa.pub) into github Settings -> SSH and GPG keys ( https://github.com/settings/keys )


* Update to latest release

```
[steve@localhost ~]$ sudo yum update
Updating Subscription Management repositories.
Last metadata expiration check: 0:31:02 ago on Thu 24 Nov 2022 10:48:11 GMT.
Dependencies resolved.
...
[steve@localhost ~]$
```

* Turn off mitigations, for faster operation in lab.

```
[steve@localhost ~]$ sudo grubby --args='mitigations=off' --update-kernel=ALL
[steve@localhost ~]$
```

* Get the notes repo

```
[steve@localhost ~]$ git clone git@github.com:stevekay/mynotes.git
Cloning into 'mynotes'...
The authenticity of host 'github.com (140.82.121.3)' can't be established.
ED25519 key fingerprint is SHA256:+DiY3wvvV6TuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'github.com' (ED25519) to the list of known hosts.
remote: Enumerating objects: 548, done.
remote: Counting objects: 100% (87/87), done.
remote: Compressing objects: 100% (64/64), done.
remote: Total 548 (delta 41), reused 64 (delta 19), pack-reused 461
Receiving objects: 100% (548/548), 1.33 MiB | 1.87 MiB/s, done.
Resolving deltas: 100% (200/200), done.
[steve@localhost ~]$
```

* git config : owner, colours

```
[steve@localhost ~]$ cat .gitconfig
[user]
        name = Steve Kay
        email = stevekay@gmail.com
# Neonwolf Color Scheme for Git
#
# Based mostly on the colors from the badwolf airline theme
#
# Github: https://github.com/h3xx/git-colors-neonwolf
#
# Recommended additions to make this work:
#
#[core]
#   pager           = less -R       # handle colors correctly
#
#[color]
#   branch          = auto
#   diff            = auto
#   interactive     = auto
#   ui              = auto

[color "diff"]
    frag            = bold 160 238 # red
    meta            = bold 45 238  # light blue
    old             = bold 202 238 # orange
    new             = bold 82 238  # green
    commit          = bold 226 238 # yellow
    func            = bold 213 238 # dark orange


[color "grep"]
    linenumber      = bold 165 235
    filename        = bold 39 235
    separator       = bold 82 235
    function        = bold 222
    selected        = bold 255 235
    context         = 240
    match           = bold 154 235
    #matchContext   = ? # matching text in context lines
    #matchSelected  = ? # matching text in selected lines

[color "status"]
    added           = bold 154 235
    changed         = bold 166 235
    untracked       = bold 81 235
    unmerged        = bold 196 235

[color "decorate"]
    HEAD            = bold 81 235
    branch          = bold 121 235
    remoteBranch    = bold 222 235
    tag             = bold 166 235

[color "branch"]
    current         = bold 121 235
    local           = bold 81 235
    remote          = bold 222 235
    upstream        = bold 222 235
    plain           = 255

[color "interactive"]
    prompt          = bold 121 235
    header          = bold 165 235
    help            = bold 222 235
    error           = bold 196 235

# vi: ft=gitconfig ts=8 sts=8 sw=4 et
[color]
        branch = auto
        diff = auto
        interactive = auto
        ui = auto
        pager = true
[steve@localhost ~]$ 
```
