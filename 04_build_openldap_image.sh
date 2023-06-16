#!/bin/bash

echo ""
echo "================================================================================"
echo "=== In 04_build_openldap_image.sh =============================================="
echo "================================================================================"
echo ""

# Build Container Image
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
podman build -t ${OPENLDAPIMAGE} -f new_Dockerfile_OpenLDAP

# Login to the OpenShift cluster registry
podman login $(oc registry info --public) -u kubeadmin -p $(oc whoami -t) --tls-verify=false

# Push image to OpenShift cluster registry
podman push ${OPENLDAPIMAGE} --tls-verify=false