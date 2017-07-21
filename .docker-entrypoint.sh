#!/usr/bin/env bash

# start services
service rsyslog start
service ssh start
service postgresql start

# postgres setup for django
sudo -u postgres psql postgres -c "create role admin with password 'adminpass'"
sudo -u postgres psql postgres -f "/home/$USER_ID/.postgres_db_setup.sql"

sudo -u $USER_ID -i '/bin/bash'
