@description('Tags to add to the resources')
param tags object

@description('Name of the virtual machine.')
param vmName string

@description('Username for the Virtual Machine.')
param adminUsername string

@description('Password for the Virtual Machine.')
@minLength(12)
@secure()
param adminPassword string

@description('Location for all resources.')
param location string

@description('Virtual Machine Network Interface name.')
param networkInterfaceName string
param subNetId string
param nsgId string

@description('The Windows version for the VM. This will pick a fully patched image of this given Windows version.')
param OSVersion string = '2022-datacenter-azure-edition'

@description('Size of the virtual machine.')
param vmSize string = 'Standard_D2s_v5'

var osDiskType = 'Standard_LRS'

@description('Diagnostics Blob Uri.')
param storageUri string

@description('The custom script URI to be deployed as a Custom Script Extension.')
param mirthAdminInstallScriptUrl string = 'https://raw.githubusercontent.com/joalmeid/MirthOnAzure/main/config/install-mirth-admin.ps1'

resource nic 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: networkInterfaceName
  location: location
  tags: tags
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfigwin'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subNetId
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: nsgId
    }
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: vmName
  location: location
  tags: tags
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: OSVersion
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: osDiskType
        }
      }
      dataDisks: [
        {
          diskSizeGB: 1023
          lun: 0
          createOption: 'Empty'
        }
      ]
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: storageUri
      }  
    }
    
  }
}

resource customscriptextension 'Microsoft.Compute/virtualMachines/extensions@2022-08-01' = {
  parent: vm
  name: 'InstallMirth'
  location:location
  properties:{
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    settings: {
      commandToExecute: 'powershell.exe -ExecutionPolicy Bypass -File install-mirth-admin.ps1'
      fileUris: [
        mirthAdminInstallScriptUrl
      ]
    }
  }
}

output vmId string = vm.id

