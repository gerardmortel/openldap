#!/bin/bash

echo ""
echo "================================================================================"
echo "=== In 04_build_openldap_image.sh =============================================="
echo "================================================================================"
echo ""

echo "#### Create the project where openldap will live if it does not already exist"
oc new-project ${NS}

echo "#### Switch to project ${NS}"
oc project ${NS}

echo "#### Login to Docker"
podman login docker.io -u $DOCKERUSERNAME -p $DOCKERPASSWORD

echo "#### Create Dockerfile for openldap container image"
cat << EOF > new_Dockerfile_OpenLDAP
# Pull the latest base image from Dockerhub
FROM docker.io/osixia/openldap:latest

# Set the environment variables
ENV LDAP_ORGANISATION="Your Company Name" \
LDAP_DOMAIN="your.company.com" \
LDAP_BASE_DN="dc=your,dc=company,dc=com"

COPY bootstrap.ldif /container/service/slapd/assets/config/bootstrap/ldif/50-bootstrap.ldif
EOF

echo "#### Build the openldap image"
podman build -t ${OPENLDAPIMAGE} -f new_Dockerfile_OpenLDAP

echo "#### Check if we can login to the OpenShift cluster registry"
while [ true ]
do
    podman login $(oc registry info --public) -u kubeadmin -p $(oc whoami -t) --tls-verify=false
    if [ $? -eq 0 ]; then
        echo "#### Successfully logged in to OpenShift cluster registry"
        break
    else
        echo "#### Unable to login to OpenShift cluster registry"
        echo "#### Sleeping for 10 seconds"
        sleep 10
    fi
done

echo "#### Push ${OPENLDAPIMAGE} image to OpenShift cluster registry"
while [ true ]
do
    podman login $(oc registry info --public) -u kubeadmin -p $(oc whoami -t) --tls-verify=false
    podman push ${OPENLDAPIMAGE} --tls-verify=false
    if [ $? -eq 0 ]; then
        echo "#### Successfully pushed ${OPENLDAPIMAGE} image to OpenShift cluster registry"
        break
    else
        echo "#### Unable to push ${OPENLDAPIMAGE} image to OpenShift cluster registry"
        echo "#### Sleeping for 10 seconds"
        sleep 10
    fi
done