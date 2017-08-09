#!/usr/bin/env bash

# start services
service rsyslog start
service ssh start

# run bash in user account
sudo -u $USER_ID -i '/bin/bash'
