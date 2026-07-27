## Итоговый проект модуля «Облачная инфраструктура. Terraform»


### Задание 1. 
#### Развертывание инфраструктуры в Yandex Cloud.


``` 
Создайте Virtual Private Cloud (VPC).
Создайте подсети.
Создайте виртуальные машины (VM):
Настройте группы безопасности (порты 22, 80, 443).
Привяжите группу безопасности к VM.
Опишите создание БД MySQL в Yandex Cloud.
Опишите создание Container Registry.
``` 


### Скриншот-1 к заданию 1
![Скриншот 1](https://github.com/roomantix/final-project-terraform/blob/main/img/1.png)

### Скриншот-2 к заданию 1
![Скриншот 1](https://github.com/roomantix/final-project-terraform/blob/main/img/2.png)

```
Ответ.

Я не стал делать это через веб интерфейс  yandex cloud, а сделал все через код.
Исходный код - https://github.com/roomantix/final-project-terraform/blob/main/src/main.tf
```  




### Задание 2. 

``
Используя user-data (cloud-init), установите Docker и Docker Compose (см. Задания 5 модуля «Виртуализация и контейнеризация»).
``



````
Ответ 

cloud-init.tpl
packages:
  - apt-transport-https
  - ca-certificates
  - curl
  - software-properties-common
  - gnupg

runcmd:
  - curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  - echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
  - apt-get update
  - apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
  - systemctl enable docker
  - systemctl start docker
  - usermod -aG docker ubuntu
````

### Скриншот-3 к заданию 2
![Скриншот 3](https://github.com/roomantix/final-project-terraform/blob/main/img/3.png)


------

### Задание 3. 

``
Опишите Docker файл (см. Задания 5 «Виртуализация и контейнеризация») c web-приложением и сохраните контейнер в Container Registry.
``


````
Ответ
Для данных целей я решил использовать скрипты:

deploy-all.sh - для сборки и  передачи в Container Registry.
https://github.com/roomantix/final-project-terraform/blob/main/src/deploy-all.sh

deploy.sh - для развертывания приложения на удаленной виртуальной машине.
https://github.com/roomantix/final-project-terraform/blob/main/src/deploy.sh

````




------

### Задание 4. 

``
Завяжите работу приложения в контейнере на БД в Yandex Cloud.
``

````
Ответ

Я сделал переменные и передал при развертывание 
приложения на удаленной машине.


````



------

### Задание 5*. 

``
Положите пароли от БД в LockBox и настройте интеграцию с Terraform так, чтобы пароль для БД брался из LockBox.
``

``
Ответ

Положил пароль от БД в LockBox и добавил переменные при
выполнение скриптов.

``

### Скриншот-4 к заданию 5
![Скриншот 4](https://github.com/roomantix/final-project-terraform/blob/main/img/4.png)
