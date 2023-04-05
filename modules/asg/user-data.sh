#cloud-boothook
#!/bin/bash
sudo apt-get install -y git
git clone https://github.com/AwakenedViskasha/spring-petclinic.git
cd spring-petclinic
echo "# database init, supports mysql too" > src/main/resources/application-mysql.properties
echo "database=mysql" >> src/main/resources/application-mysql.properties
echo "spring.datasource.url=jdbc:mysql://${db_endpoint}:3306/petclinic" >> src/main/resources/application-mysql.properties
echo "spring.datasource.username=petclinic" >> src/main/resources/application-mysql.properties
echo "spring.datasource.password=petclinic" >> src/main/resources/application-mysql.properties
echo "spring.sql.init.mode=always" >> src/main/resources/application-mysql.properties
sudo ./mvnw spring-boot:run -Dspring-boot.run.profiles=mysql