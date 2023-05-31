#!/bin/bash

# For first time run, run steps 2 thru 6
. ./02_setup_env.sh
./03_build_openldap_image.sh
./04_create_openldap_app.sh
./05_build_phpldapadmin_image.sh
./06_create_phpldapadmin_app.sh

# Subsequent runs do not need to rebuild images.  Just run steps 2, 4 and 6.
# . ./02_setup_env.sh
# ./03_build_openldap_image.sh
# ./04_create_openldap_app.sh
# ./05_build_phpldapadmin_image.sh
# ./06_create_phpldapadmin_app.sh