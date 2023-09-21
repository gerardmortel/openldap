#!/bin/bash

echo ""
echo "================================================================================"
echo "=== In 04_build_openldap_image.sh =============================================="
echo "================================================================================"
echo ""

# Create the project where openldap will live if it does not already exist
echo "" &&  echo "#### Create the project where openldap will live if it does not already exist" && echo ""
oc new-project ${NS}

# Switch to correct project
echo "" &&  echo "#### Switch to project ${NS}" && echo ""
oc project ${NS}

# Login to Docker
podman login docker.io -u $DOCKERUSERNAME -p $DOCKERPASSWORD

# Create Dockerfile for openldap container image
echo "" &&  echo "#### Create Dockerfile for openldap container image" && echo ""
cat << EOF > new_Dockerfile_OpenLDAP
#Pull the latest base image from Dockerhub
FROM docker.io/osixia/openldap:latest

# Set the environment variables
ENV LDAP_ORGANISATION="Your Company Name" \
LDAP_DOMAIN="your.company.com" \
LDAP_BASE_DN="dc=your,dc=company,dc=com"

COPY bootstrap.ldif /container/service/slapd/assets/config/bootstrap/ldif/50-bootstrap.ldif
EOF

# Build the openldap image
echo "" &&  echo "#### Build the openldap image" && echo ""
podman build -t ${OPENLDAPIMAGE} -f new_Dockerfile_OpenLDAP

# Check if we can login to the OpenShift cluster registry
echo "" &&  echo "#### Check if we can login to the OpenShift cluster registry" && echo ""
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

# Push openldap image to OpenShift cluster registry
echo "" &&  echo "#### Push ${OPENLDAPIMAGE} image to OpenShift cluster registry" && echo ""
while [ true ]
do
    oc login -u kubeadmin -p $KUBEADMINPASSWORD
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