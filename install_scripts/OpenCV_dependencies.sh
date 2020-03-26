#!/bin/bash

apt-get update
apt-get install -y build-essential
#apt-get install cmake  #Installed separatedly. TODO: add check
apt-get install -y git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
apt-get install -y python-dev python-numpy
#libtbb2 libtbb-dev   # Installed with OpenVINO. TODO: add check
apt-get install -y libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev libglew-dev