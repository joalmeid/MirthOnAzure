## Linux
az vm create \
    -g $RG \
    -n $VM \
    --size Standard_D2s_v3 \
    --image UbuntuLTS \
    --admin-username azureuser \
    --generate-ssh-keys \
    --admin-username mirth \
    --admin-password Q1w2e3r4t5y6. \
    --storage-sku Premium_LRS \
    --os-disk-size-gb 60 \
    --data-disk-sizes-gb 32 \
    --ultra-ssd-enabled false \
    --vnet-name $VNET \
    --subnet $SUBNET \
    --public-ip-sku Basic \
    --nsg nsg-${INSTANCE}Mirth \
    --boot-diagnostics-storage $STG
az vm stop -n $VM -g $RG
az vm start -n $VM -g $RG 

az vm open-port -g $RG -n $VM --port 22 --priority 100
az vm open-port -g $RG -n $VM --port 8080 --priority 101
az vm open-port -g $RG -n $VM --port 8443 --priority 102

az vm boot-diagnostics enable -n $VM -g $RG --storage https://$STG.blob.core.windows.net/

az vm diagnostics set
vm_resource_id=$(az vm show -g $RG -n $VM --query "id" -o tsv)
default_config=$(az vm diagnostics get-default-config \
    | sed "s#__DIAGNOSTIC_STORAGE_ACCOUNT__#$STG#g" \
    | sed "s#__VM_OR_VMSS_RESOURCE_ID__#$STG#g")

ssh mirth@20.238.106.21

### Mirth Connect setup http://20.238.106.21:8080 http://20.238.106.21:8443

# Update Ubuntu
sudo apt-get update

# Make the ~/downloads folder
mkdir ~/downloads
cd ~/downloads/

# Download the most up to date Nextgen Connect installer. 
MIRTH_INSTALLER=mirthconnect-4.1.1.b303-unix
curl -O https://s3.amazonaws.com/downloads.mirthcorp.com/connect/4.1.1.b303/$MIRTH_INSTALLER.sh

# (Optional) You may want to install nginx to manage SSL, basic auth or to provide multiple DNS endpoints for your NextGen  instance 
sudo apt-get install nginx

# Install the OpenJDK (older versions of Nextgen  required the Oracle Java JDK but that is not a requirement on newer versions of NextGen Connect)
sudo apt install openjdk-11-jre-headless

# Set the permissions to be able to run the installer script
sudo chmod a+x ~/downloads/$MIRTH_INSTALLER.sh

# Now run the Nextgen Connect installer
sudo ~/downloads/$MIRTH_INSTALLER.sh

folder: /usrl/local/mirthconnect

#MirthConnect CLI
mccommand -a https://localhost:8443 -u admin -p admin