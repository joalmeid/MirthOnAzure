#!/bin/bash

MIRTH_CONNECT_VERSION='4.1.1.b303'
echo "Installing Mirth Connect ${MIRTH_CONNECT_VERSION}"

# Update Ubuntu
sudo apt-get update

# Make the ~/downloads folder
mkdir ~/downloads
cd ~/downloads/

# Requirements

# Install the OpenJDK (older versions of Nextgen  required the Oracle Java JDK but that is not a requirement on newer versions of NextGen Connect)
echo "Installing default Ubuntu Java RE"
sudo apt install default-jre -y
# sudo apt install openjdk-11-jre-headless -y

#MYSQL
# #sudo apt-get install mysql-server -y
# sudo systemctl start mysql.service
# # sudo systemctl status mysql.service
# #/usr/bin/mysql_secure_installation

# Create Mirth Database
# # sudo mysql -u root -e "create database mirthdb;"
# # sudo mysql -u root -e "CREATE USER 'mirthuser' IDENTIFIED BY 'Q1w2e3r4t5y6.';"
# # sudo mysql -u root -e "grant all on mirthdb.* to 'mirthuser';" # identified by 'Q1w2e3r4t5y6.' with grant option;"
# # sudo mysql -uroot -e "use mirthdb;SHOW TABLES;"

# Download the most up to date Nextgen Connect binnaries. 
# installer : curl -O https://s3.amazonaws.com/downloads.mirthcorp.com/connect/${MIRTH_CONNECT_VERSION}/$MIRTH_CONNECT_BIN.sh
MIRTH_CONNECT_BIN=mirthconnect-${MIRTH_CONNECT_VERSION}-unix # MIRTH CONNECT
MIRTH_CONNECT_CLI=mirthconnectcli-${MIRTH_CONNECT_VERSION}-unix # Mirth Connect Command Line Interface

wget https://s3.amazonaws.com/downloads.mirthcorp.com/connect/${MIRTH_CONNECT_VERSION}/$MIRTH_CONNECT_BIN.tar.gz
wget https://s3.amazonaws.com/downloads.mirthcorp.com/connect/${MIRTH_CONNECT_VERSION}/$MIRTH_CONNECT_CLI.tar.gz

tar xvfz $MIRTH_CONNECT_BIN.tar.gz
sudo mv Mirth\ Connect/ /opt/mirthconnect
#tail -f /opt/mirthconnect/logs/mirth.log

# Configure Mirth for Mysql
# mv ~/downloads/mirth.properties /opt/mirthconnect/conf/mirth.properties

# Enable mcservice servicenano
# /opt/mirthconnect/mcservice start
# /opt/mirthconnect/mcservice status
#mv ~/downloads/mirthconnect.service /etc/systemd/system/mirthconnect.service
# systemctl enable mirthconnect
# systemctl start mirthconnect
# systemctl stop mirthconnect

