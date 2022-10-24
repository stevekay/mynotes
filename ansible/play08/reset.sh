#!/bin/bash
ssh ans1 sudo yum remove -y httpd
ssh ans1 sudo rm -rf /etc/httpd
ssh ans2 sudo yum remove -y httpd
ssh ans2 sudo rm -rf /etc/httpd
ssh ans3 sudo yum remove -y postgresql-server
ssh ans4 sudo apt-get -y purge apache2
ssh ans4 sudo rm -rf /etc/apache2
