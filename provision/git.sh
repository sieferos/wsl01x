#!/usr/bin/env bash

# /*
# * git.sh
# * sieferos: 24/10/2017
# */

source "/var/tmp/vagrant/provision/include.sh"

LOG_FILE="${LOG_DIR}/git.log"

printf "\n[ %s ] %s@%s (#%02d) ( %s )\n" "$(date)" ${USER} "${BOX}" ${ii} "$0" | tee -a "${LOG_FILE}" ; ii=$((++ii))

###
### [ GIT && BASH-GIT-PROMPT ] ( https://github.com/magicmonty/bash-git-prompt )
###
printf "\n[ %s ] %s@%s (#%02d) ( %s )\n" "$(date)" ${USER} "${BOX}" ${ii} "BASH-GIT-PROMPT" | tee -a "${LOG_FILE}" ; ii=$((++ii))
cd ~ && rm -fr ~/.bash-git-prompt && git clone https://github.com/magicmonty/bash-git-prompt.git .bash-git-prompt --depth=1 2>&1 | tee -a "${LOG_FILE}"
! ( grep -q "bash-git-prompt" ~/.bashrc ) && cat <<EOT | tee -a ~/.bashrc

GIT_PROMPT_ONLY_IN_REPO=1
source ~/.bash-git-prompt/gitprompt.sh
EOT

###
### GIT CONFIG
###
printf "\n[ %s ] %s@%s (#%02d) ( %s )\n" "$(date)" ${USER} "${BOX}" ${ii} "GIT CONFIG" | tee -a "${LOG_FILE}" ; ii=$((++ii))
git config --global user.email "oscar.sierra@logtrust.com" 2>&1 | tee -a "${LOG_FILE}"
git config --global user.name "oscar.sierra" 2>&1 | tee -a "${LOG_FILE}"
git config --global push.default simple 2>&1 | tee -a "${LOG_FILE}"

exit 0
