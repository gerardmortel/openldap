#!/bin/bash

# Enable public registry route on OpenShift cluster
oc patch configs.imageregistry.operator.openshift.io/cluster --type merge -p '{"spec":{"defaultRoute":true}}'

# Check if access exists to OCP image registry
while [ true ]
do
    oc registry info --public
    if [ $? -eq 0 ]; then
        echo "Public route for OpenShift cluster registry IS available."
        break
    else
        echo "Public route for OpenShift cluster registry is NOT available."
        echo "Sleeping for 10 seconds"
        sleep 10
    fi
done

export NS="cp4ba"
export SERVICEACCOUNTNAME="openldap"
export OPENLDAPIMAGESTREAM="openldap_bootstrap:1.0"
export OPENLDAPIMAGE="$(oc registry info --public)/${NS}/${OPENLDAPIMAGESTREAM}"
export PHPLDAPADMINIMAGESTREAM="phpldapadmin_new:1.0"
export PHPLDAPADMINIMAGE="$(oc registry info --public)/${NS}/${PHPLDAPADMINIMAGESTREAM}"
export LDAPADMINPASSWORD=""
export STORAGECLASSNAME="nfs-managed-storage"

echo ""
echo "OpenLDAP image is:[${OPENLDAPIMAGE}]"
echo "PhpLDAP admin image is:[${PHPLDAPADMINIMAGE}]"
echo ""
