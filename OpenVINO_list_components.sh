#!/bin/bash

wget -c http://registrationcenter-download.intel.com/akdlm/irc_nas/16345/l_openvino_toolkit_p_2020.1.023.tgz
tar xf l_openvino_toolkit_p_2020.1.023.tgz
cd l_openvino_toolkit_p_2020.1.023

./install.sh --list_components

cd ..
rm l_openvino_toolkit_p_2020.1.023.tgz
rm -r l_openvino_toolkit_p_2020.1.023