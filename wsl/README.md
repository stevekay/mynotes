
getting wsl and virtualbox working alongside each other

optionalfeatures.exe
 - Virtual Machine Platform = enabled
 - Windows Hypervisor Platform = enabled
 - Windows Subsystem for Linux = enabled

bcdedit /set hypervisorlaunchtype off

dont know if this was truly needed
````
vmcompute 0
vmwp 0
````

````
wsl --set-default-version 1
wsl --install Unbuntu
````
