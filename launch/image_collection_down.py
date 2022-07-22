"""
This file is to run vision nodes to log images for both the front and down cameras.
You can push the sub around, or control the sub through Nautical terminal commands
(using relative movement)
"""

from launch import LaunchDescription
from launch_ros.actions import Node

def generate_launch_description():
    return LaunchDescription([
        Node(
            package='sub_acquisition',
            node_executable='acquisition',
            output='screen'
        ),
        Node(
            package='sub_vision_yolov5',
            node_executable='vision',
            output='screen',
            parameters=[
                {"LOG_FRONT": False},
                {"LOG_DOWN": True}
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