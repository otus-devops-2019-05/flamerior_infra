#Homework №1
Добавлена интеграция с Travis и Slack

Исправлен тест на питоне

Добавлен шаблон для PR

#Homework №2

## Tasks 

### 1) 
connect to internal vm via one command:
```
ssh -i ~/.ssh/appuser  appuser@10.132.0.3 -o "proxycommand ssh -W %h:%p -i ~/.ssh/appuser appuser@35.210.2.185"
```

### 2) 
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
 
 ## 3)
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

### 4)

Добавлены скрипты 

- Скрипт install_ruby.sh содержит команды по установке
Ruby;
- Скрипт install_mongodb.sh содержит команды по
установке MongoDB;
- Скрипт deploy.sh содержит команды скачивания кода,
установки зависимостей через bundler и запуск приложения.

- generate_startup.sh - скрипт для генерации стартап скрипта, который объединяет предыдущие скрипты в один в правильном порядке для запуска через gcloud


- create_and_run.sh - запускает генерацию стартап скрипта, затем дергает gcloud для создания инстанса с этим стартап скриптом и команду на создания правила файрвола
порт по умолчанию - 9292

```
#! /bin/bash
#generating startup script
source ./generate_startup.sh

#creating instance with startup script
gcloud compute instances create reddit-app \
--boot-disk-size=10GB \
--image-family ubuntu-1604-lts \
--image-project=ubuntu-os-cloud \
--machine-type=g1-small \
--tags puma-server \
--restart-on-failure \
--zone us-central1-a \
--metadata-from-file startup-script=./startup.sh

#generating firewall rule
gcloud compute --project=infra-244206 firewall-rules create default-puma-server \
--direction=INGRESS --priority=1000 --network=default --action=ALLOW \
--rules=tcp:9292 \
--source-ranges=0.0.0.0/0 \
--target-tags=puma-server

```

```
testapp_IP = 35.239.239.151
testapp_port = 9292
```

### 5)

созданы файлы конфигов для packer (и для базового образа с софтом, и для наследуемого от него образа с приложением)
в первом образе просто добавлены скрипты для установки руби и монго
для сборки вызвать
```packer build -var-file variables.json ubuntu16.json ```
во втором установлен как исходный образ - предыдущий (по имени семейства)
затем добавлен скрипт для клона репо и установки зависимостей
затем копируется шаблон для юнита systemd и добавляется в автозапуск
итого для билда второго образа 
```packer build -var-file variables.json immutable.json ```
в файле variables.json лежат обязательные переменные и он в гитигноре но есть пример как его заполнять - variables.json.example

далее для создания инстанса из образа и файрвола можно использовать скрипт
```./config-scripts/create-redditvm.sh```


### 6)

##Выполнены основные задания 
- создана переменная для приватного ключа
- создана переменная для зоны c дефолтным значением
- выполнено terraform fmt
- создан terraform.tfvars.example

## Задания со *
добавлены лючи для нескольких пользователей в проект - добавляются как одна строка разделенная \n
соответственно если создать вручную через веб интерфейс а потом через терраформ то терраформ переопределяет целиком весь список ключей

## Задание с **
добавлен файл lb.tf и переменная для количества инстансов приложения
приложение доступно по ip_балансера:195 так как список доступных портов ограничен
если жив хоть один инстанс то по ип балансера приложение будет работать


### 7)
##Выполнены основные задания 
- создан модуль vpc
- проверена работа файрвола для ссш
- созданы окружения prod и stage (за счет параметризации они отличаются только файлами переменных)

## Задания со *
созданы бакеты для stage и prod и стейт терраформа перенаправлен туда - при араллельном запуски терраформ блокирует изменения в рамках бакета

## Задание с **
реализован провизионер для запуска приложения причем с условием запуска, зависящим от переменной
настроена VM c базой так, чтобы не было внешнего ip и позволяло доступ с вм приложения



### 8)
выполнены основное и задание со *
создан шаблон для динамического инвентори на стороне терраформа и баш скрипт для вызова вывода команды оутпута терраформа
создан простой плейбук для клонирования репо
добавлены настройки для удаленного пользователя и вызова скрипта в качестве инвентори
динамический json должен содержать структуру 
``` 
"_meta": {
   "hostvars": {
```
для того, чтобы не вызывалось получение переменных для каждого хоста



### 9)
выполнены основное и задание со *

созданы плейбуки с одним сценарием, с несколькими сценариями
сценарии разделены на несколько плейбуков с импортом в одном
созданы и проверены плейбуки для пакера 
