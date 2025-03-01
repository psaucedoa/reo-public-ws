# syntax=docker/dockerfile:1.4

# Base image
FROM ubuntu:22.04 AS base

# Metadata
LABEL maintainer="Arturo Saucedo <psaucedoa@gmail.com>"
LABEL description="ROS2 development environment for CPU only computers"
LABEL version="1.0"

# Build arguments
ARG ROS_DISTRO=humble
ARG OPENCV_VERSION=4.7.0
ARG CERES_SOLVER_VERSION=2.1.0
ARG USERNAME=ros
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    TZ=UTC \
    PYTHONUNBUFFERED=1 \
    ROS_DISTRO=${ROS_DISTRO} \
    ROS_ROOT=/opt/ros/${ROS_DISTRO} \
    AMENT_PREFIX_PATH=/opt/ros/${ROS_DISTRO} \
    COLCON_PREFIX_PATH=/opt/ros/${ROS_DISTRO} \
    LD_LIBRARY_PATH=/opt/ros/${ROS_DISTRO}/lib:/usr/local/cuda/lib64 \
    PATH=/opt/ros/${ROS_DISTRO}/bin:/usr/src/tensorrt/bin:/usr/local/cuda/bin:$PATH \
    PYTHONPATH=/opt/ros/${ROS_DISTRO}/lib/python3.10/site-packages \
    ROS_PYTHON_VERSION=3 \
    ROS_VERSION=2 \
    RMW_IMPLEMENTATION=rmw_cyclonedds_cpp \
    NVIDIA_VISIBLE_DEVICES=all \
    NVIDIA_DRIVER_CAPABILITIES=compute,utility,graphics



# Install basic utilities and dependencies
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    apt-get update && apt-get install -y --no-install-recommends \
        locales \
        tzdata \
        curl \
        gnupg2 \
        lsb-release \
        sudo \
        software-properties-common \
        wget \
        git \
        git-lfs \
    && locale-gen en_US.UTF-8 \
    && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 \
    && ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install ROS2
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null \
    && apt-get update && apt-get install -y --no-install-recommends \
        ros-${ROS_DISTRO}-ros-base \
        python3-argcomplete \
        ros-${ROS_DISTRO}-rmw-cyclonedds-cpp \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Development stage
FROM base AS dev

# Install development tools and dependencies
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    apt-get update && apt-get install -y --no-install-recommends \
        bash-completion \
        build-essential \
        cmake \
        gdb \
        openssh-client \
        python3-pip \
        vim \
        doxygen \
        graphviz \
        python3-sphinx \
        python3-breathe \
        ros-dev-tools \
        ros-${ROS_DISTRO}-ament-* \
        python3-rosdep \
        libgoogle-glog-dev \
        libsuitesparse-dev \
        libatlas-base-dev \
        libxine2-dev \
        libtiff5-dev \
        libpostproc-dev \
        libopencv-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Initialize rosdep
RUN rosdep init && rosdep update

# Install Python packages
# COPY requirements.txt /tmp/requirements.txt
# RUN --mount=type=cache,target=/root/.cache/pip \
#     pip3 install --no-cache-dir -r /tmp/requirements.txt && rm /tmp/requirements.txt 
    
# Add MQTT binaries and libraries
RUN --mount=type=cache,target=/var/cache/apt \
apt-add-repository ppa:mosquitto-dev/mosquitto-ppa \
&& apt-get update && apt-get install -y \
        mosquitto \
        mosquitto-clients
   
        
# Add in some ros2 deps (can-msgs?)
RUN apt-get install ros-humble-can-msgs

# Set up non-root user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Set up autocompletion and source ROS environment for user
RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> /home/$USERNAME/.bashrc \
    && echo "source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash" >> /home/$USERNAME/.bashrc

# Set up workspace
ARG WORKSPACE=/workspace
RUN mkdir -p ${WORKSPACE} && chown ${USERNAME}:${USERNAME} ${WORKSPACE}
RUN echo "if [ -f ${WORKSPACE}/install/setup.bash ]; then source ${WORKSPACE}/install/setup.bash; fi" >> /home/ros/.bashrc
WORKDIR ${WORKSPACE}
ENV REO_WS=/workspaces/reo-ws

# Switch to non-root user
USER $USERNAME

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD ros2 topic list > /dev/null 2>&1 || exit 1

# Set the default command to bash
CMD ["bash"]