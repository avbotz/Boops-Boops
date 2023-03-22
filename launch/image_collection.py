"""
This file is to run vision nodes to log images for both the front and down cameras.
You can push the sub around, or control the sub through the webserver's
control mode, or send string movement commands to the lower level command
process on the microcontroller (eg. see Nautical documentation).
"""

from launch import LaunchDescription
from launch_ros.actions import Node

def generate_launch_description():
    return LaunchDescription([
        Node(
            package='sub_control',
            node_executable='control',
            output='screen'
        ),
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
                {"LOG_FRONT": True},
                {"LOG_DOWN": True}
            ]
        ),
        
        # Launch image display, to access enter:
        # (ip address of computer running BB):5000 in a web browser

        # Use the interface's manual control mode to control the sub
        # while the code automatically logs images.
        Node(
            package='sub_interface',
            node_executable='interface',
            output='screen',
        )
    ])