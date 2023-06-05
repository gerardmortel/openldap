#!/bin/bash

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
