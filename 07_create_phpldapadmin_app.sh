#!/bin/bash

echo ""
echo "================================================================================"
echo "=== In 07_create_phpldapadmin_app.sh ==========================================="
echo "================================================================================"
echo ""

echo "#### Create the phpldapadmin app"
oc new-app --name phpldapadmin --as-deployment-config -e PHPLDAPADMIN_LDAP_HOSTS=openldap ${PHPLDAPADMINIMAGESTREAM}

echo "#### Patch the app with a Recreate strategy to stop the constant pod killing"
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

echo "#### Expose the phpldapadmin app"
oc expose service/phpldapadmin