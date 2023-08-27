#!/bin/bash

echo ""
echo "================================================================================"
echo "=== In 02_setup_env.sh ========================================================="
echo "================================================================================"
echo ""

# Enable public registry route on OpenShift cluster
echo "" &&  echo "#### Enable public registry route on OpenShift cluster" && echo ""
oc patch configs.imageregistry.operator.openshift.io/cluster --type merge -p '{"spec":{"defaultRoute":true}}'

# Check if access exists to OCP image registry
echo "" &&  echo "#### Check if access exists to OCP image registry" && echo ""
while [ true ]
do
    oc registry info --public
    if [ $? -eq 0 ]; then
        echo "#### Public route for OpenShift cluster registry IS available."
        # While loop to successfully export value of OCP image registry
        while [ true ]
        do
            export OCPREGISTRYROUTE=$(oc registry info --public)
            if [[ $OCPREGISTRYROUTE == *"default"* ]]; then
                echo "#### Successfully obtained the OCP image registry URL"
                echo "#### OCP image registry URL is: [${OCPREGISTRYROUTE}]"
                break
            else
                echo "#### Could NOT obtain the OCP image registry URL"
                echo "#### Sleeping for 10 seconds"
                sleep 10
            fi
        done
        break
    else
        echo "#### Public route for OpenShift cluster registry is NOT available."
        echo "#### Sleeping for 10 seconds"
        sleep 10
    fi
done

export NS="cp4ba"
export SERVICEACCOUNTNAME="openldap"
export OPENLDAPIMAGESTREAM="openldap_bootstrap:1.0"
export OPENLDAPIMAGE="${OCPREGISTRYROUTE}/${NS}/${OPENLDAPIMAGESTREAM}"
export PHPLDAPADMINIMAGESTREAM="phpldapadmin_new:1.0"
export PHPLDAPADMINIMAGE="${OCPREGISTRYROUTE}/${NS}/${PHPLDAPADMINIMAGESTREAM}"
export LDAPADMINPASSWORD=""
export KUBEADMINPASSWORD=""
export DOCKERUSERNAME=""
export DOCKERPASSWORD=""
export STORAGECLASSNAME="nfs-managed-storage"

echo "================================================================================"
echo "========= OpenLDAP image is: [${OPENLDAPIMAGE}] "
echo "========= PhpLDAP admin image is: [${PHPLDAPADMINIMAGE}] "
echo "================================================================================"