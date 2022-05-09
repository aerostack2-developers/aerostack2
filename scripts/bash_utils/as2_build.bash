#!/bin/bash


usage() {
    echo "usage: $0 $CMD  [-h] [-d] [--ros2-only] [<pkg>]

AS2 build

positional arguments:
  pkg          build up to PKG

optional arguments:
  -h, --help   show this help message and exit
  -d, --debug  build in debug mode
  --ros2-only  use only the ros2 packages" 1>&2; exit 1;
}


# check if $ROS_VERSION is set

if [ -z "$ROS_DISTRO" ]; then
    echo "ROS_DISTRO is not set"
    exit 1
fi

BUILD_TYPE="Release"

echo $SHELL
colcon_build() {
    pkg=$@
    if [[ -z $pkg ]]; then
        source /opt/ros/$ROS_DISTRO/setup$TERM_EXTENSION && cd ${AEROSTACK2_WORKSPACE} && colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=$BUILD_TYPE
    else
        source /opt/ros/$ROS_DISTRO/setup$TERM_EXTENSION; source ${AEROSTACK2_WORKSPACE}/install/setup$TERM_EXTENSION && cd ${AEROSTACK2_WORKSPACE} && colcon build --packages-up-to ${pkg} --allow-overriding ${pkg} --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=$BUILD_TYPE
    fi
}

for opt in "${OPTS_ARGS[@]}"; do
  echo $opt
    # filter spaces and ignore empty strings
    [ -z "$opt" ] && continue
    # check if the option ends with spaces and remove them
    opt="${opt%\ }"
    case $opt in
    -h | --help )
        usage
        exit 1
        ;;
    -d | --debug )
        BUILD_TYPE="Debug"
        ;;
    -* | --* )
        echo "invalid option: $opt"
        usage
        exit 1
        ;;
    esac
done

# positional args 
colcon_build ${POS_ARGS[@]}
