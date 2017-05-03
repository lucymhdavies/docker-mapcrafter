#!/bin/bash

source /data/creds

set -ex

mkdir -p /data/worlds/Davinhart\ Kingdom || true
cd /data/worlds/Davinhart\ Kingdom

wget --cut-dirs=1 -c -N -nH -m ftp://$MC_USER:$MC_PASS@$MC_IP//world

