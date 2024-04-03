
# ***************************************************************************************************************************************
# * Dockerfile                                                                                                                          *
#  **************************************************************************************************************************************
#  *                                                                                                                                    *
#  * @License Starts                                                                                                                    *
#  *                                                                                                                                    *
#  * Copyright © 2024. MongoExpUser.  All Rights Reserved.                                                                              *
#  *                                                                                                                                    *
#  * License: MIT - https://github.com/MongoExpUser/Ubuntu-MySQ-Image-and-Container/blob/main/LICENSE                                   *
#  *                                                                                                                                    *
#  * @License Ends                                                                                                                      *
#  **************************************************************************************************************************************
# *                                                                                                                                     *
# *  Project: Ubuntu-MySQL Image & Container Project                                                                                    *
# *                                                                                                                                     *
# *  This dockerfile creates an image based on:                                                                                         *
# *                                                                                                                                     *
# *   1)  Ubuntu Linux 22.04                                                                                                            *
# *                                                                                                                                     *
# *   2)  Additional Ubuntu Utility Packages                                                                                            *
# *                                                                                                                                     *
# *   3)  MySQL Server v8.0.36                                                                                                          *
# *                                                                                                                                     *
# *   4)  Python v3.x                                                                                                                   *
# *                                                                                                                                     *
# *   5)  Python3-pip                                                                                                                   *
# *                                                                                                                                     *
# *   6)  Python3 Packages: boto3, pymysql, etc.                                                                                        *
# *                                                                                                                                     *
# *   7)  Python3 Awscli Upgrade                                                                                                        *
# *                                                                                                                                     *
# *   8)  Awscli v2                                                                                                                     *
# *                                                                                                                                     *
# *   9)  NodeJS v21.x                                                                                                                  *
# *                                                                                                                                     *
# *   10) NodeJS Packages: @aws-sdk/client-s3, mysql, @mysql/xdevapi, etc.                                                              *
# *                                                                                                                                     *
# *   11) Docker 26.0.0: docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin                               *
# *                                                                                                                                     *
# *   12) Files clean up                                                                                                                *
# *                                                                                                                                     *
# *                                                                                                                                     *
# ***************************************************************************************************************************************



# Dockerfile 
# 1a. Base Image. Version: 22.04 or jammy-20240227 or jammy or latest. Ref: https://hub.docker.com/_/ubuntu
FROM ubuntu:22.04

# 1b. Labels
LABEL maintainer="MongoExpUser"
LABEL maintainer_email="MongoExpUser@domain.com"
LABEL company="MongoExpUser"
LABEL version="1.0"

# 1b. Create user(s) and add  to the sudoers group
RUN apt-get -y update && apt-get -y install sudo
RUN adduser --disabled-password --gecos 'dbs-1' dbs && adduser dbs sudo
RUN adduser --disabled-password --gecos 'app-1' app && adduser app sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# 1c. Make and change to base dir
RUN cd /home/ && sudo mkdir /home/base && cd /home/base && sudo chmod 777 /home/base

# 1d. Update & Upgrade
RUN sudo apt-get -y update && sudo apt-get -y upgrade && sudo apt-get -y dist-upgrade

# 2. Additional Ubuntu Packages
RUN  sudo apt-get install -y systemd apt-utils nfs-common nano unzip zip gzip 
RUN sudo apt-get install -y sshpass cmdtest snap nmap net-tools wget curl tcl-tls snapd
RUN sudo apt-get install -y iputils-ping certbot python3-certbot-apache gnupg gnupg2 telnet 
RUN sudo apt-get install -y aptitude build-essential gcc make screen snapd spamc parted openssl   
RUN sudo apt-get install -y systemd procps spamassassin 

# 3. MySQL v8.0.36 - With apt from Ubuntu package archive as at March-31-2024
RUN sudo apt-get -y update 
RUN sudo apt-get -y install mysql-server 

# 4. Python3.x 
RUN sudo apt-get -y install python3  

# 5. Python3-pip
RUN sudo apt-get -y install python3-pip 

# 6. Python3 packages
RUN sudo python3 -m pip install boto3 PyMySQL[rsa] sb-json-tools jupyterlab jupyterlab-night

# 7. Python3 Awscli upgrade
RUN sudo python3 -m pip install --upgrade awscli 

# 8.  Awscli v2 (Architecture: x86_64 or  aarch64/arm64)
#RUN sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" 
RUN sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip" 
RUN sudo chmod 777 awscliv2.zip 
RUN sudo unzip awscliv2.zip 
RUN sudo ./aws/install 

# 9. Node.js v21.x 
RUN sudo apt-get -y update
RUN sudo apt-get install -y ca-certificates curl gnupg
RUN sudo mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_21.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
RUN sudo apt-get -y update
RUN sudo apt-get install -y nodejs

# 10. Node.js packages
RUN npm install --prefix "/home/base" @aws-sdk/client-s3 mysql @mysql/xdevapi sqlite3 duckdb 

# 11. Docker v26.0.0: With apt as at March-31-2024
# includes: docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
RUN sudo apt-get -y update 
RUN sudo apt-get -y install apt-transport-https ca-certificates curl gnupg lsb-release 
RUN sudo mkdir -m 0755 -p /etc/apt/keyrings 
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg 
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null 
RUN sudo apt-get -y update 
RUN sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin 

# 12. Finally, clean up files
RUN sudo rm -rf /var/lib/apt/lists/* 
RUN sudo apt-get autoclean 
RUN sudo apt-get autoremove
