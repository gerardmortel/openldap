#!/bin/bash

# Put the following into a Dockerifle
cat << EOF > new_Dockerfile_phpldapadmin
#Pull the latest base image from Dockerhub
FROM docker.io/osixia/phpldapadmin:latest

# Set the environment variables
ENV PHPLDAPADMIN_HTTPS="false"
 
EXPOSE 8090
EOF

# Build the phpldapadmin image
podman build -t ${PHPLDAPADMINIMAGE} -f new_Dockerfile_phpldapadmin

# Push to OpenShift cluster registry
podman push ${PHPLDAPADMINIMAGE}
