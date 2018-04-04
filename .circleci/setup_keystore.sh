#!/bin/bash

set -ex
set -o pipefail

export GRADLE_PROPERTIES=$HOME"/repo/gradle.properties"
export KEYSTORE_PROPERTIES=$HOME"/repo/keystores/keystore.properties"
export STORE_FILE_LOCATION=$HOME"/repo/art-android.jks"

function copyEnvVarsToProperties {

    echo "Gradle Properties should exist at $GRADLE_PROPERTIES"
    echo "Keystore Properties should exist at $KEYSTORE_PROPERTIES"

    if [ ! -f "$KEYSTORE_PROPERTIES" ]
    then
        echo "${KEYSTORE_PROPERTIES} does not exist...Creating file"

        touch ${KEYSTORE_PROPERTIES}

        echo "keyAlias=$KEY_ALIAS" >> ${KEYSTORE_PROPERTIES}
        echo "keyPassword=$KEY_PASSWORD" >> ${KEYSTORE_PROPERTIES}
        echo "storeFile=$STORE_FILE" >> ${KEYSTORE_PROPERTIES}
        echo "storePassword=$STORE_PASSWORD" >> ${KEYSTORE_PROPERTIES}
    fi

    if [ ! -f "$GRADLE_PROPERTIES" ]
    then
        echo "${GRADLE_PROPERTIES} does not exist...Creating Properties file"

	echo "API_BASE_URL=$API_BASE_URL" >> ${GRADLE_PROPERTIES}
	echo "DEV_API_BASE_URL=$DEV_API_BASE_URL" >> ${GRADLE_PROPERTIES}
	echo "API_KEY=$API_KEY" >> ${GRADLE_PROPERTIES}
	echo "SERVICE_ACCOUNT_EMAIL=$SERVICE_ACCOUNT_EMAIL" >> ${GRADLE_PROPERTIES}

    fi

    if [ ! -f "$PUBLISH_KEY_FILE" ]
    then
        echo "${PUBLISH_KEY_FILE} does not exist...creating properties file"

        touch ${PUBLISH_KEY_FILE}

        echo "$PUBLISH_JSON_KEY" >> ${PUBLISH_KEY_FILE}
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
}

main() {
  
  downloadKeyStoreFile

}

main "$@"