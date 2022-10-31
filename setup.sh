INSTANCE=joa
LOCATION=northeurope
RG=${INSTANCE}Mirth
VNET=vnet-${INSTANCE}Mirth
SUBNET=snet-default
STG=stg${INSTANCE}mirth
VM=vm-${INSTANCE}Mirth
VMW=win-${INSTANCE}Mirth

az group create -n $RG -l $LOCATION
az storage account create -l $LOCATION -n $STG -g $RG --sku Standard_LRS 
#--kind StorageV2

az network nsg create -n nsg-${INSTANCE}Mirth -g $RG -l $LOCATION

az network vnet create \
    -n $VNET \
    -g $RG \
    --address-prefixes 10.1.0.0/16 \
    --subnet-name $SUBNET \
    --subnet-prefixes 10.1.0.0/24 \
    --ddos-protection false \
    --nsg nsg-${INSTANCE}Mirth



#### BICEP ## Deploy Target Scope Subscription
az deployment sub create \
  --name MirthEnvironment \
  --location $LOCATION \
  --template-file mirth-main.bicep \
  --parameters instancePrefix=$INSTANCE location=westeurope

#### BICEP ## Deploy Target Scope Subscription
az group create -n rg-joaMirth -l northeurope
az deployment group create -g rg-joaMirth --template-file mirth.bicep -p instancePrefix=joa adminPasswordOrKey=Q1w2e3r4t5y6. 
az group create -n rg-joaMirth -l northeurope && az deployment group create -g rg-joaMirth --template-file mirth-main.bicep -p instancePrefix=joa -w

## Test
az group create -n rg-joaMirth -l northeurope && az deployment group create -g rg-joaMirth --template-file testMirth.bicep -p adminPasswordOrKey=Q1w2e3r4t5y6.


VM Extension
https://github.com/brwilkinson/AzureDeploymentFramework/blob/7368868d960f34a039c0705ca5b854e3080d03b3/ADF/bicep/VM.bicep