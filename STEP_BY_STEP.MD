## RESUMO 

# 1. INSTALAÇÃO JENKINS
 IP ATUAL http://3.231.55.218/
 IP DA INSTANCIA JENKINS 
 ## 1.1 - Acessar instancia EC2 do Jenkins
 ````
 ssh -i sshkey-key.pem ubuntu@3.231.55.218
 ````
## 1.2 - Setar nome do host
````
 sudo hostnamectl set-hostname jenkins
 /bin/bash
````

## 1.3 - Atualizar linux 
 ````
  sudo apt update
 ````
## 1.3 - Instalar  o java
````
sudo apt install openjdk-11-jre
sudo apt-get install openjdk-17-jdk -y
````

## 1.5 - Instalar Jenkins
### 1.5.1 - adicionar repositório jenkins 
    ````
    curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
    ````
### 1.5.2 - instalação Jenkins

      ````
      sudo apt-get update
      sudo apt-get install jenkins
      systemctl status jenkins
      ````

### 1.5.3 - acessar a url http//:Ip_public:8080

    colocar a url da tela do jenkins aqui 
     ------------------------------------------

# 2. INSTALAÇÃO DO SONARQUBER 

  colocar pre requisitos aqui 
      
## 2.1 - Acessar a Instância do SonarQube
      ````
       ssh -i sshkey-key.pem ubuntu@3.220.205.103
       sudo hostnamectl set-hostname sonarquber
      ````
 
 ## 2.2 - Increase the vm.max_map_count kernal ,file discriptor and ulimit for current session at runtime.
 
  ````
   sysctl -w vm.max_map_count=524288
   sysctl -w fs.file-max=131072
   ulimit -n 131072
   ulimit -u 8192
  ````

  ## 2.3 - Intalação do Postgres 
       
  ````
  sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list' 
  ```` 
  ```` 
   wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add - 
  ````
  ### atulização do sistema 
       
  ````
  sudo apt-get update  
  sudo apt-get upgrade 
  ````
  ### istalação 
      
 ````
 sudo apt-get -y install postgresql postgresql-contrib
 ````
       
### verificar a instalação
````       
sudo netstat -tunlp | grep 5432
````
### 1 . cria um cluster postgresq
````
sudo service postgresql96 initdb
````
        
### 2. iniciar o Postgres 
````
sudo systemctl start postgresql
````
      
### 3. verificar se está ativo 
       
````
systemctl is-active postgresql
````
        
### 4. para conectar no postigre 
````
sudo -u postgres psql
````

#### Alterar senha do usuário padrão do PostgreSQL
````
sudo passwd postgres
````
3485
### logar como usuário do Postgres e entra no  chel  
````
su - postgres
psql
````
### criar um usuario e banco sonar 
       
````
createuser sonar
ALTER USER sonar WITH ENCRYPTED password 'sonar';
ou
CREATE USER sonar WITH ENCRYPTED PASSWORD 'sonar_password';(opcional)
````        

####  criar banco de dados 
````
CREATE DATABASE sonarqube;
GRANT ALL PRIVILEGES ON DATABASE sonarqube to sonar; #Don't exit from psql shell
````   
### Editar métodos de autenticação do PostgreSQL   
 
 
 
 
 
 ## 2.4 - Instalação do Sonarqube
 
 ### 2.4.1 - entrar na pasta temporária 
  ````
  cd /tmp
  ````

 ## 2.4.2 - Baixar  o Zip do SonarQuber na pasta temporária
  
  ````
  sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.0.65466.zip
  
  ````
  ## 2.4.2 - Instalar Unzip 
 
   ````
   sudo apt-get install unzip
   ````
   ## 2.4.3 - Unzip the archeve setup to /opt directory
    
   ````
    sudo unzip sonarqube-9.9.0.65466.zip -d /opt

   ````
  
  
   ## 2.4.4 - Move extracted setup to /opt/sonarqube directory
  
   ````
   sudo mv /opt/sonarqube-9.9.0.65466 /opt/sonarqube
   ````
  
  ## 2.4.5 - Configure SonarQube on Ubuntu 22.04 LTS

  ###  2.4.5.1 - Create a group as sonar
    ````
     sudo groupadd sonar
    ````
    
   ###  2.4.5.2 - Now add the user with directory access

   ````
   sudo useradd -c "user to run SonarQube" -d /opt/sonarqube -g sonar sonar 
   sudo chown sonar:sonar /opt/sonarqube -R
   ````

   ###  2.4.5.3 - Open the SonarQube configuration file using your favorite text editor.

    ````
    sudo nano /opt/sonarqube/conf/sonar.properties
    colocar  login e senha e a estring de conexão do Postgres
    sonar.jdbc.username=sonar
    sonar.jdbc.password=sonar
    sonar.jdbc.url=jdbc:postgresql://localhost:5432/sonarqube
    ````

   ###  2.4.5.4 - Edit the sonar script file and set RUN_AS_USER
    RUN_AS_USER=sonar

    ````
    sudo nano /opt/sonarqube/bin/linux-x86-64/sonar.sh
    ````

   ###  2.4.5.5 - Start SonarQube Now to start SonarQube we need to do following: Switch to sonar user
    ````
     sudo su sonar
    ````
     
 ### 2.4.5.6 - Run the script to start SonarQube
 
    Move to the script directory
    ````
     cd /opt/sonarqube/bin/linux-x86-64/
     ./sonar.sh start
    ````
###  2.4.5.7 - Configure Systemd service
 Primeiro pare o serviço SonarQube conforme começamos manualmente 
 usando as etapas acima. Navegue até o caminho de instalação do SonarQube
 
````
sudo nano /etc/systemd/system/sonar.service
````
###  2.4.5.8 - Add the below lines,

````
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking

ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop

User=sonar
Group=sonar
Restart=always

LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target
````
###  2.4.5.8 Save and close the file. Now stop the sonarqube script earlier we started to run using as daemon. Start the Sonarqube daemon by running:

````
 sudo systemctl start sonar
````

###  2.4.5.8 Enable the SonarQube service to automatically  at boot time System Startup.
````
 sudo systemctl enable sonar
````
###  2.4.5.9 check if the sonarqube service is running,
````
 sudo systemctl status sonar
````
Successfully, We have covered How to Install SonarQube on Ubuntu 22.04 LTS .


# ERROS INSTALAÇÃO SONARQUBER 

 Failed to create table schema_migrations

 create schema schema_migrations

solução:
ALTER USER sonar SET search_path to sonarqube;
GRANT ALL ON SCHEMA sonarqube TO sonarqube;
GRANT ALL PRIVILEGES ON DATABASE sonarqube to sonar; #Don't exit from psql shell

Cannot assing request adress
sonar 
admin 
3485
--------------------------------------------------------------------------
# 3. INSTALAÇÃO DO GITLAG NO UBUNTU 22.04
ip 3.231.25.225

## 3.1 Update System Packages
 ````
  $ sudo apt update
  $ sudo apt upgrade -y
 
 ````

## 3.2 - Reboot the system after applying updates,
 ````
 sudo reboot
 ````
 ## 3.4 - O GitLab requer algumas dependências para funcionar corretamente. Instale-os usando os seguintes comandos

 ````
 $ sudo apt install -y curl openssh-server ca-certificates postfix
 ````
 ## 3.5 - Durante a instalação do postfix, uma janela de configuração aparecerá. Escolha “Site da Internet” e digite o nome do host do seu servidor como nome do servidor de e-mail. Isso permitirá que o GitLab envie notificações por e-mail.

 Escolha “Site da Internet” e selecione OK.

 ## 3.6 - Add GitLab Apt Repository

 ````
 $ curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
 ````

 ## 3.7 - Instalação do  Gitlab no Ubuntu 22.04

 ````
 sudo EXTERNAL_URL="http://gitlab.linuxtechi.net" apt install gitlab-ce
 ````
 A saída acima confirma que o GitLab foi instalado com sucesso. O nome de usuário da interface web do gitlab é root e a senha é armazenada em “/etc/gitlab/initial_root_password”

  ## 3.8 - liberar portas do firewell 

 ````
 $ sudo ufw allow http
 $ sudo ufw allow https
````
## 3.8 - Com o GitLab instalado e configurado, abra seu navegador e digite o endereço IP ou nome do host do seu servidor.

fontes 
https://computingforgeeks.com/how-to-install-gitlab-ce-on-ubuntu-linux/

https://www.fosslinux.com/24961/configuring-jenkins-pipeline-with-sonarqube-and-gitlab-integration.htm

https://gcore.com/learning/jenkins-pipeline-with-sonarqube-and-gitlab/

