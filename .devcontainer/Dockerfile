# syntax=docker/dockerfile:1.4

# Base image
FROM ubuntu:22.04 AS base

# Metadata
LABEL maintainer="Isaac Blankenau <isaac.j.blankenau@usace.army.mil>"
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
        ros-${ROS_DISTRO}-laser-geometry \
        ros-${ROS_DISTRO}-map-msgs \
        ros-${ROS_DISTRO}-generate-parameter-library \
        ros-${ROS_DISTRO}-rviz-common \
        ros-${ROS_DISTRO}-rviz-default-plugins \
        ros-${ROS_DISTRO}-rviz-ogre-vendor \
        ros-${ROS_DISTRO}-rviz-rendering \
        ros-${ROS_DISTRO}-backward-ros \
        ros-${ROS_DISTRO}-realtime-tools \
        ros-${ROS_DISTRO}-xacro \
        ros-${ROS_DISTRO}-rviz2 \
        ros-${ROS_DISTRO}-can-msgs \
        ros-${ROS_DISTRO}-foxglove-msgs \
        ros-${ROS_DISTRO}-python-qt-binding \
        ros-${ROS_DISTRO}-rqt-gui \
        ros-${ROS_DISTRO}-rqt-gui-py \
        ros-${ROS_DISTRO}-qt-gui \
        ros-${ROS_DISTRO}-rsl \
        ros-${ROS_DISTRO}-tl-expected \
        ros-${ROS_DISTRO}-object-recognition-msgs \
        ros-${ROS_DISTRO}-slam-toolbox \ 
        ros-${ROS_DISTRO}-joint-state-publisher \
        ros-${ROS_DISTRO}-bondcpp \
        ros-${ROS_DISTRO}-diagnostic-updater \
        ros-${ROS_DISTRO}-test-msgs \
        ros-${ROS_DISTRO}-bond \
        ros-${ROS_DISTRO}-ackermann-msgs \
        ros-${ROS_DISTRO}-geometric-shapes \
        ros-${ROS_DISTRO}-interactive-markers \
        ros-${ROS_DISTRO}-joint-state-publisher-gui \
        ros-${ROS_DISTRO}-eigen-stl-containers \
        ros-${ROS_DISTRO}-octomap-msgs \
        ros-${ROS_DISTRO}-octomap \
        ros-${ROS_DISTRO}-random-numbers \
        ros-${ROS_DISTRO}-ruckig \
        ros-${ROS_DISTRO}-gazebo-ros-pkgs \
        ros-${ROS_DISTRO}-behaviortree-cpp-v3 \
        # ros-${ROS_DISTRO}-moveit-resources-fanuc-description \
        # ros-${ROS_DISTRO}-warehouse-ros \
        ros-${ROS_DISTRO}-kinematics-interface-kdl \
        ros-${ROS_DISTRO}-kinematics-interface \
        ros-${ROS_DISTRO}-filters \
        # ros-${ROS_DISTRO}-moveit-msgs \
        ros-${ROS_DISTRO}-control-msgs \
        ros-${ROS_DISTRO}-srdfdom \
        ros-${ROS_DISTRO}-ros-testing \
        # ros-${ROS_DISTRO}-moveit-resources-panda-moveit-config \
        ros-${ROS_DISTRO}-angles \
        # ros-${ROS_DISTRO}-moveit-resources-fanuc-moveit-config \ 
        ros-${ROS_DISTRO}-launch-param-builder \
        ros-${ROS_DISTRO}-joy \
        ros-${ROS_DISTRO}-control-toolbox \
        ros-${ROS_DISTRO}-vision-msgs \
        ros-${ROS_DISTRO}-ompl \
        # ros-${ROS_DISTRO}-moveit-resources-pr2-description \
        # ros-${ROS_DISTRO}-moveit-resources-panda-description && \
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

FROM dev AS reqs

RUN python3 -m pip install \
    sphinx_rtd_theme \
    sphinx-multiversion \
    sphinx-copybutton\
    sphinx-tabs\
    ruamel.yaml\
    autopep8\
    flake8-builtins\
    flake8-comprehensions\
    flake8-docstrings\
    flake8-import-order\
    onnx\
    scikit-learn\
    ninja\
    numpy-quaternion\
    trimesh\
    setuptools_scm>=6.2\
    yourdfpy>=0.0.53\
    warp-lang>=0.9.0\
    tqdm\
    importlib_resources\
    pytest-repeat\
    pytest-rerunfailures\
    flake8-class-newline\
    pandas\
    rosbags\
    uvloop==0.17.0\
    black==21.12b0\
    setuptools==65.7.0\
    pyyaml\
    paho-mqtt==1.6.1\
    tensorflow\
    flake8-blind-except\
    flake8-quotes

FROM reqs AS final

# Add MQTT binaries and libraries
RUN --mount=type=cache,target=/var/cache/apt \
apt-add-repository ppa:mosquitto-dev/mosquitto-ppa \
&& apt-get update && apt-get install -y \
        mosquitto \
        mosquitto-clients
        
# Set up non-root user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Set up autocompletion and source ROS environment for user
RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> /home/$USERNAME/.bashrc \
    && echo "source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash" >> /home/$USERNAME/.bashrc

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y
    # rm -rf /var/lib/apt/lists/

# Set up workspace
ARG WORKSPACE=/workspace
RUN mkdir -p ${WORKSPACE} && chown ${USERNAME}:${USERNAME} ${WORKSPACE}
RUN echo "if [ -f ${WORKSPACE}/install/setup.bash ]; then source ${WORKSPACE}/install/setup.bash; fi" >> /home/ros/.bashrc
WORKDIR ${WORKSPACE}
ENV REO_WS=/workspaces/reo-public-ws


# Switch to non-root user
USER $USERNAME

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD ros2 topic list > /dev/null 2>&1 || exit 1

# Set the default command to bash
CMD ["bash"]