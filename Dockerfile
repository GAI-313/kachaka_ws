# Arguments
ARG ROS=humble
ARG ARCHTECTURE=amd64


# Base docker image
FROM gai313/ros2:${ROS}.amd64 AS base_amd64


# Main image
FROM base_${ARCHTECTURE} AS main

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

USER root
RUN . /opt/ros/${ROS}/setup.bash &&\
    apt-get update &&\
    rosdep update &&\
    rosdep install -y -i --from-path thirdparty &&\
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

#
USER $USERNAME
COPY src ./src  
USER root
RUN . /opt/ros/${ROS}/setup.bash &&\
    apt-get update &&\
    rosdep update &&\
    rosdep install -y -i --from-path src \
        --skip-keys "emcl2 rclpy_util kachaka_grpc_ros2_bridge kachaka_description kachaka_interfaces kachaka_shelf_description" &&\
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install python depends packages
USER $USERNAME
RUN pip install -r ./src/erasers_kachaka/requirements.txt ipython

# Replace to kachaka-api source code
USER $USERNAME
RUN  cp src/erasers_kachaka/customs/dynamic_tf_bridge.cpp thirdparty/kachaka-api/ros2/kachaka_grpc_ros2_bridge/src/dynamic_tf_bridge.cpp

# Add ipython interface
COPY profile_ierk /home/${USERNAME}/.ipython/profile_default
USER $root
RUN chown -R ${USERNAME}:${GROUPNAME} /home/${USERNAME}/.ipython
USER $USERNAME

CMD ["/bin/bash"]
