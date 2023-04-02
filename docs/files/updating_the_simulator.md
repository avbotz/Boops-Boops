## Updating the Simulator

Every year, the organizers at Robosub usually change the competition theme, which changes the props that are inside the course. If we want to be successful, we need to have a working simulator with the updated props so that we can test that our mission code can work.

To update the props, see the following steps:
1. Get the latest new prop specifications from Robosub (can be found on website).
2. Design these props in Blender, and export them as .obj files. When you export, click "Y Forward" and "Z Up" so that Blender won't edit the orientation of your model. For this, you can see YouTube tutorials. 
3. See the existing layout for props in the sub_sim/models/ directory, and copy paste one of the existing formats but put the updated prop name and model inside of it, adjusting all the necessary fields in all of the files.
4. Update the world configuration layout in the sub_sim/worlds/transdec.world file.
5. Update the location and randomized locations of the prop in the sub_sim/scripts/randomize_props.py script.

You're good! Make sure to commit and push your changes when you are finished (see BB instructions, or see online tutorials.)