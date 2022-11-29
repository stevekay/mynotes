Data from vROps in this format:

```
vrops.cpu.demand 2.929333448410034 1505122200 source=vm01.foo.com
vrops.cpu.demand 2.929333448410034 1505122260 source=vm01.foo.com
vrops.cpu.demand 2.929333448410034 1505122320 source=vm01.foo.com
vrops.cpu.demand 2.929333448410034 1505122380 source=vm01.foo.com
vrops.cpu.demand 2.929333448410034 1505122440 source=vm01.foo.com
vrops.cpu.demand 2.929333448410034 1505122500 source=vm01.foo.com
vrops.cpu.demand 2.929333448410034 1505122560 source=vm01.foo.com
vrops.cpu.demand 2.929333448410034 1505122620 source=vm01.foo.com
vrops.cpu.demand 2.929333448410034 1505122680 source=vm01.foo.com
```

Fields:

* The name of the metric (vrops.cpu.demand in our case)
* The value of the metric
* A timestamp in “epoch seconds” (seconds elapsed since 1970-01-01 00:00 UTC)
* A unique, human readable name of the source (a VM name in our case)
