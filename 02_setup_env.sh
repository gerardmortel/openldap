#!/bin/bash

# Enable public registry route on OpenShift cluster
oc patch configs.imageregistry.operator.openshift.io/cluster --type merge -p '{"spec":{"defaultRoute":true}}'

# Check access exists to OCP image registry
echo "Sleeping for 2 minutes to allow for patch to take effect"
sleep 120
echo "Checking for public route of openshift cluster registry"
oc registry info --public

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
