"""
This file is to run mission_node, control_node, vision_node, and acquisition_node 
for the sub to complete the mission in POOL D (either competition or at a pool test)
"""

from launch import LaunchDescription
from launch_ros.actions import Node
import time

time.sleep(10);

def generate_launch_description():
    return LaunchDescription([
        #Node(
        #    package='dvl_a50_publisher',
        #    node_executable='dvl_a50_publisher_sensor',
        #    output='screen'
        #),
        Node(
            package='sub_acquisition',
            node_executable='acquisition',
            output='screen'
        ),
        Node(
            package='sub_vision_yolov8',
            node_executable='vision',
            output='screen',
            parameters=[
                {"LOG_FRONT": True},
                {"LOG_DOWN": True},
            ]
        ),
        Node(
            package='sub_control',
            node_executable='control',
            output='screen'
        ),
        Node(
            package='sub_mission',
            node_executable='mission',
            output='screen',
            parameters=[
                {"GATE": True},
                {"BUOY": True},
                {"BINS": False},
                {"OCTAGON": True},
                {"POOL_D": True}
            ]
        ),

        # Launch image display, to access enter:
        # (ip address of computer running BB):5000 in a web browser
        Node(
            package='sub_interface',
            node_executable='interface',
            output='screen',
        )
    ]) 
