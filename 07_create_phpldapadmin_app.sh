#!/bin/bash

# Create the phpldapadmin app
oc new-app --name phpldapadmin --as-deployment-config -e PHPLDAPADMIN_LDAP_HOSTS=openldap ${PHPLDAPADMINIMAGESTREAM}

# Patch the app with a Recreate strategy to stop the constant pod killing
#oc patch dc/phpldapadmin -p '{"spec":{"strategy":{"type":"Recreate"},"template":{"spec":{"serviceAccountName":"${SERVICEACCOUNTNAME}"}}}}'
cat << EOF > new_dc_phpldapadmin_patch.yaml
spec:
  strategy:
    type: Recreate
  template:
    spec:
      serviceAccountName: ${SERVICEACCOUNTNAME}
EOF
oc patch dc/phpldapadmin --patch-file='new_dc_phpldapadmin_patch.yaml' --type='merge'

oc expose service/phpldapadmin

echo ""
echo "================================================================================"
echo ""