FROM ros:humble-ros-core

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt update && \
    apt install --no-install-recommends -y \
    python3-rosdep

# See http://snapshots.ros.org/humble/ for the available snapshots
# Make sure the snapshot is supported in https://github.com/kinisi-robotics/moveit-builder
ENV SYNC_DATESTAMP=2024-08-28
ENV ROS_DISTRO=humble
ENV ROSDISTRO_INDEX_URL="https://raw.githubusercontent.com/ros/rosdistro/${ROS_DISTRO}/${SYNC_DATESTAMP}/index-v4.yaml"

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key 4B63CF8FDE49746E98FA01DDAD19BAB3CBF125EA && \
    rm /etc/apt/sources.list.d/ros2-latest.list && \
    echo "deb http://snapshots.ros.org/${ROS_DISTRO}/${SYNC_DATESTAMP}/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list

RUN echo "deb [trusted=yes] https://raw.githubusercontent.com/kinisi-robotics/moveit-builder/stable-${SYNC_DATESTAMP}/ ./" | \
        tee /etc/apt/sources.list.d/moveit-builder.list && \
    . /opt/ros/${ROS_DISTRO}/setup.sh && \
    rosdep init && \
    sed -i "s|ros\/rosdistro\/master|ros\/rosdistro\/${ROS_DISTRO}\/${SYNC_DATESTAMP}|" /etc/ros/rosdep/sources.list.d/20-default.list && \
    echo "yaml https://raw.githubusercontent.com/kinisi-robotics/moveit-builder/stable-${SYNC_DATESTAMP}/local.yaml humble" | \
        tee /etc/ros/rosdep/sources.list.d/moveit-builder.list

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt update && \
    apt install --no-install-recommends -y ros-humble-moveit* && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*
