#!/bin/bash

# Todo: add this to a package installer
#---------------------------------------

# install not ros dependencies

cd ../../
mkdir thirdparty/
cd thirdparty
touch COLCON_IGNORE

sudo apt install openjdk-11-jdk

git clone --recursive https://github.com/eProsima/Fast-DDS-Gen.git -b v1.0.4 \
    && cd Fast-DDS-Gen \
    && ./gradlew assemble \
    && sudo ./gradlew install

source ~/.bashrc

cd ../

git clone https://github.com/eProsima/foonathan_memory_vendor.git \
    && cd foonathan_memory_vendor \
    && mkdir build && cd build \
    && cmake .. \
    && sudo cmake --build . --target install 

cd ../
cd ../

# CHECK IF THIS IS NECESSARY
#git clone --recursive https://github.com/eProsima/Fast-DDS.git -b v2.0.0 ~/FastDDS-2.0.0 \
#&& cd ~/FastDDS-2.0.0\
#&& mkdir build && cd build\
#&& cmake -DTHIRDPARTY=ON -DSECURITY=ON .. \
#&& make -j$(nproc --all) \
#&& sudo make install 

source ~/.bashrc

# Check FastRTPSGen version
fastrtpsgen_version_out=""
if [[ -z $FASTRTPSGEN_DIR ]]; then
  fastrtpsgen_version_out="$FASTRTPSGEN_DIR/$(fastrtpsgen -version)"
else
  fastrtpsgen_version_out=$(fastrtpsgen -version)
fi
if [[ -z $fastrtpsgen_version_out ]]; then
  echo "FastRTPSGen not found! Please build and install FastRTPSGen..."
  exit 1
else
  fastrtpsgen_version="${fastrtpsgen_version_out: -5:-2}"
  if ! [[ $fastrtpsgen_version =~ ^[0-9]+([.][0-9]+)?$ ]] ; then
    fastrtpsgen_version="1.0"
    [ ! -v $verbose ] && echo "FastRTPSGen version: ${fastrtpsgen_version}"
  else
    [ ! -v $verbose ] && echo "FastRTPSGen version: ${fastrtpsgen_version_out: -5}"
  fi
fi




