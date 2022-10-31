#!/bin/bash

MIRTH_CONNECT_VERSION='4.1.1.b303'
echo "######### Installing Mirth Connect ${MIRTH_CONNECT_VERSION}"

# Update Ubuntu
sudo apt-get update

# Make the ~/downloads folder
mkdir ~/downloads
cd ~/downloads/

# Requirements

# Install the OpenJDK (older versions of Nextgen  required the Oracle Java JDK but that is not a requirement on newer versions of NextGen Connect)
echo "######### Installing default Ubuntu Java RE"
sudo apt install default-jre -y

# Download the most up to date Nextgen Connect binnaries. 
MIRTH_CONNECT_BIN=mirthconnect-${MIRTH_CONNECT_VERSION}-unix # MIRTH CONNECT
MIRTH_CONNECT_CLI=mirthconnectcli-${MIRTH_CONNECT_VERSION}-unix # Mirth Connect Command Line Interface

wget https://s3.amazonaws.com/downloads.mirthcorp.com/connect/${MIRTH_CONNECT_VERSION}/$MIRTH_CONNECT_BIN.tar.gz
wget https://s3.amazonaws.com/downloads.mirthcorp.com/connect/${MIRTH_CONNECT_VERSION}/$MIRTH_CONNECT_CLI.tar.gz

tar xvfz $MIRTH_CONNECT_BIN.tar.gz
sudo mv Mirth\ Connect/ /opt/mirthconnect

# Enable mcservice servicenano
echo "######### Starting Mirth Connect ${MIRTH_CONNECT_VERSION} as a service."
sudo systemctl enable mirthconnect
