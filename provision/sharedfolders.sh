#!/usr/bin/env bash

# /*
# * sharedfolders.sh
# * sieferos: 24/10/2017
# */

source "/var/tmp/vagrant/provision/include.sh"

LOG_FILE="${LOG_DIR}/sharedfolders.log"

printf "\n[ %s ] %s@%s (#%02d) ( %s )\n" "$(date)" ${USER} "${BOX}" ${ii} "$(basename "$0")" | tee -a "${LOG_FILE}" ; ii=$((++ii))

### VBOXFS
printf "\n[ %s ] %s@%s (#%02d) ( %s )\n" "$(date)" ${USER} "${BOX}" ${ii} "VBOXFS" | tee -a "${LOG_FILE}" ; ii=$((++ii))
sudo usermod -a -G vboxsf vagrant 2>&1 | tee -a "${LOG_FILE}"
sudo VBoxControl sharedfolder list 2>&1 | tee -a "${LOG_FILE}"
