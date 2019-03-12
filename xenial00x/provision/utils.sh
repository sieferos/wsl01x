#!/usr/bin/env bash

# /*
# * utils.sh
# * sieferos: 26/10/2017
# */

source "/var/tmp/vagrant/provision/include.sh"

LOG_FILE="${LOG_DIR}/utils.log"

printf "\n[ %s ] %s@%s (#%02d) ( %s )\n" "$(date)" ${USER} "${BOX}" ${ii} "$0" | tee -a "${LOG_FILE}" ; ii=$((++ii))

### TREE
printf "\n[ %s ] %s@%s (#%02d) ( %s )\n" "$(date)" ${USER} "${BOX}" ${ii} "TREE" | tee -a "${LOG_FILE}" ; ii=$((++ii))
apt-get install -y tree 2>&1 | tee -a "${LOG_FILE}"

### UNZIP
printf "\n[ %s ] %s@%s (#%02d) ( %s )\n" "$(date)" ${USER} "${BOX}" ${ii} "UNZIP" | tee -a "${LOG_FILE}" ; ii=$((++ii))
apt-get install -y unzip 2>&1 | tee -a "${LOG_FILE}"

### MAN PAGES
printf "\n[ %s ] %s@%s (#%02d) ( %s )\n" "$(date)" ${USER} "${BOX}" ${ii} "MAN PAGES" | tee -a "${LOG_FILE}" ; ii=$((++ii))
apt-get install -y man 2>&1 | tee -a "${LOG_FILE}"

### NTPDATE
printf "\n[ %s ] %s@%s (#%02d) ( %s )\n" "$(date)" ${USER} "${BOX}" ${ii} "NTPDATE" | tee -a "${LOG_FILE}" ; ii=$((++ii))
apt-get install -y ntpdate 2>&1 | tee -a "${LOG_FILE}"
service ntp stop 2>&1 | tee -a "${LOG_FILE}"
ntpdate pool.ntp.org 2>&1 | tee -a "${LOG_FILE}"
service ntp start 2>&1 | tee -a "${LOG_FILE}"

### SCREEN, TMUX
printf "\n[ %s ] %s@%s (#%02d) ( %s )\n" "$(date)" ${USER} "${BOX}" ${ii} "SCREEN" | tee -a "${LOG_FILE}" ; ii=$((++ii))
apt-get install -y screen tmux 2>&1 | tee -a "${LOG_FILE}"

### NETUTILS
printf "\n[ %s ] %s@%s (#%02d) ( %s )\n" "$(date)" ${USER} "${BOX}" ${ii} "NETUTILS" | tee -a "${LOG_FILE}" ; ii=$((++ii))
apt-get install -y dnsutils 2>&1 | tee -a "${LOG_FILE}"
apt-get install -y traceroute 2>&1 | tee -a "${LOG_FILE}"
apt-get install -y tcpdump 2>&1 | tee -a "${LOG_FILE}"
