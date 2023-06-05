#!/bin/bash

# For first time run, run steps 2 thru 7
. ./02_setup_env.sh
./03_build_openldap_image.sh
./04_push_openldap_image.sh
./05_create_openldap_app.sh
./06_build_phpldapadmin_image.sh
./07_create_phpldapadmin_app.sh


# Subsequent runs do not need to rebuild images.  Comment out steps 3 and 5, run all the rest
# . ./02_setup_env.sh
# #./03_build_openldap_image.sh
# ./04_push_openldap_image.sh
# #./05_create_openldap_app.sh
# ./06_build_phpldapadmin_image.sh
# ./07_create_phpldapadmin_app.sh