# build sysstat on rhel9

* clone, `git clone https://github.com/sysstat/sysstat.git`
* `cd sysstat`
* install gcc, `sudo yum install -y gcc`
* configure, `./configure`
* compile, `make`
* install, `sudo make install_all`
* enable the systemd service, `sudo systemctl enable --now sysstat`


## warnings generated
````
sa_conv.c: In function ‘upgrade_stats_irq’:
sa_conv.c:573:57: warning: ‘%d’ directive writing between 1 and 10 bytes into a region of size 8 [-Wformat-overflow=]
  573 |                                 sprintf(sic->irq_name, "%d", i - 1);
      |                                                         ^~
sa_conv.c:573:56: note: directive argument in the range [0, 2147483646]
  573 |                                 sprintf(sic->irq_name, "%d", i - 1);
      |                                                        ^~~~
sa_conv.c:573:33: note: ‘sprintf’ output between 2 and 11 bytes into a destination of size 8
  573 |                                 sprintf(sic->irq_name, "%d", i - 1);
      |                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sa_conv.c:555:57: warning: ‘%d’ directive writing between 1 and 10 bytes into a region of size 8 [-Wformat-overflow=]
  555 |                                 sprintf(sic->irq_name, "%d", i - 1);
      |                                                         ^~
sa_conv.c:555:56: note: directive argument in the range [0, 2147483646]
  555 |                                 sprintf(sic->irq_name, "%d", i - 1);
      |                                                        ^~~~
sa_conv.c:555:33: note: ‘sprintf’ output between 2 and 11 bytes into a destination of size 8
  555 |                                 sprintf(sic->irq_name, "%d", i - 1);
      |                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
````
