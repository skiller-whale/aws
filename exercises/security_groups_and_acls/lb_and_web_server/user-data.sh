#!/bin/bash

sudo touch /${HOSTNAME}

sudo python3 -m http.server 80
