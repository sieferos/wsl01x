#!/usr/bin/env bash

# /*
# * sieferos.sh
# * sieferos: 12/03/2019
# */

source "/var/tmp/vagrant/provision/include.sh"

LOG_FILE="${LOG_DIR}/sieferos.log"

printf "\n[ %s ] %s@%s (#%02d) ( %s )\n" "$(date)" ${USER} "${BOX}" ${ii} "$0" | tee -a "${LOG_FILE}" ; ii=$((++ii))

### RENAME ACCOUNT
printf "\n[ %s ] %s@%s (#%02d) ( %s )\n" "$(date)" ${USER} "${BOX}" ${ii} "RENAME VAGRANT ACCOUNT" | tee -a "${LOG_FILE}" ; ii=$((++ii))
pgrep -u vagrant | sudo xargs kill -9 2>&1
usermod -l sieferos -m -d /home/sieferos vagrant 2>&1 | tee -a "${LOG_FILE}"
groupmod -n sieferos vagrant 2>&1 | tee -a "${LOG_FILE}"
### ENABLE SUDO
### sed -i.bak 's/vagrant   /sieferos/' /etc/sudoers 2>&1 | tee -a "${LOG_FILE}"
echo 'sieferos ALL=(ALL)       NOPASSWD: ALL' | tee -a /etc/sudoers 2>&1 | tee -a "${LOG_FILE}"
