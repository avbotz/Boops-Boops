"""
For now, it's necessary to launch the Gazebo simulator through the ros1 workspace.
This file is to run control, tuning, and vision_node to remote control Nemo 
through the simulator as it logs images from only the front camera
(maybe for ML training or remote control practice).
"""

from launch import LaunchDescription
from launch_ros.actions import Node

def generate_launch_description():
    return LaunchDescription([
        Node(
            package='sub_control',
            node_executable='service',
            output='screen',
            parameters=[
                {"SIM": True}
            ]
        ),
        Node(
            package='sub_control',
            node_executable='tuning',
            output='screen'
        ),
        Node(
            package='sub_acquisition',
            node_executable='acquisition',
            output='screen',
            parameters=[
                {"SIM": True}
            ]
        ),
        Node(
            package='sub_vision_yolov5',
            node_executable='vision',
            output='screen',
            parameters=[
                {"SIM": True},
                {"LOG_FRONT": True},
            ]
        ),

        # Launch image display
        Node(
            package='rqt_image_view',
            node_executable='rqt_image_view',
            output='screen'
        )
    ])