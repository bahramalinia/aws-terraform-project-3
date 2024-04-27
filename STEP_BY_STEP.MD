Aqui está o README padronizado:

## RESUMO

### 1. INSTALAÇÃO DO JENKINS

- **IP ATUAL**: http://3.231.55.218/
- **IP DA INSTÂNCIA DO JENKINS**: Coloque o IP aqui

#### 1.1 - Acessar a instância EC2 do Jenkins

```sh
ssh -i sshkey-key.pem ubuntu@3.231.55.218
```

#### 1.2 - Definir o nome do host

```sh
sudo hostnamectl set-hostname jenkins
/bin/bash
```

#### 1.3 - Atualizar o Linux

```sh
sudo apt update
```

#### 1.4 - Instalar o Java

```sh
sudo apt install openjdk-11-jre
sudo apt-get install openjdk-17-jdk -y
```

#### 1.5 - Instalar o Jenkins

##### 1.5.1 - Adicionar repositório do Jenkins

```sh
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
```

##### 1.5.2 - Instalação do Jenkins

```sh
sudo apt-get update
sudo apt-get install jenkins
systemctl status jenkins
```

##### 1.5.3 - Acessar a URL http//:Ip_public:8080

Coloque a URL da tela do Jenkins aqui
------------------------------------------

### 2. INSTALAÇÃO DO SONARQUBE

Coloque os pré-requisitos aqui

#### 2.1 - Acessar a instância do SonarQube

```sh
ssh -i sshkey-key.pem ubuntu@3.220.205.103
sudo hostnamectl set-hostname sonarquber
```

#### 2.2 - Aumentar o vm.max_map_count kernal, file descriptor e ulimit para a sessão atual em tempo de execução.

```sh
sysctl -w vm.max_map_count=524288
sysctl -w fs.file-max=131072
ulimit -n 131072
ulimit -u 8192
```

#### 2.3 - Instalação do PostgreSQL

```sh
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
sudo apt-get update
sudo apt-get upgrade
sudo apt-get -y install postgresql postgresql-contrib
sudo netstat -tunlp | grep 5432
sudo service postgresql96 initdb
sudo systemctl start postgresql
systemctl is-active postgresql
sudo -u postgres psql
```

#### 2.4 - Instalação do Sonarqube

#### 2.4.1 - Entrar na pasta temporária

```sh
cd /tmp
```

#### 2.4.2 - Baixar o Zip do SonarQube na pasta temporária

```sh
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.0.65466.zip
```

#### 2.4.3 - Instalar Unzip

```sh
sudo apt-get install unzip
```

#### 2.4.4 - Descompactar o arquivo de instalação para o diretório /opt

```sh
sudo unzip sonarqube-9.9.0.65466.zip -d /opt
```

#### 2.4.5 - Configurar SonarQube no Ubuntu 22.04 LTS

#### 2.4.5.1 - Criar um grupo chamado sonar

```sh
sudo groupadd sonar
```

#### 2.4.5.2 - Adicionar o usuário com acesso ao diretório

```sh
sudo useradd -c "user to run SonarQube" -d /opt/sonarqube -g sonar sonar 
sudo chown sonar:sonar /opt/sonarqube -R
```

### [Continuação...]

#### 2.4.5.3 - Abrir o arquivo de configuração do SonarQube usando seu editor de texto favorito.

```sh
sudo nano /opt/sonarqube/conf/sonar.properties
```

```properties
# Configurações do banco de dados PostgreSQL
sonar.jdbc.username=sonar
sonar.jdbc.password=sonar
sonar.jdbc.url=jdbc:postgresql://localhost:5432/sonarqube
```

#### 2.4.5.4 - Editar o arquivo de script do Sonar e definir RUN_AS_USER

```sh
sudo nano /opt/sonarqube/bin/linux-x86-64/sonar.sh
```

```sh
RUN_AS_USER=sonar
```

#### 2.4.5.5 - Iniciar o SonarQube

```sh
sudo su sonar
cd /opt/sonarqube/bin/linux-x86-64/
./sonar.sh start
```

#### 2.4.5.6 - Configurar o serviço systemd

```sh
sudo nano /etc/systemd/system/sonar.service
```

Adicione as seguintes linhas:

```plaintext
[Unit]
Description=Serviço do SonarQube
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
```

#### 2.4.5.7 - Salvar e fechar o arquivo. Em seguida, pare o script do SonarQube que iniciamos manualmente e execute-o como um daemon.

```sh
sudo systemctl start sonar
```

#### 2.4.5.8 - Habilitar o serviço do SonarQube para iniciar automaticamente na inicialização do sistema.

```sh
sudo systemctl enable sonar
```

#### 2.4.5.9 - Verificar se o serviço do SonarQube está em execução.

```sh
sudo systemctl status sonar
```

### ERROS NA INSTALAÇÃO DO SONARQUBE

- **Erro: Failed to create table schema_migrations**

  Solução:
  
  ```sql
  ALTER USER sonar SET search_path to sonarqube;
  GRANT ALL ON SCHEMA sonarqube TO sonarqube;
  GRANT ALL PRIVILEGES ON DATABASE sonarqube to sonar; -- Não saia do shell psql
  ```

- **Erro: Cannot assign requested address**

  Usuário e senha do PostgreSQL:
  - Usuário: sonar
  - Senha: sonar
  - Porta: 3485

------------------------------------------------------

### 3. INSTALAÇÃO DO GITLAB NO UBUNTU 22.04

- **IP**: 3.231.25.225

#### 3.1 - Atualizar os pacotes do sistema

```sh
sudo apt update
sudo apt upgrade -y
sudo reboot
```

#### 3.2 - Instalar dependências do GitLab

```sh
sudo apt install -y curl openssh-server ca-certificates postfix
```

Durante a instalação do postfix, selecione "Site da Internet" e insira o nome do host do seu servidor como nome do servidor de e-mail.

#### 3.3 - Adicionar o repositório do GitLab Apt

```sh
curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
```

#### 3.4 - Instalação do GitLab no Ubuntu 22.04

```sh
sudo EXTERNAL_URL="http://gitlab.linuxtechi.net" apt install gitlab-ce
```

A senha de usuário da interface web do GitLab é armazenada em "/etc/gitlab/initial_root_password".

#### 3.5 - Liberar portas no firewall

```sh
sudo ufw allow http
sudo ufw allow https
```

Após instalar e configurar o GitLab, abra seu navegador e acesse o endereço IP ou nome do host do seu servidor.

Fontes:
- [Computing for Geeks](https://computingforgeeks.com/how-to-install-gitlab-ce-on-ubuntu-linux/)
- [FossLinux](https://www.fosslinux.com/24961/configuring-jenkins-pipeline-with-sonarqube-and-gitlab-integration.htm)
- [GCore](https://gcore.com/learning/jenkins-pipeline-with-sonarqube-and-gitlab/)
