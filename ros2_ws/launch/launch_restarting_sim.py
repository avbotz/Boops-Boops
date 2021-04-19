"""
For now, it's necessary to launch the Gazebo simulator through the ros1 workspace.
This file is to run mission, control, vision nodes to work with the simulator.
This launch file uses restart_node if the user wishes to gain a more realistic
sense of what a competition run will feel like (since we will use restart_node
instead of mission_node at competition).
"""

from launch import LaunchDescription
from launch_ros.actions import Node

def generate_launch_description():
    return LaunchDescription([
        Node(
            package='sub_vision',
            node_executable='vision_node',
            node_name='vision',
            output='screen',
            parameters=[
                {"SIM": True}
            ]
        ),
        Node(
            package='sub_control',
            node_executable='service',
            node_name='control',
            output='screen',
            parameters=[
                {"SIM": True}
            ]
        ),
        Node(
            package='sub_mission',
            node_executable='restart_node',
            node_name='mission',
            output='screen',
            parameters=[
                {"GATE": True},
                {"BINS": True},
                {"TARGET": True},
                {"OCTAGON": True},
                {"POOL_B": True}.
                {"SIM": True}
            ]
        )
    ])