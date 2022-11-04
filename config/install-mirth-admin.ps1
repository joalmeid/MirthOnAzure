## Setting log
Start-Transcript -Append .\mirth-admin-install.log -NoClobber -Force

$TEMP="$env:TEMP\mirth"
Set-Location "$TEMP"

#Requirements
Write-Host "Installing JDK 19 ..." -ForegroundColor Cyan
$JDKPATH = "${env:ProgramFiles}\Java\jdk19"
if(Test-Path $JDKPATH) { Remove-Item $JDKPATH -Recurse -Force }

$OPENJDK_VERSION='19.0.1'
$FILE="openjdk-${OPENJDSK_VERSION}_windows-x64_bin.zip"
Write-Host "Downloading OpenJDSK $OPENJDSK_VERSION." -ForegroundColor Cyan
(New-Object Net.WebClient).DownloadFile("https://download.java.net/java/GA/jdk$OPENJDSK_VERSION/afdd2e245b014143b62ccb916125e3ce/10/GPL/$FILE", "$TEMP\$FILE")

Write-Host "Unpacking OpenJDSK $OPENJDK_VERSION." -ForegroundColor Cyan
Expand-Archive ".\$FILE" -DestinationPath "$TEMP\jdk19_temp" -Force
[IO.Directory]::Move("$TEMP\jdk19_temp\jdk-$OPENJDK_VERSION", $JDKPATH)

#Clean up
Remove-Item "$TEMP\jdk19_temp" -Recurse -Force
del "$TEMP\$FILE"

#Environmental vars
$path = [Environment]::GetEnvironmentVariable('Path', 'Machine')
[Environment]::SetEnvironmentVariable('Path', $path + ';' + "$JDKPATH\bin", 'Machine')

[Environment]::SetEnvironmentVariable('JAVA_HOME', $JDKPATH, 'Machine')
[Environment]::SetEnvironmentVariable('JDK_HOME', '%JAVA_HOME%', 'Machine')
[Environment]::SetEnvironmentVariable('JRE_HOME', '%JAVA_HOME', 'Machine')

#Test JDK install
cmd /c "`"$JDKPATH\bin\java`" --version"
Write-Host "JDK 19 installed" -ForegroundColor Green

# Install Mirth Administrator Launcher
Write-Host "Installing Mirth Connect Administrator ${MIRTH_CONNECT_VERSION}" -ForegroundColor Cyan
$MIRTH_CONNECT_ADMIN_VERSION='1.2.0'
$FILE="mirth-administrator-launcher-$MIRTH_CONNECT_ADMIN_VERSION-windows-x64.exe"

Invoke-WebRequest -Uri "https://s3.amazonaws.com/downloads.mirthcorp.com/connect-client-launcher/$FILE" -outfile "$TEMP\$FILE"
$mirthAdminInstall = Start-Process "$TEMP\$FILE" -PassThru -Wait -ArgumentList @('-q', '-nofilefailures', '-console')
if($mirthAdminInstall.ExitCode -eq 0) { Write-Host "Mirth Connect Administrator ${MIRTH_CONNECT_ADMIN_VERSION}" installed -ForegroundColor Green }

#Clean up
Remove-Item -Path "$TEMP\$FILE" -Force

Stop-Transcript