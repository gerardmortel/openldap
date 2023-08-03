#!/bin/bash

. ./02_setup_env.sh
oc project ${NS}

echo ""
echo "================================================================================"
echo "=== In 08_delete_all.sh ========================================================"
echo "================================================================================"
echo ""

echo "" && echo "Delete ALL opendlap and phpldapadmin resources" && echo ""

# Delete the openldap resources
echo "" &&  echo "#### Delete the openldap resources" && echo ""
oc set volume dc/openldap --remove=true --name=ldap-data
oc set volume dc/openldap --remove=true --name=ldap-config
oc delete dc/openldap
oc delete svc/openldap
oc delete svc/ingress-openldap

# Delete the phpldapadmin resources
echo "" &&  echo "#### Delete the phpldapadmin resources" && echo ""
oc delete dc/phpldapadmin
oc delete svc/phpldapadmin
oc delete route/phpldapadmin

# Delete all image streams
echo "" &&  echo "#### Delete all image streams" && echo ""
oc get is | awk '{print $1}' | grep -v NAME | xargs oc delete is
# oc delete is openldap-bootstrap
# oc delete is phpldapadmin-new

# Delete the PVCs
echo "" &&  echo "#### Delete the PVCs" && echo ""
oc delete pvc ldap-config ldap-data

# Delete images from podman
echo "" &&  echo "#### Delete images from podman" && echo ""
podman images | awk '{print $3}' | grep -v IMAGE | xargs podman rmi
