#!/bin/bash
set -e

# Install Apple certificates
# -------------------------------------------------------------------------------------------------------
# This script depends on a credential repository having been checked out to a folder called `credentails` 
# under the current working directory. From there files will be referenced and imported.
# The expected folder structure is:
# credentials/
#  ios/
#   certificate.p12 # the certificate file
#   profile.mobileprovision # mobile provision file, for the app and certificate to sign with
#   passphrase # file containing the passphrase for the p12 certificate
# -------------------------------------------------------------------------------------------------------

if [ -z "$RUNNER_TEMP" ]
then
    echo "RUNNER_TEMP is not set"
    echo "You are likely not running this in a GitHub action runner."
    echo "If that is the case, please export the environment variable to some local value."
    exit 1
fi

KEYCHAIN_PASSWORD=$RANDOM

# create variables for output paths
CERTIFICATE_PATH=credentials/ios/certificate.p12
PP_PATH=credentials/ios/profile.mobileprovision
KEYCHAIN_PATH=$RUNNER_TEMP/app-signing.keychain-db
P12_PASSWORD=$(cat credentials/ios/passphrase)

# create temporary keychain
security create-keychain -p "$KEYCHAIN_PASSWORD" $KEYCHAIN_PATH
security set-keychain-settings -lut 21600 $KEYCHAIN_PATH
security unlock-keychain -p "$KEYCHAIN_PASSWORD" $KEYCHAIN_PATH

# get the p12 password


# import certificate to keychain
security import $CERTIFICATE_PATH -P "$P12_PASSWORD" -A -t cert -f pkcs12 -k $KEYCHAIN_PATH
security list-keychain -d user -s $KEYCHAIN_PATH

# apply provisioning profile
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp $PP_PATH ~/Library/MobileDevice/Provisioning\ Profiles