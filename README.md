```bash
echo "deb [trusted=yes] https://github.com/kinisi-robotics/moveit-builder/raw/100.0.5/ ./" | sudo tee /etc/apt/sources.list.d/kinisi-robotics_moveit-builder.list
echo "yaml https://github.com/kinisi-robotics/moveit-builder/raw/100.0.5/local.yaml humble" | sudo tee /etc/ros/rosdep/sources.list.d/1-kinisi-robotics_moveit-builder.list
```
