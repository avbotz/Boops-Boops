"""
This file is to run mission_node, control_node, vision_node, and acquisition_node
for the sub to complete the mission in POOL A (either competition or at a pool test)
"""

from launch import LaunchDescription
from launch_ros.actions import Node

def generate_launch_description():
    return LaunchDescription([
        Node(
            package="sub_acquisition",
            executable="acquisition",
            output="screen"
        ),
        Node(
            package="sub_vision_yolov8",
            executable="vision",
            output="screen",
            parameters=[
                {"LOG_FRONT": True},
                {"LOG_DOWN": True},
            ]
        ),
        Node(
            package="sub_control",
            executable="control",
            output="screen"
        ),
        Node(
            package="sub_mission",
            executable="mission",
            output="screen",
            parameters=[
                {"GATE": True},
                {"BUOY": True},
                {"BINS": True},
                {"OCTAGON": True},
                {"POOL_A": True}
            ]
        ),

        # Launch image display, to access enter:
        # (ip address of computer running BB):5000 in a web browser
        Node(
            package="sub_interface",
            executable="interface",
            output="screen",
        )
    ])