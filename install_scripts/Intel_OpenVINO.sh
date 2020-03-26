#!/bin/bash

# TODO Add args for dirs and other config
INSTALL_PREFIX=/usr/local

wget -c http://registrationcenter-download.intel.com/akdlm/irc_nas/16345/l_openvino_toolkit_p_2020.1.023.tgz
tar xf l_openvino_toolkit_p_2020.1.023.tgz
cd l_openvino_toolkit_p_2020.1.023

# Skipping intel-openvino-opencv-lib-ubuntu-bionic__x86_64, version: 2020.1
#
echo "COMPONENTS=intel-openvino-ie-sdk-ubuntu-bionic__x86_64;
intel-openvino-ie-rt-cpu-ubuntu-bionic__x86_64;
intel-openvino-ie-rt-gpu-ubuntu-bionic__x86_64;
intel-openvino-ie-rt-vpu-ubuntu-bionic__x86_64;
intel-openvino-ie-rt-gna-ubuntu-bionic__x86_64;
intel-openvino-ie-rt-hddl-ubuntu-bionic__x86_64;
intel-openvino-model-optimizer__x86_64;
intel-openvino-dl-workbench__x86_64;
intel-openvino-omz-dev__x86_64;
intel-openvino-mediasdk__x86_64" >> silent.cfg
echo "ACCEPT_EULA=accept" > silent.cfg
echo "CONTINUE_WITH_OPTIONAL_ERROR=yes" >> silent.cfg
echo "PSET_INSTALL_DIR=${INSTALL_PREFIX}/intel" >> silent.cfg
echo "CONTINUE_WITH_INSTALLDIR_OVERWRITE=yes" >> silent.cfg
echo "PSET_MODE=install" >> silent.cfg
echo "INTEL_SW_IMPROVEMENT_PROGRAM_CONSENT=no" >> silent.cfg
echo "SIGNING_ENABLED=no" >> silent.cfg
./install.sh --ignore-signature --cli-mode --silent silent.cfg || { echo 'Installing OpenVINO failed!' ; exit 1; }

# Clean up
cd ..
rm l_openvino_toolkit*.tgz
rm -r l_openvino_toolkit_p_*

echo "TODO: Instruct FIX PATH additions"

echo "Add the following to your shell config:"
echo
echo "export LD_LIBRARY_PATH=$INSTALL_PREFIX/lib:\$LD_LIBRARY_PATH"
echo "export PATH=$INSTALL_PREFIX/bin:\$PATH"
echo "export PKG_CONFIG_PATH=$INSTALL_PREFIX/lib/pkgconfig:\$PKG_CONFIG_PATH"
INTEL_OPENVINO_DIR=$INSTALL_PREFIX/intel/openvino
echo "export INTEL_OPENVINO_DIR=$INTEL_OPENVINO_DIR"
echo "export INTEL_CVSDK_DIR=$INTEL_OPENVINO_DIR"
echo "export InferenceEngine_DIR=$INTEL_OPENVINO_DIR/deployment_tools/inference_engine/share"
echo "export IE_PLUGINS_PATH=$INTEL_OPENVINO_DIR/deployment_tools/inference_engine/lib/intel64"
echo "export HDDL_INSTALL_DIR=$INTEL_OPENVINO_DIR/deployment_tools/inference_engine/external/hddl"
HDDL_INSTALL_DIR=$INTEL_OPENVINO_DIR/deployment_tools/inference_engine/external/hddl
IE_PLUGINS_PATH=$INTEL_OPENVINO_DIR/deployment_tools/inference_engine/lib/intel64
echo "export LD_LIBRARY_PATH=$HDDL_INSTALL_DIR/lib:$INTEL_OPENVINO_DIR/deployment_tools/inference_engine/external/gna/lib:$INTEL_OPENVINO_DIR/deployment_tools/inference_engine/external/mkltiny_lnx/lib:$INTEL_OPENVINO_DIR/deployment_tools/inference_engine/external/tbb/lib:$IE_PLUGINS_PATH:\$LD_LIBRARY_PATH
echo "export PYTHONPATH=$INTEL_OPENVINO_DIR/python/python$PYTHON_VERSION:\$PYTHONPATH"
