#! /bin/bash
sudo yum update -y
sudo yum install docker -y
sudo service docker start
sudo docker run -td --name techserver -p 80:80 ubuntu
sudo docker exec -it techserver /bin/bash -c "apt-get update && apt-get install apache2 -y"
sudo docker exec -it techserver /bin/bash -c "echo 'Hello, how are you?' > /var/www/html/index.html"
sudo docker exec -it techserver /bin/bash -c "service apache2 start"
sudo docker run -td --name myjenkins -p 8080:8080 jenkins/jenkins


#! /bin/bash
#sudo yum update -y
#sudo yum install docker -y
#sudo service docker start
#sudo docker run -td --name techserver -p 80:80 ubuntu
#sudo docker exec -it techserver /bin/bash
#sudo apt-get update
#sudo apt-get install apache2 -y
#sudo cd /var/www/html 
#sudo echo "hello how are you" >index.html
#sudo service apache2 start 
#sudo docker run -td --name myjenkins -p 8080:8080 jenkins/jenkins
