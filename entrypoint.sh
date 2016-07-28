#!/bin/bash

#Figure out how we can trigger an update for the credentials
#echo "Initialising database credentials and update configuration" && \
#/etc/init.d/postgresql start && \
#sudo -u postgres psql --command "CREATE USER ${DB_USER} WITH SUPERUSER PASSWORD '${DB_PASSWORD}';" && \
#sed -i.bak "s/db.password = /db.password = ${DB_PASSWORD}/g" $DSPACE_WORKSPACE/sources/local.properties


#cd $DSPACE_WORKSPACE/scripts
#sudo make init_statistics
#sudo make update_discovery
#sudo make update_oai


echo "Starting supervisord"
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf