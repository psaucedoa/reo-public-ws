#!/bin/bash
set -e

# Set the default build type
source /opt/ros/humble/setup.bash
BUILD_TYPE=RelWithDebInfo #Debug, Release, RelWithDebInfo, MinSizeRel
colcon build \
        --continue-on-error \
        --parallel-workers $(nproc) \
        --merge-install \
        --symlink-install \
        --event-handlers console_cohesion+ \
        --base-paths src \
        --cmake-args "-DCMAKE_BUILD_TYPE=$BUILD_TYPE" "-DCMAKE_EXPORT_COMPILE_COMMANDS=On" "-DBUILD_TESTING=OFF"\
        "-DCMAKE_CXX_FLAGS="-Wl,--allow-shlib-undefined""\
        -Wall -Wextra -Wpedantic -Wshadow \
        --packages-skip isaac_ros_h264_decoder isaac_ros_h264_encoder