#!/bin/bash

#############################################################################
##     ______  _                _  _______         _                 _     ##
##    (_____ \(_)              | |(_______)       | |               | |    ##
##     _____) )_  _   _  _____ | | _    _   _   _ | |__   _____   __| |    ##
##    |  ____/| |( \ / )| ___ || || |  | | | | | ||  _ \ | ___ | / _  |    ##
##    | |     | | ) X ( | ____|| || |__| | | |_| || |_) )| ____|( (_| |    ##
##    |_|     |_|(_/ \_)|_____) \_)\______)|____/ |____/ |_____) \____|    ##
##                                                                         ##
#############################################################################
###################### Credits ###################### ### Update PCI ID'S ###
## Lily (PixelQubed) for editing the scripts       ## ##                   ##
## RisingPrisum for providing the original scripts ## ##   update-pciids   ##
## Void for testing and helping out in general     ## ##                   ##
## .Chris. for testing and helping out in general  ## ## Run this command  ##
## WORMS for helping out with testing              ## ## if you dont have  ##
## BrainStone for general script cleanup           ## ## names in you're   ##
##################################################### ## lspci feedback    ##
## The VFIO community for using the scripts and    ## ## in your terminal  ##
## testing them for us!                            ## ##                   ##
##################################################### #######################

################################# Variables #################################

## Adds current time to var for use in echo for a cleaner log and script ##
DATE_FORMAT="%Y-%m-%d %H:%M:%S.%3N"

################################# Functions #################################

# Log message with timestamp
function log() {
  echo "$(date +"$DATE_FORMAT") : $*"
}

################################## Script ###################################

log "################################ Beginning of Started! ################################"

#############################
## Restart Display Manager ##
#############################
while read -r DISPMGR; do
  if [[ -d /run/systemd/system ]]; then
    ## Make sure the variable got collected ##
    log "Var has been collected from file: $DISPMGR"
    
    log "Starting $DISPMGR.service"
    systemctl start "$DISPMGR.service"
    log "Started $DISPMGR.service"
  fi
done </tmp/vfio-store-display-manager

log "################################ End of Started! ################################"
