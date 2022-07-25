# Virtualbox

- Adapter set to be Bridged
- Setup static ip, set DNS server, set default gateway

````
nmcli con mod eth0 ipv4.address 192.168.0.123/24
nmcli con mod eth0 ipv4.dns 8.8.8.8
nmcli con mod eth0 ipv4.gateway 192.168.0.1
nmcli con up eth0
````    
