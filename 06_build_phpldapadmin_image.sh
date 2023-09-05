#!/bin/bash

echo ""
echo "================================================================================"
echo "=== In 06_build_phpldapadmin_image.sh =========================================="
echo "================================================================================"
echo ""

# Login to Docker
podman login docker.io -u $DOCKERUSERNAME -p $DOCKERPASSWORD

# Create phpldapadmin Dockerfile
echo "" &&  echo "#### Create phpldapadmin Dockerfile" && echo ""
cat << EOF > new_Dockerfile_phpldapadmin
#Pull the latest base image from Dockerhub
FROM docker.io/osixia/phpldapadmin:latest

# Set the environment variables
ENV PHPLDAPADMIN_HTTPS="false"
 
EXPOSE 8090
EOF

# Build the phpldapadmin image
echo "" &&  echo "#### Build the phpldapadmin image" && echo ""
podman build -t ${PHPLDAPADMINIMAGE} -f new_Dockerfile_phpldapadmin

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
echo "" &&  echo "#### Push ${PHPLDAPADMINIMAGE} image to OpenShift cluster registry" && echo ""
while [ true ]
do
    podman login $(oc registry info --public) -u kubeadmin -p $(oc whoami -t) --tls-verify=false
    podman push ${PHPLDAPADMINIMAGE} --tls-verify=false
    if [ $? -eq 0 ]; then
        echo "#### Successfully pushed ${PHPLDAPADMINIMAGE} image to OpenShift cluster registry"
        break
    else
        echo "#### Unable to push ${PHPLDAPADMINIMAGE} image to OpenShift cluster registry"
        echo "#### Sleeping for 10 seconds"
        sleep 10
    fi
done