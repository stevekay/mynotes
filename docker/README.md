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

## Review logs

```
[root@rhel9 ~]# docker logs ubuntu_container
root@d721508683f5:/# uname -a
Linux d721508683f5 5.14.0-70.26.1.el9_0.x86_64 #1 SMP PREEMPT Fri Sep 2 16:07:40 EDT 2022 x86_64 x86_64 x86_64 GNU/Linux
root@d721508683f5:/# cat /etc/os*
PRETTY_NAME="Ubuntu 22.04.1 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.1 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
root@d721508683f5:/# ls ca^C
root@d721508683f5:/# ca^C
root@d721508683f5:/# ls /etc/os*
/etc/os-release
root@d721508683f5:/# cat^C
root@d721508683f5:/# grep NAME /etc/os-release
PRETTY_NAME="Ubuntu 22.04.1 LTS"
NAME="Ubuntu"
VERSION_CODENAME=jammy
UBUNTU_CODENAME=jammy
root@d721508683f5:/# grep ^NAME /etc/os-release
NAME="Ubuntu"
root@d721508683f5:/#
exit
[root@rhel9 ~]# 
```

## Run ubuntu container in background

Start in background, attach, use, detatch with still running.

```
[root@rhel9 ~]# docker start ubuntu_container
ubuntu_container
[root@rhel9 ~]# docker attach ubuntu_container
root@d721508683f5:/# id
uid=0(root) gid=0(root) groups=0(root)
root@d721508683f5:/#
( control+p control+q)
root@d721508683f5:/# read escape sequence
[root@rhel9 ~]# docker container ls
CONTAINER ID   IMAGE           COMMAND   CREATED          STATUS          PORTS     NAMES
d721508683f5   ubuntu:latest   "bash"    14 minutes ago   Up 45 seconds             ubuntu_container
[root@rhel9 ~]#
```

## Remove the ubuntu container and image

```
[root@rhel9 ~]# docker stop ubuntu_container
ubuntu_container
[root@rhel9 ~]# docker container rm ubuntu_container
ubuntu_container
[root@rhel9 ~]# docker rmi ubuntu
Untagged: ubuntu:latest
Untagged: ubuntu@sha256:7cfe75438fc77c9d7235ae502bf229b15ca86647ac01c844b272b56326d56184
Deleted: sha256:cdb68b455a141ed921945f6d39a8c0694a7e21a37b2b030488d73e38875a26cc
Deleted: sha256:7ea4455e747ead87d6cc1c4efaf3a79530a931a0856a9f9ce9ac2d8d45bd3c28
[root@rhel9 ~]# docker container ls -a
CONTAINER ID   IMAGE         COMMAND    CREATED          STATUS                      PORTS     NAMES
ea8e1e69548c   hello-world   "/hello"   46 minutes ago   Exited (0) 46 minutes ago             great_shannon
[root@rhel9 ~]# docker images ls -a
REPOSITORY   TAG       IMAGE ID   CREATED   SIZE
[root@rhel9 ~]#
```

## Create tar archive from image

```
[root@rhel9 ~]# docker image ls
REPOSITORY    TAG       IMAGE ID       CREATED         SIZE
hello-world   latest    feb5d9fea6a5   13 months ago   13.3kB
[root@rhel9 ~]# docker save -o /tmp/hello-world.tar hello-world
[root@rhel9 ~]# cd /tmp
[root@rhel9 tmp]# mkdir hello-world
[root@rhel9 tmp]# cd hello-world
[root@rhel9 hello-world]# tar xvf /tmp/hello-world.tar
c28b9c2faac407005d4d657e49f372fb3579a47dd4e4d87d13e29edd1c912d5c/
c28b9c2faac407005d4d657e49f372fb3579a47dd4e4d87d13e29edd1c912d5c/VERSION
c28b9c2faac407005d4d657e49f372fb3579a47dd4e4d87d13e29edd1c912d5c/json
c28b9c2faac407005d4d657e49f372fb3579a47dd4e4d87d13e29edd1c912d5c/layer.tar
feb5d9fea6a5e9606aa995e879d862b825965ba48de054caab5ef356dc6b3412.json
manifest.json
repositories
[root@rhel9 hello-world]# tar tvf ./c28b9c2faac407005d4d657e49f372fb3579a47dd4e4d87d13e29edd1c912d5c/layer.tar
-rwxrwxr-x 0/0           13256 2021-09-24 00:47 hello
[root@rhel9 hello-world]# cat manifest.json
[{"Config":"feb5d9fea6a5e9606aa995e879d862b825965ba48de054caab5ef356dc6b3412.json","RepoTags":["hello-world:latest"],"Layers":["c28b9c2faac407005d4d657e49f372fb3579a47dd4e4d87d13e29edd1c912d5c/layer.tar"]}]
[root@rhel9 hello-world]# cat repositories
{"hello-world":{"latest":"c28b9c2faac407005d4d657e49f372fb3579a47dd4e4d87d13e29edd1c912d5c"}}
[root@rhel9 hello-world]# python3 -mjson.tool <feb5d9fea6a5e9606aa995e879d862b825965ba48de054caab5ef356dc6b3412.json
{
    "architecture": "amd64",
    "config": {
        "Hostname": "",
        "Domainname": "",
        "User": "",
        "AttachStdin": false,
        "AttachStdout": false,
        "AttachStderr": false,
        "Tty": false,
        "OpenStdin": false,
        "StdinOnce": false,
        "Env": [
            "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
        ],
        "Cmd": [
            "/hello"
        ],
        "Image": "sha256:b9935d4e8431fb1a7f0989304ec86b3329a99a25f5efdc7f09f3f8c41434ca6d",
        "Volumes": null,
        "WorkingDir": "",
        "Entrypoint": null,
        "OnBuild": null,
        "Labels": null
    },
    "container": "8746661ca3c2f215da94e6d3f7dfdcafaff5ec0b21c9aff6af3dc379a82fbc72",
    "container_config": {
        "Hostname": "8746661ca3c2",
        "Domainname": "",
        "User": "",
        "AttachStdin": false,
        "AttachStdout": false,
        "AttachStderr": false,
        "Tty": false,
        "OpenStdin": false,
        "StdinOnce": false,
        "Env": [
            "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
        ],
        "Cmd": [
            "/bin/sh",
            "-c",
            "#(nop) ",
            "CMD [\"/hello\"]"
        ],
        "Image": "sha256:b9935d4e8431fb1a7f0989304ec86b3329a99a25f5efdc7f09f3f8c41434ca6d",
        "Volumes": null,
        "WorkingDir": "",
        "Entrypoint": null,
        "OnBuild": null,
        "Labels": {}
    },
    "created": "2021-09-23T23:47:57.442225064Z",
    "docker_version": "20.10.7",
    "history": [
        {
            "created": "2021-09-23T23:47:57.098990892Z",
            "created_by": "/bin/sh -c #(nop) COPY file:50563a97010fd7ce1ceebd1fa4f4891ac3decdf428333fb2683696f4358af6c2 in / "
        },
        {
            "created": "2021-09-23T23:47:57.442225064Z",
            "created_by": "/bin/sh -c #(nop)  CMD [\"/hello\"]",
            "empty_layer": true
        }
    ],
    "os": "linux",
    "rootfs": {
        "type": "layers",
        "diff_ids": [
            "sha256:e07ee1baac5fae6a26f30cabfe54a36d3402f96afda318fe0a96cec4ca393359"
        ]
    }
}
[root@rhel9 hello-world]#
```

## Add to an image

Take ubuntu, add vim.

```
[root@rhel9 ~# docker run -it ubuntu bash
root@9f845f236405:/# type vim
bash: type: vim: not found
root@9f845f236405:/# apt update
Get:1 http://security.ubuntu.com/ubuntu jammy-security InRelease [110 kB]
Get:2 http://archive.ubuntu.com/ubuntu jammy InRelease [270 kB]
...
root@9f845f236405:/# apt install vim
Reading package lists... Done
Building dependency tree... Done
...
root@9f845f236405:/# type vim
vim is /usr/bin/vim
root@9f845f236405:/#
root@9f845f236405:/# exit
exit
[root@rhel9 ~]# docker container ls -a
CONTAINER ID   IMAGE         COMMAND    CREATED             STATUS                         PORTS     NAMES
9f845f236405   ubuntu        "bash"     3 minutes ago       Exited (0) 34 seconds ago                gracious_sutherland
143272f1b758   busybox       "sh"       4 minutes ago       Exited (0) 3 minutes ago                 lucid_proskuriakova
33339d0dabbf   busybox       "bash"     4 minutes ago       Created                                  frosty_wozniak
ea8e1e69548c   hello-world   "/hello"   About an hour ago   Exited (0) About an hour ago             great_shannon
[root@rhel9 ~]# docker commit 9f845f236405
sha256:ace57b3e9845eeeac10d04c0d1bd0fc567db0841fb67bcec02b745e7ae5ac990
[root@rhel9 ~]# docker images
REPOSITORY    TAG       IMAGE ID       CREATED          SIZE
<none>        <none>    ace57b3e9845   30 seconds ago   174MB
busybox       latest    bc01a3326866   30 hours ago     1.24MB
ubuntu        latest    cdb68b455a14   2 days ago       77.8MB
hello-world   latest    feb5d9fea6a5   13 months ago    13.3kB
[root@rhel9 ~]# docker tag ace57b3e9845 steevekay/myubuntuvim:v1
[root@rhel9 ~]# docker images
REPOSITORY              TAG       IMAGE ID       CREATED         SIZE
steevekay/myubuntuvim   v1        ace57b3e9845   2 minutes ago   174MB
busybox                 latest    bc01a3326866   30 hours ago    1.24MB
ubuntu                  latest    cdb68b455a14   2 days ago      77.8MB
hello-world             latest    feb5d9fea6a5   13 months ago   13.3kB
[root@rhel9 ~]#

# upload it to docker hub

[root@rhel9 ~]# docker login
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username: steevekay
Password:
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
[root@rhel9 ~]# docker push steevekay/myubuntuvim:v1
The push refers to repository [docker.io/steevekay/myubuntuvim]
0364bf57a31c: Pushed
7ea4455e747e: Mounted from library/ubuntu
v1: digest: sha256:cca2254dd8731d549aac8fe14f60dbd9e86b602f6c07465117e6105f9ea8c680 size: 741
[root@rhel9 ~]#
```

## Tidyup

```
[root@rhel9 ~]# docker images
REPOSITORY              TAG       IMAGE ID       CREATED          SIZE
steevekay/myubuntuvim   v1        ace57b3e9845   11 minutes ago   174MB
busybox                 latest    bc01a3326866   30 hours ago     1.24MB
ubuntu                  latest    cdb68b455a14   2 days ago       77.8MB
hello-world             latest    feb5d9fea6a5   13 months ago    13.3kB
[root@rhel9 ~]# docker system prune -a
WARNING! This will remove:
  - all stopped containers
  - all networks not used by at least one container
  - all images without at least one container associated to them
  - all build cache

Are you sure you want to continue? [y/N] y
Deleted Containers:
9f845f236405fc21695676635854e693561c9fc6133f38515a73df31cbc5d93e
143272f1b758f4bf49b36a00a3f1f6749ffadb6f9735517e58f546f18b51bee9
33339d0dabbf84e5d1f991e7975751092a634f26d1649cfb78112c3f7faba579
ea8e1e69548cf15c17ec08f3e61645b35c24b5e7923050463fd8ceb3733638ea

Deleted Images:
untagged: hello-world:latest
untagged: hello-world@sha256:e18f0a777aefabe047a671ab3ec3eed05414477c951ab1a6f352a06974245fe7
deleted: sha256:feb5d9fea6a5e9606aa995e879d862b825965ba48de054caab5ef356dc6b3412
deleted: sha256:e07ee1baac5fae6a26f30cabfe54a36d3402f96afda318fe0a96cec4ca393359
untagged: busybox:latest
untagged: busybox@sha256:6bdd92bf5240be1b5f3bf71324f5e371fe59f0e153b27fa1f1620f78ba16963c
deleted: sha256:bc01a3326866eedd68525a4d2d91d2cf86f9893db054601d6be524d5c9d03981
deleted: sha256:0438ade5aeea533b00cd75095bec75fbc2b307bace4c89bb39b75d428637bcd8
untagged: ubuntu:latest
untagged: ubuntu@sha256:7cfe75438fc77c9d7235ae502bf229b15ca86647ac01c844b272b56326d56184
untagged: steevekay/myubuntuvim:v1
untagged: steevekay/myubuntuvim@sha256:cca2254dd8731d549aac8fe14f60dbd9e86b602f6c07465117e6105f9ea8c680
deleted: sha256:ace57b3e9845eeeac10d04c0d1bd0fc567db0841fb67bcec02b745e7ae5ac990
deleted: sha256:1c21f869a9c499878d97da79849cd71bbe5d2207317e6f9bffe0140e83284268
deleted: sha256:cdb68b455a141ed921945f6d39a8c0694a7e21a37b2b030488d73e38875a26cc
deleted: sha256:7ea4455e747ead87d6cc1c4efaf3a79530a931a0856a9f9ce9ac2d8d45bd3c28

Total reclaimed space: 270.5MB
[root@rhel9 ~]# docker images
REPOSITORY   TAG       IMAGE ID   CREATED   SIZE
[root@rhel9 ~]#
```

## Create image using Dockerfile

```
[root@rhel9 ~]# mkdir dtest
[root@rhel9 ~]# cd dtest
[root@rhel9 dtest]# cat >dockerfile
FROM python:2.7-slim
WORKDIR /app
ADD . /app
EXPOSE 80
CMD ["python", "hello.py"]
[root@rhel9 dtest]# cat >hello.py
print("Hello World")
[root@rhel9 dtest]# docker build .
Sending build context to Docker daemon  3.072kB
Step 1/5 : FROM python:2.7-slim
2.7-slim: Pulling from library/python
123275d6e508: Pull complete
dd1cd6637523: Pull complete
0c4e6d630f2c: Pull complete
13e9cd8f0ea1: Pull complete
Digest: sha256:6c1ffdff499e29ea663e6e67c9b6b9a3b401d554d2c9f061f9a45344e3992363
Status: Downloaded newer image for python:2.7-slim
 ---> eeb27ee6b893
Step 2/5 : WORKDIR /app
 ---> Running in df6747409c6a
Removing intermediate container df6747409c6a
 ---> 62726f2af85a
Step 3/5 : ADD . /app
 ---> 40d138cc37b2
Step 4/5 : EXPOSE 80
 ---> Running in a061060dc06a
Removing intermediate container a061060dc06a
 ---> 7faa05b71df5
Step 5/5 : CMD ["python", "hello.py"]
 ---> Running in d00119a8052a
Removing intermediate container d00119a8052a
 ---> f9bf3685be9c
Successfully built f9bf3685be9c
[root@rhel9 dtest]# docker images
REPOSITORY   TAG        IMAGE ID       CREATED         SIZE
<none>       <none>     f9bf3685be9c   3 minutes ago   148MB
python       2.7-slim   eeb27ee6b893   2 years ago     148MB
[root@rhel9 dtest]# docker run f9bf3685be9c
Hello World
[root@rhel9 dtest]# docker tag f9bf3685be9c myapp:latest
[root@rhel9 dtest]# docker images
REPOSITORY   TAG        IMAGE ID       CREATED         SIZE
myapp        latest     f9bf3685be9c   4 minutes ago   148MB
python       2.7-slim   eeb27ee6b893   2 years ago     148MB
[root@rhel9 dtest]# docker run myapp
Hello World
[root@rhel9 dtest]#
~~~


## TODO

- podman ?
