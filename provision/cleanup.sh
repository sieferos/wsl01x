#!/usr/bin/env bash

# /*
# * cleanup.sh
# * sieferos: 25/10/2017
# */

source "/var/tmp/vagrant/provision/include.sh"

LOG_FILE="${LOG_DIR}/cleanup.log"

printf "\n[ %s ] %s@%s (#%02d) ( %s )\n" "$(date)" ${USER} "${BOX}" ${ii} "$0" | tee -a "${LOG_FILE}" ; ii=$((++ii))

### AUTOREMOVE & UPDATE
printf "\n[ %s ] %s@%s (#%02d) ( %s )\n" "$(date)" ${USER} "${BOX}" ${ii} "AUTOREMOVE & UPDATE" | tee -a "${LOG_FILE}" ; ii=$((++ii))
sudo apt-get -y autoremove 2>&1 | tee -a "${LOG_FILE}"
sudo apt-get -y update 2>&1 | tee -a "${LOG_FILE}"
