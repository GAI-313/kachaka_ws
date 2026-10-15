# syntax=docker/dockerfile:1.7

# Arguments
ARG ROS=humble
ARG ARCHTECTURE=amd64
ARG PLATFORM=headless


# Base docker image
FROM gai313/ros2:${ROS}.amd64 AS base_amd64


# ==============================
# Base image
# ==============================
FROM base_${ARCHTECTURE} AS base

# Replace workspace name
RUN sed -i 's/colcon_ws/kachaka_ws/g' /etc/skel/.bashrc

# Add user
ARG USERNAME
ARG GROUPNAME
ARG UID
ARG GID
ARG PASSWORD

RUN groupadd -g $GID $GROUPNAME &&\
    useradd -m -s /bin/bash -u $UID -g $GID -G sudo $USERNAME &&\
    echo $USERNAME:$PASSWORD | chpasswd

USER $USERNAME
WORKDIR /home/${USERNAME}/kachaka_ws



# ==============================
# Python Image
# ==============================
FROM base AS python

# Install python packages
USER ${USERNAME}
COPY ./src/erasers_kachaka/requirements.txt ./src/erasers_kachaka/
RUN pip install --no-cache-dir --user -r ./src/erasers_kachaka/requirements.txt ipython


# ==============================
# Install Dependencies Image
# ==============================
FROM base AS depends

# Install build tools
USER root
RUN apt-get update && \
    apt-get -y install --no-install-recommends \
        libprotobuf-dev \
        libgrpc++-dev \
        nlohmann-json3-dev \
        protobuf-compiler-grpc \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Resolve thirdparty dependencies
USER $USERNAME
ARG ROS
COPY ./src/erasers_kachaka/depends.repos ./depends.repos
RUN . /opt/ros/${ROS}/setup.bash &&\
    mkdir thirdparty &&\
    vcs import thirdparty < ./depends.repos

# gen protos
RUN mkdir thirdparty/kachaka-api/ros2/kachaka_grpc_ros2_bridge/gen-src &&\
    protoc -I /home/${USERNAME}/kachaka_ws/thirdparty/kachaka-api/protos \
              --grpc_out=/home/${USERNAME}/kachaka_ws/thirdparty/kachaka-api/ros2/kachaka_grpc_ros2_bridge/gen-src \
              --plugin=protoc-gen-grpc=/usr/bin/grpc_cpp_plugin \
              --cpp_out=/home/${USERNAME}/kachaka_ws/thirdparty/kachaka-api/ros2/kachaka_grpc_ros2_bridge/gen-src \
              /home/${USERNAME}/kachaka_ws/thirdparty/kachaka-api/protos/*.proto

# Install thirdparty dependencies packages
USER root
RUN . /opt/ros/${ROS}/setup.bash &&\
    apt-get update &&\
    rosdep update &&\
    rosdep install -y -i --from-path thirdparty &&\
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER $USERNAME
COPY src/erasers_kachaka/erasers_kachaka_navigation/package.xml      src/erasers_kachaka/erasers_kachaka_navigation/
COPY src/erasers_kachaka/erasers_kachaka_description/package.xml     src/erasers_kachaka/erasers_kachaka_description/
COPY src/erasers_kachaka/erasers_kachaka_bringup/package.xml         src/erasers_kachaka/erasers_kachaka_bringup/
COPY src/erasers_kachaka/erasers_kachaka_cartographer/package.xml    src/erasers_kachaka/erasers_kachaka_cartographer/
COPY src/erasers_kachaka/erasers_kachaka_vision/package.xml          src/erasers_kachaka/erasers_kachaka_vision/
COPY src/erasers_kachaka/erasers_kachaka_common/package.xml          src/erasers_kachaka/erasers_kachaka_common/
COPY src/erasers_kachaka/erasers_kachaka_teleop/package.xml          src/erasers_kachaka/erasers_kachaka_teleop/


# ==============================
# Desktop Image
# ==============================
FROM depends AS desktop
USER root
RUN . /opt/ros/${ROS}/setup.bash &&\
    apt-get update &&\
    rosdep update &&\
    rosdep install -y -i --from-path src \
        --skip-keys "emcl2 rclpy_util kachaka_grpc_ros2_bridge kachaka_description kachaka_interfaces kachaka_shelf_description" &&\
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# ==============================
# headless Image
# ==============================
FROM depends AS headless
USER root
RUN . /opt/ros/${ROS}/setup.bash &&\
    apt-get update &&\
    rosdep update &&\
    rosdep install -y -i --from-path src \
        --skip-keys "emcl2 rclpy_util kachaka_grpc_ros2_bridge kachaka_description kachaka_interfaces kachaka_shelf_description joint_state_publisher_gui rviz2 rviz_common rviz_default_plugins rviz_rendering" &&\
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# ==============================
# main Image
# ==============================
FROM ${PLATFORM} AS main

# Install python depends packages
COPY --from=python /home/${USERNAME}/.local /home/${USERNAME}/.local

# Replace to kachaka-api source code
USER $USERNAME
COPY src/erasers_kachaka/customs/dynamic_tf_bridge.cpp src/erasers_kachaka/customs/
RUN  cp src/erasers_kachaka/customs/dynamic_tf_bridge.cpp thirdparty/kachaka-api/ros2/kachaka_grpc_ros2_bridge/src/dynamic_tf_bridge.cpp

# Add ipython interface
COPY profile_ierk /home/${USERNAME}/.ipython/profile_default
USER root
RUN chown -R ${USERNAME}:${GROUPNAME} /home/${USERNAME}/.ipython
USER $USERNAME

ENV PATH=/root/.local/bin:$PATH

CMD ["/bin/bash"]
