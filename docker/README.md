Using Docker on RHEL9

## Install

Currently no RHEL9 docker-ce on the site, so we'll use CentOS version.

```
# cd /etc/yum.repos.d
# wget https://download.docker.com/linux/centos/docker-ce.repo
...
# dnf install -y docker-ce
...
```

## Start

```
# systemctl enable --now docker-ce
Created symlink /etc/systemd/system/multi-user.target.wants/docker.service → /usr/lib/systemd/system/docker.service.
#
```

## Hello World test

```
# docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
2db29710123e: Pull complete
Digest: sha256:e18f0a777aefabe047a671ab3ec3eed05414477c951ab1a6f352a06974245fe7
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/

#
```

## Ubuntu test

```
[root@rhel9 ~]# docker pull ubuntu
Using default tag: latest
latest: Pulling from library/ubuntu
301a8b74f71f: Pull complete
Digest: sha256:7cfe75438fc77c9d7235ae502bf229b15ca86647ac01c844b272b56326d56184
Status: Downloaded newer image for ubuntu:latest
docker.io/library/ubuntu:latest
[root@rhel9 ~]# docker images
REPOSITORY    TAG       IMAGE ID       CREATED         SIZE
ubuntu        latest    cdb68b455a14   2 days ago      77.8MB
hello-world   latest    feb5d9fea6a5   13 months ago   13.3kB
[root@rhel9 ~]# docker run -it ubuntu:latest bash
root@d721508683f5:/# uname -a
Linux d721508683f5 5.14.0-70.26.1.el9_0.x86_64 #1 SMP PREEMPT Fri Sep 2 16:07:40 EDT 2022 x86_64 x86_64 x86_64 GNU/Linux
root@d721508683f5:/# grep ^NAME /etc/os-release
NAME="Ubuntu"
root@d721508683f5:/#
```

## Give it a better name

```
[root@rhel9 ~]# docker container ls -a
CONTAINER ID   IMAGE           COMMAND    CREATED          STATUS                      PORTS     NAMES
d721508683f5   ubuntu:latest   "bash"     6 minutes ago    Exited (0) 56 seconds ago             epic_tesla
ea8e1e69548c   hello-world     "/hello"   23 minutes ago   Exited (0) 23 minutes ago             great_shannon
[root@rhel9 ~]# docker container rename epic_tesla ubuntu_container
[root@rhel9 ~]# docker container ls -a
CONTAINER ID   IMAGE           COMMAND    CREATED          STATUS                          PORTS     NAMES
d721508683f5   ubuntu:latest   "bash"     6 minutes ago    Exited (0) About a minute ago             ubuntu_container
ea8e1e69548c   hello-world     "/hello"   24 minutes ago   Exited (0) 24 minutes ago                 great_shannon
[root@rhel9 ~]#
```

## TODO

- podman ?
