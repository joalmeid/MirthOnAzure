@description('Tags to add to the resources')
param tags object

@description('The name for the Azure Bastion resource.')
param azureBastionName string = 'bst-'
@description('The name for the Azure Bastion Public IP resource.')
param azureBastionPublicIpName string = 'pip-bastion'
@description('The SKU for the Azure Bastion resource.')
param azureBastionSku string = 'Basic'
@description('Subnet Id to deploy Azure Bastion.')
param azureBastionSubnetId string = 'AzureBastionSubnet'

param location string = resourceGroup().location

// resource bastion_subnet 'Microsoft.Network/virtualNetworks/subnets@2022-05-01' = {
//     name: '${vnetName}/${azureBastionSubnetName}'
//     properties: {
//         addressPrefix: azureBastionSubnetAddressPrefix
//     }
// }

// Create the Public IP Address (PIP) for Azure Bastion to use
resource bastion_public_ip 'Microsoft.Network/publicIPAddresses@2022-05-01' = {
    name: azureBastionPublicIpName
    location: location
    tags: tags
    sku: {
        name: 'Standard'
    }
    properties: {
        publicIPAddressVersion: 'IPv4'
        publicIPAllocationMethod: 'Static'
    }
}
resource bastion 'Microsoft.Network/bastionHosts@2022-05-01' = {
  name: azureBastionName
  location: location
  tags: tags
  sku: {
      name: azureBastionSku
  }
  properties: {
      ipConfigurations: [
          {
              name: 'IpConf'
              properties: {
                  privateIPAllocationMethod: 'Dynamic'
                  publicIPAddress: {
                      id: bastion_public_ip.id
                  }
                  subnet: {
                      id: azureBastionSubnetId
                  }
              }
          }
      ]
  }
}
