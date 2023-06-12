#!/bin/bash

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

echo ""
echo "================================================================================"
echo ""