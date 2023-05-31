#!/bin/bash

# Build Container Image
cat << EOF > new_Dockerfile_OpenLDAP
#Pull the latest base image from Dockerhub
FROM osixia/openldap

# Set the environment variables
ENV LDAP_ORGANISATION="Your Company Name" \
LDAP_DOMAIN="your.company.com" \
LDAP_BASE_DN="dc=your,dc=company,dc=com"

COPY bootstrap.ldif /container/service/slapd/assets/config/bootstrap/ldif/50-bootstrap.ldif
EOF

# Build the openldap image
podman build -t docker.io/${DOCKERUSERNAME}/openldap_bootstrap:1.0 -f new_Dockerfile_OpenLDAP

# Login to docker
podman login -u ${DOCKERUSERNAME} -p ${DOCKERPASSWORD}

# Push to docker hub
podman push docker.io/${DOCKERUSERNAME}/openldap_bootstrap:1.0
