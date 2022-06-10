## Collecting Sim Image Datasets

Before the competition, usually you will want to first update the simulator and put the new props inside according to the specifications provided by Robosub (see that tutorial first).

With your updated props, you can then follow the BB README instructions to launch a launchfile to startup the sim and other nodes that let you remote control the sub in the sim while the latest front and down cam images are being saved automatically.

Usually, it'll go something like this:
- cd path/to/Boops-Boops
- ./compile.sh
- source setup.sh
- ros2 launch launch/sim_remote_control_image_collection.py 

If you want to only log front camera images, replace `sim_remote_control_image_collection.py` with `sim_remote_control_image_collection_front.py`.

If you want to only log down camera images, replace `sim_remote_control_image_collection.py` with `sim_remote_control_image_collection_down.py`.