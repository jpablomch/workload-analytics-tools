#!/bin/bash

add-apt-repository -y ppa:ubuntu-toolchain-r/test
apt-get update
apt-get install -y gcc-8 g++-8
