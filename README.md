#Homework №1
Добавлена интеграция с Travis и Slack

Исправлен тест на питоне

Добавлен шаблон для PR

#Homework №2

##Tasks 

###1) 
connect to internal vm via one command:
```
ssh -i ~/.ssh/appuser  appuser@10.132.0.3 -o "proxycommand ssh -W %h:%p -i ~/.ssh/appuser appuser@35.210.2.185"
```

###2) 
setup host config by adding to ~/.ssh/config this lines
```
Host someinternalhost
  Hostname 10.132.0.3
  IdentityFile  ~/.ssh/appuser
  ForwardAgent yes
  User appuser
  ProxyCommand ssh -W %h:%p -i ~/.ssh/appuser appuser@35.210.2.185
```
 
 and now there is ability to connect to internal host via command 
 ```
 ssh someinternalhost
 ```
 
 ##3)
 its possible to use 35-210-2-185.sslip.io as domain name for pritunl admin panel and add this domain in settings to setup lets encrypt cert 
so connection to 35-210-2-185.sslip.io will not show cert error

added files:

.gitignore - ignore idea files

cloud-bastion.ovpn - config for ovpn client loaded from pritunl use 
```sudo openvpn --config cloud-bastion.ovpn``` with user test and password 6214157507237678334670591556762 for starting vpn and then use ```ssh appuser@10.132.0.3``` to connect to someinternalhost 
 
ips of VM's are
```
bastion_IP=35.210.2.185
someinternalhost_IP=10.132.0.3
```
