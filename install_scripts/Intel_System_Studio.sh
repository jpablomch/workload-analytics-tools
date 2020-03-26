#!/bin/bash

# TODO Add args for dirs and other config
INSTALL_PREFIX=/usr/local

wget -c https://registrationcenter-download.intel.com/akdlm/irc_nas/16255/intel-sw-tools-installer.tar.gz
tar xf intel-sw-tools-installer.tar.gz
cd intel-sw-tools-installer

echo "ACCEPT_EULA=accept" > silent.cfg
echo "CONTINUE_WITH_OPTIONAL_ERROR=yes" >> silent.cfg
echo "PSET_INSTALL_DIR=${INSTALL_PREFIX}/intel" >> silent.cfg
echo "CONTINUE_WITH_INSTALLDIR_OVERWRITE=yes" >> silent.cfg
#echo "COMPONENTS=eclipse_based_ide;intel_energy_profiler;intel_advisor;intel_cpp_compiler;intel_data_analytics_acceleration_library;intel_inspector;intel_math_kernel_library;intel_integrated_performance_primitives;intel_integrated_performance_primitives_cryptography_libraries;intel_system_debugger;intel_threading_building_blocks;intel_vtune_amplifier;linux_iot_application_development_using_containerized_toolchains;intel_sdk_for_opencl_for_visual_studio;intel_code_builder_for_opencl_api;intel_debug_extensions_for_windbg;intel_iot_connect_upm_mraa_cloud_connectors;intel_sdk_for_opencl_for_iss_eclipse_ide;gnu_project_debugger_gdb;" >> silent.cfg
echo "COMPONENTS=DEFAULTS" >> silent.cfg
echo "PSET_MODE=install" >> silent.cfg
echo "ACTIVATION_TYPE=no_license" >> silent.cfg
echo "INTEL_SW_IMPROVEMENT_PROGRAM_CONSENT=no" >> silent.cfg
# TODO: Read from args
echo "SELECTION_CONFIG_FILES_PATH=/home/jpm/Developer/workload-analytics-tools/install_scripts/Intel_System_Studio_Config_Files/intel-sw-tools-config-custom.json" >> silent.cfg

# Silent install
./install.sh --silent silent.cfg || { echo "Installing System Studio failed!"; exit 1;}
# GUI install # TODO add arg
#./install.sh || { echo "Installing System Studio failed!"; exit 1;}

# Clean up
cd ..
rm -r intel-sw-tools-installer.tar.gz
rm -r intel-sw-tools-installer

echo "TODO: Instruct PATH additions"


