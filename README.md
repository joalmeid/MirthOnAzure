# MirthOnAzure

When working with healthcare data there are tons of topics to think about around infrastructure, security, compliance, health standards and many others.

When working with HL7, DICOM, FHIR or other health data standards, many tools can be used for ingestion, transformation or simply to store it. 

**Mirth Connect by [NextGen Healthcare](https://www.nextgen.com/products-and-services/integration-engine)** is an open source integrtation engine commonly used by healthcare organizations. Specially to better support older and modern standards.  

This repo is a quick accelerator to setup the OSS Mirth COnnect on Azure.

## QuickStart

Open a bash prompt in your VSCode, and change the INSTANCE environment variable. For instance use a 3 letter acronym. 
Then, create the resource group and run the [bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview?tabs=bicep) deployment.

```bash
#Environment vartiables
INSTANCE=<CHANGE FOR UNIQUENESS>
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

```
## Clean up

In order to clean your environment simply delete the created resource group:

```bash
az group delete -n $RG -y
```
