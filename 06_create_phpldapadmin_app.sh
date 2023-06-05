#!/bin/bash
# Create the phpldapadmin app
oc new-app --name phpldapadmin --as-deployment-config -e PHPLDAPADMIN_LDAP_HOSTS=openldap ${PHPLDAPADMINIMAGESTREAM}
oc patch dc/phpldapadmin -p '{"spec":{"strategy":{"type":"Recreate"},"template":{"spec":{"serviceAccountName":"${SERVICEACCOUNTNAME}"}}}}'
oc expose service/phpldapadmin
