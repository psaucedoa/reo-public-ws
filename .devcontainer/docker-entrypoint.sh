#!/bin/bash

set -e

# Source the ROS setup bash
source /opt/ros/humble/setup.bash
source /workspaces/reo-ws/install/setup.sh
source /workspaces/reo-ws/install/setup.bash

# ros2 launch bringup rc_anything_launch.py
# ros2 launch teleop_twist_joy teleop-launch.py