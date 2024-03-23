#!/bin/bash

echo ""
echo "================================================================================"
echo "=== In 03_access_ocp_registry.sh ==============================================="
echo "================================================================================"
echo ""

echo "#### Export GODEBUG=x509ignoreCN=0"
export GODEBUG=x509ignoreCN=0

echo "#### Make the certificates.  Note that your hostname should go in the DNS entry"
rm -f ${CERTSDIRECTORY}
mkdir -p ${CERTSDIRECTORY}
cd ${CERTSDIRECTORY}
openssl req \
 -newkey rsa:4096 -nodes -sha256 -keyout ${CERTSDIRECTORY}/domain.key \
 -addext "subjectAltName = DNS:$HOSTNAME" \
 -subj "/C=US/ST=IL/L=Chicago/O=IBM/OU=Expert Labs/CN=$HOSTNAME" \
 -x509 -days 365 -out ${CERTSDIRECTORY}/domain.crt

echo "#### Get RHEL to trust source.  Note that your hostname should be the name of your certifcate"
cp ${CERTSDIRECTORY}/domain.crt /etc/pki/ca-trust/source/anchors/$HOSTNAME.crt
update-ca-trust

echo "#### Restart podman"
systemctl stop podman
systemctl start podman

echo "#### Login to the OpenShift cluster"
oc login -u kubeadmin -p $KUBEADMINPASSWORD

echo "#### Load the domain.crt in a configmap"
rm -f ${CERTSDIRECTORY}/ca.crt
cp ${CERTSDIRECTORY}/domain.crt ${CERTSDIRECTORY}/ca.crt
oc delete configmap registry-config -n openshift-config
oc create configmap registry-config -n openshift-config --from-file=$HOSTNAME..5000=${CERTSDIRECTORY}/ca.crt

echo "#### Sleep for 60 seconds to allow configmap creation to settle down. Important on ROKS/Techzone"
sleep 60

echo "#### Tell the OpenShift cluster to trust the podman private registry"
oc patch image.config.openshift.io/cluster --patch '{"spec":{"additionalTrustedCA":{"name":"registry-config"}}}' --type=merge

echo "#### Check if we can login to the OpenShift cluster registry"
while [ true ]
do
    podman login $(oc registry info --public) -u kubeadmin -p $(oc whoami -t) --tls-verify=false
    if [ $? -eq 0 ]; then
        echo "#### Successfully logged in to OpenShift cluster registry"
        break
    else
        echo "#### Unable to login to OpenShift cluster registry"
        echo "#### Sleeping for 20 seconds"
        sleep 20
    fi
done