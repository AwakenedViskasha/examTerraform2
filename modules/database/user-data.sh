#!/bin/bash
sudo apt update
sudo apt-get install mysql-client -y
sudo apt install git -y

git clone https://github.com/AwakenedViskasha/spring-petclinic
cd spring-petclinic
sudo git checkout Deployment-Database-Docker-MySQL
sudo mysql --host=${db_endpoint}  --port=3306 -u admin -padmin1234 <./deployment/Docker/Database/MySQL/user.sql
sudo mysql petclinic --host=${db_endpoint} --port=3306 -u admin -padmin1234 <./deployment/Docker/Database/MySQL/schemas.sql
sudo mysql petclinic --host=${db_endpoint} --port=3306 -u admin -padmin1234 <./deployment/Docker/Database/MySQL/data.sql