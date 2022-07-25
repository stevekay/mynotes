# Grub

## Boot to text mode

- at grub boot prompt, add `3` to end of kernel line
- once booted, ensure always boots to text mode
````
systemctl set-default multi-user.target
````
