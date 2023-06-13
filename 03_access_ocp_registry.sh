#!/bin/bash

echo ""
echo "================================================================================"
echo "=== In 03_access_ocp_registry.sh================================================"
echo "================================================================================"
echo ""

# Export this variable
export GODEBUG=x509ignoreCN=0

# Make the certificates.  Note that your hostname should go in the DNS entry
mkdir -p /certs
cd /certs
openssl req \
 -newkey rsa:4096 -nodes -sha256 -keyout /certs/domain.key \
 -addext "subjectAltName = DNS:$HOSTNAME" \
 -subj "/C=US/ST=IL/L=Chicago/O=IBM/OU=Expert Labs/CN=$HOSTNAME" \
 -x509 -days 365 -out /certs/domain.crt

# Get RHEL to trust source.  Note that your hostname should be the name of your certifcate
cp /certs/domain.crt /etc/pki/ca-trust/source/anchors/$HOSTNAME.crt
update-ca-trust

# Restart podman
systemctl stop podman
systemctl start podman

# Load the domain.crt in a configmap
rm -f /certs/ca.crt
cp /certs/domain.crt /certs/ca.crt
oc create configmap registry-config -n openshift-config --from-file=$HOSTNAME..5000=/certs/ca.crt

#  Tell the OpenShift cluster to trust the podman private registry
oc patch image.config.openshift.io/cluster --patch '{"spec":{"additionalTrustedCA":{"name":"registry-config"}}}' --type=merge

# Login to the OpenShift cluster
oc login -u kubeadmin -p $KUBEADMINPASSWORD

# Check if we can login to the OpenShift cluster registry
while [ true ]
do
    podman login $(oc registry info --public) -u kubeadmin -p $(oc whoami -t) --tls-verify=false
    if [ $? -eq 0 ]; then
        echo "Successfully logged in to OpenShift cluster registry"
        break
    else
        echo "Unable to login to OpenShift cluster registry"
        echo "Sleeping for 10 seconds"
        sleep 10
    fi
done

echo ""
echo "================================================================================"
echo ""