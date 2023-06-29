#!/bin/bash

. ./02_setup_env.sh
oc project ${NS}

echo ""
echo "================================================================================"
echo "=== In 08_delete_all.sh ========================================================"
echo "================================================================================"
echo ""

echo "Delete ALL opendlap and phpldapadmin resources"

# Delete the openldap resources
oc set volume dc/openldap --remove=true --name=ldap-data
oc set volume dc/openldap --remove=true --name=ldap-config
oc delete dc/openldap
oc delete svc/openldap
oc delete svc/ingress-openldap

# Delete the phpldapadmin resources
oc delete dc/phpldapadmin
oc delete svc/phpldapadmin
oc delete route/phpldapadmin

# Delete all image streams
oc get is | awk '{print $1}' | grep -v NAME | xargs oc delete is
# oc delete is openldap-bootstrap
# oc delete is phpldapadmin-new

# Delete the PVCs
oc delete pvc ldap-config ldap-data

# Delete images from podman
podman images | awk '{print $3}' | grep -v IMAGE | xargs podman rmi
