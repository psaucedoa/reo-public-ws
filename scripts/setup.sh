#!/bin/bash
set -e

vcs import < repos/src.repos src/ --recursive
vcs import < repos/resources.repos resources --recursive

sudo apt-get update
rosdep update
rosdep install --from-paths src --ignore-src -y
