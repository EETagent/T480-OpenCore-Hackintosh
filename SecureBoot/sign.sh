#!/bin/bash

LINK=$1
# https://github.com/dortania/build-repo/releases/download/OpenCorePkg-e8cc05f/OpenCore-0.6.4-RELEASE.zip
VERSION=$2
# 0.6.4

mkdir Signed
mkdir Signed/Drivers

# Decrypt signing keys
gpg --decrypt ISK.key.gpg > ISK.key
gpg --decrypt ISK.pem.gpg > ISK.pem

# Download and unzip OpenCore
wget $LINK
unzip "OpenCore-${VERSION}-RELEASE.zip" "X64/*" -d "./Downloaded"
unzip "OpenCore-${VERSION}-RELEASE.zip" "Docs/*" -d "./Downloaded"
rm "OpenCore-${VERSION}-RELEASE.zip"


# Sign drivers
sbsign --key ISK.key --cert ISK.pem --output ./Signed/BOOTx64.efi ./Downloaded/X64/EFI/BOOT/BOOTx64.efi
sbsign --key ISK.key --cert ISK.pem --output ./Signed/OpenCore.efi ./Downloaded/X64/EFI/OC/OpenCore.efi
sbsign --key ISK.key --cert ISK.pem --output ./Signed/Bootstrap.efi ./Downloaded/X64/EFI/OC/Bootstrap/Bootstrap.efi
sbsign --key ISK.key --cert ISK.pem --output ./Signed/Drivers/OpenRuntime.efi ./Downloaded/X64/EFI/OC/Drivers/OpenRuntime.efi
sbsign --key ISK.key --cert ISK.pem --output ./Signed/Drivers/OpenCanopy.efi ./Downloaded/X64/EFI/OC/Drivers/OpenCanopy.efi
sbsign --key ISK.key --cert ISK.pem --output ./Signed/Drivers/AudioDxe.efi ./Downloaded/X64/EFI/OC/Drivers/AudioDxe.efi
sbsign --key ISK.key --cert ISK.pem --output ./Signed/Drivers/CrScreenshotDxe.efi ./Downloaded/X64/EFI/OC/Drivers/CrScreenshotDxe.efi

# Replace drivers
mv ./Signed/BOOTx64.efi  ../BOOT/BOOTx64.efi
mv ./Signed/OpenCore.efi ../OC/OpenCore.efi
mv ./Signed/Bootstrap.efi ../OC/Bootstrap/Bootstrap.efi
mv ./Signed/Drivers/* ../OC/Drivers/

# Replace changelog and configuration
mv ./Downloaded/Docs/Configuration.pdf  ../Other/OpenCore_Configuration.pdf
mv ./Downloaded/Docs/Differences.pdf  ../Other/OpenCore_Differences.pdf

# Clean folder
rm -r Signed Downloaded ISK.key ISK.pem
