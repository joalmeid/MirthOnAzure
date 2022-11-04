
targetScope = 'resourceGroup'

@description('Tags to add to the resources')
param tags object = {Area: 'Healthcare', Interoperability: 'Mirth Connect', Environment: 'demo'}

@description('The name for the Resource Group to deploy Mirth Resources.')
param resourceGroupLocation string = 'northeurope'
@minLength(3)
@maxLength(3)
@description('A prefix for this Mirth instance.')
param instancePrefix string


var storageName = 'stg${instancePrefix}mirth'
var vnetName = 'vnet-${instancePrefix}mirth'
var subNetName = 'snet-${instancePrefix}mirth'
var nsgName = 'nsg-${instancePrefix}mirth'
@description('The name of the Linux Virtual Machine with Mirth Server installed.')
var vmEngineName = 'vml-${instancePrefix}mirth'
@description('The name of the Windows Virtual Machine to run Mirth client application.')
var vmClientName = 'vmw-${instancePrefix}mirth'
var bastionName = 'bst-${instancePrefix}mirth'
var publicIpBastionName = 'pip-bst-${instancePrefix}mirth'

module mirthNetworking 'mirth-networking.bicep' = {
  name: 'networkingModule'
  params: {
    location: resourceGroupLocation
    networkSecurityGroupName: nsgName
    virtualNetworkName: vnetName
    subnetName: subNetName
    tags: tags
  }
}

module mirthStorageAcct 'mirth-storage.bicep' = {
  name: 'storageModule'
  dependsOn: [ mirthNetworking ]
  params: {
    location: resourceGroupLocation
    storageName: storageName
    virtualNetworkId: mirthNetworking.outputs.vnetId
    subnetId: mirthNetworking.outputs.subnetId
    privateEndpointStorageBlobName: 'peb-${storageName}'
    // blobPrivateDnsZoneName: blobPrivateDnsZoneName
    tags: tags
  }
}

module mirthServer 'mirth-server.bicep' = {
  name: 'mirthServerModule'
  dependsOn: [ mirthStorageAcct, mirthNetworking ]
  params: {
    vmName: vmEngineName
    location: resourceGroupLocation
    adminUsername: 'mirth'
    adminPasswordOrKey: 'Q1w2e3r4t5y6.'
    networkInterfaceName: 'nic-${vmEngineName}'
    nsgId: mirthNetworking.outputs.nsgId
    subnetId: mirthNetworking.outputs.subnetId
    storageUri: mirthStorageAcct.outputs.storageUri
    tags: tags
  }
}

module mirthClient 'mirth-jumpbox.bicep' = {
  name: 'mirthClientModule'
  dependsOn: [ mirthStorageAcct, mirthNetworking ]
  params: {
    vmName: vmClientName
    location: resourceGroupLocation
    adminUsername: 'mirth'
    adminPassword: 'Q1w2e3r4t5y6.'
    nsgId: mirthNetworking.outputs.nsgId
    networkInterfaceName: 'nic-${vmClientName}'
    subNetId: mirthNetworking.outputs.subnetId
    storageUri: mirthStorageAcct.outputs.storageUri
    tags: tags
  }
}

module mirthBastion 'mirth-vmaccess.bicep' = {
  name: 'mirthBastionModule'
  dependsOn: [ mirthServer, mirthClient ]
  params: {
    location: resourceGroupLocation
    azureBastionName: bastionName
    azureBastionPublicIpName: publicIpBastionName
    azureBastionSubnetId: mirthNetworking.outputs.bastionSubnetId
    tags: tags
  }
}


