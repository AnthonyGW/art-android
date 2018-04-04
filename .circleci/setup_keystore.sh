#!/bin/bash

set -ex
set -o pipefail

export KEYSTORE_DIR=$HOME"/repo/keystores"
export KEYSTORE_PROPERTIES=$HOME"/repo/keystores/keystore.properties"
export DEBUG_KEYSTORE_PROPERTIES=$HOME"/repo/keystores/debug.keystore.properties"
export STORE_FILE_LOCATION=$HOME"/repo/art-android.jks"
export DEBUG_STORE_FILE_LOCATION=$HOME"/repo/debug.keystore"

function copyEnvVarsToProperties {

    echo "Keystore Properties should exist at $KEYSTORE_PROPERTIES"

    if [ ! -f "$KEYSTORE_PROPERTIES" ]
    then
        echo "${KEYSTORE_PROPERTIES} does not exist...Creating file"

        if [ ! -d "$KEYSTORE_DIR" ]
        then
            mkdir $KEYSTORE_DIR
        fi

        touch ${KEYSTORE_PROPERTIES}

        echo "keyAlias=$KEY_ALIAS" >> ${KEYSTORE_PROPERTIES}
        echo "keyPassword=$KEY_PASSWORD" >> ${KEYSTORE_PROPERTIES}
        echo "storeFile=$STORE_FILE" >> ${KEYSTORE_PROPERTIES}
        echo "storePassword=$STORE_PASSWORD" >> ${KEYSTORE_PROPERTIES}
    fi

    echo "Debug Keystore Properties should exist at $KEYSTORE_PROPERTIES"

    if [ ! -f "$DEBUG_KEYSTORE_PROPERTIES" ]
    then
        echo "${DEBUG_KEYSTORE_PROPERTIES} does not exist...Creating file"

        if [ ! -d "$KEYSTORE_DIR" ]
        then
            mkdir $KEYSTORE_DIR
        fi

        touch ${DEBUG_KEYSTORE_PROPERTIES}

        echo "keyAlias=$DEBUG_KEY_ALIAS" >> ${DEBUG_KEYSTORE_PROPERTIES}
        echo "keyPassword=$DEBUG_KEY_PASSWORD" >> ${DEBUG_KEYSTORE_PROPERTIES}
        echo "storeFile=$DEBUG_STORE_FILE" >> ${DEBUG_KEYSTORE_PROPERTIES}
        echo "storePassword=$DEBUG_STORE_PASSWORD" >> ${DEBUG_KEYSTORE_PROPERTIES}
    fi
}

# download key store file from remote location
# keystore URI will be the location uri for the *.jks file for signing application
function downloadKeyStoreFile {
    # use curl to download a keystore from $KEYSTORE_URI, if set,
    # to the path/filename set in $KEYSTORE.
    echo "Looking for $STORE_FILE_LOCATION ..."

    if [ ! -f ${STORE_FILE_LOCATION} ] ; then
        echo "Downloading keystore file"

        curl -L -o ${STORE_FILE} ${KEY_STORE_URI}
    else
            echo "Keystore uri not set, .APK artifact will not be signed."
    fi

    echo "Looking for $DEBUG_STORE_FILE_LOCATION ..."

    if [ ! -f ${DEBUG_STORE_FILE_LOCATION} ] ; then
        echo "Downloading debug keystore file"

        curl -L -o ${DEBUG_STORE_FILE} ${DEBUG_KEY_STORE_URI}
    else
            echo "Debug keystore uri not set, .APK artifact will not be signed."
    fi
}

main() {
  
  copyEnvVarsToProperties
  downloadKeyStoreFile

}

main "$@"