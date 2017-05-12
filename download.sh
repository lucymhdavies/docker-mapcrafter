#!/bin/bash

source /data/creds

set -ex

mkdir -p /data/worlds/Davinhart\ Kingdom || true
cd /data/worlds/Davinhart\ Kingdom

# Temporary hack to ensure that the downloaded world is up-to-date
rm -rf *

#wget --cut-dirs=1 -c -N -nH -m ftp://$MC_USER:$MC_PASS@$MC_IP//world
wget --cut-dirs=1 -c -nH -r -l inf --no-remove-listing ftp://$MC_USER:$MC_PASS@$MC_IP//world

