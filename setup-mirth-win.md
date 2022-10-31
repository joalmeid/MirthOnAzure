##Windows
az vm create \
    -g $RG \
    -n $VMW \
    --size Standard_D2s_v3 \
    --image Win2022Datacenter \
    --admin-username mirth \
    --admin-password Q1w2e3r4t5y6. \
    --storage-sku StandardSSD_LRS \
    --os-disk-size-gb 127 \
    --data-disk-sizes-gb 32 \
    --ultra-ssd-enabled false \
    --vnet-name $VNET \
    --subnet $SUBNET \
    --public-ip-sku Basic \
    --nsg nsg-${INSTANCE}Mirth \
    --boot-diagnostics-storage $STG

az vm open-port -g $RG -n $VMW --port 3389 --priority 103

az vm stop -n $VMW -g $RG
az vm start -n $VMW -g $RG 

mkdir c:\MIRTH && cd $_
iwr -URI https://s3.amazonaws.com/downloads.mirthcorp.com/connect/4.1.1.b303/mirthconnect-4.1.1.b303-windows-x64.exe -OutFile .\mirthconnect-4.1.1.b303-windows-x64.exe
iwr -URI https://s3.amazonaws.com/downloads.mirthcorp.com/connect-client-launcher/mirth-administrator-launcher-latest-windows-x64.exe -OutFile .\mirth-administrator-launcher-latest-windows-x64.exe

Invoke-WebRequest https://api.adoptopenjdk.net/v3/installer/latest/11/ga/windows/x64/jdk/hotspot/normal/adoptopenjdk?project=jdk -OutFile .\openjdk11.msi

Start-Process -Wait -FilePath msiexec -ArgumentList /i, ".\openjdk11.msi", "ADDLOCAL=FeatureMain,FeatureEnvironment,FeatureJarFileRunWith,FeatureJavaHome", 'INSTALLDIR="C:\Program Files\Java"', /quiet -Verb RunAs
