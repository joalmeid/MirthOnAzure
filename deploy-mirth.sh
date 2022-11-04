#!/bin/bash

#Environment vartiables
INSTANCE=<3 LETTER INSTANCE NAME. CHANGE FOR UNIQUENESS>
LOCATION=northeurope
RG=rg-${INSTANCE}Mirth
VNET=vnet-${INSTANCE}Mirth
SUBNET=snet-default
STG=stg${INSTANCE}mirth
VM=vm-${INSTANCE}Mirth
VMW=win-${INSTANCE}Mirth

# Create resource Group
az group create -n $RG -l $LOCATION

#### Deploy Mirth setup at Subscription Scope (Bicep)
az deployment group create -g $RG --template-file ./infra/mirth-main.bicep -p instancePrefix=$INSTANCE

# Delete resource Group
#az group delete -n $RG -y
