#!/bin/bash

# Update packages
sudo apt update

# Install stress for later
sudo apt install -y stress

# Repeat the 10 minutes cycle 10 times (= 100 minutes)
for i in $(seq 10)
do
    sudo stress --cpu 12 --timeout 120s # Stress for 2 minutes
    sleep 480 # Sleep 8 minutes
done
