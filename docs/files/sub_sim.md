`sub_sim` is the package that creates a simulated environment (sort of like a videogame) to test if our mission and vision code works.

## Structure
The main ROS launch files that start up Gazebo and create the environment is located in the `launch` folder, with `simulator.launch` being the main file (to run a launch file, search it up lol feel lazy to type it here.) Next, the `meshes` folder contains the 3D design files with Nemo's design, which includes the main `dae` file that describes the body of nemo along with the `propeller.dae` file which is the design of the propeller (that is stolen from the uuvsim repo) and some images to provide the color of the sub. 

In order to create the scenario in Gazebo, we need 3D models of the props and the Transdec pool, which are stored in the `meshes` folder, usually as `obj` files. They are also some `model.config` and `model.sdf` files; those are just to register these models so that Gazebo can see them. 

To actually spawn these props inside the scenario, the prop locations are written in the `transdec.world` file in the `worlds` folder; if you ever need to update the sim to have new props for a new competiton, you can create the model in Blender (preferably an obj file with color image textures (it seems using images to color the object result in brighter colors in the sim, whereas coloring them the default way creates colors that are too light in the sim)), place the model files in the `models` folder using the other models as an example, and then edit in te location into the `transdec.world` file. Then, when you launch the sim with the roslaunch file, you should see the props inside of the sim.

For creating the robot, a plugin called `uuvsimulator` is used, which handles all the underwater physics and stuff. The overall configuration of the robot is defined in `robots/default.xacro`, and the definitions of each  part of Nemo are located in the `urdf` folder. `actuators.xacro` defines the location of the motors, `base.xacro` creates the hunk of Nemo with its mass properties (which are actually copied from a uuvsim example, these are not the real mass/inertia values of Nemo) and visual models, `gazebo.xacro` describes the hydrodynamic properties of Nemo (copied from a uuvsim example, not the actual values for Nemo because those values seemed to be too small, so Gazebo couldn't handle them), `sensors.xacro` creates the sensors (eg. front cam, down cam, DVL (Doppler Velocity Log used to track Nemo's velocity and distance to floor), IMU (Inertial Measurement Unit used to track Nemo's orientation), pressure (used to track Nemo's depth) and places them at a location on the sub. Finally, `snippets.xacro` creates some convenience definitions that we use elsewhere in the other xacro files.

```
sub_sim
├── CMakeLists.txt
├── include
│   └── simulator
│       ├── commandParser.hpp
│       ├── PIDController.hpp
│       └── utils.hpp
├── launch
│   ├── simulator_heads.launch
│   ├── simulator.launch
│   ├── simulator_tails.launch
│   ├── transdec.launch
│   ├── upload_heads.launch
│   ├── upload.launch
│   └── upload_tails.launch
├── meshes
│   ├── black.png
│   ├── nemo.dae
│   ├── pink.png
│   ├── propeller.dae
│   ├── README.md
│   ├── red.png
│   ├── white.png
│   └── yellow.png
├── models
│   ├── ball
│   │   ├── meshes
│   │   │   ├── ball.mtl
│   │   │   ├── ball.obj
│   │   │   └── pink.png
│   │   ├── model.config
│   │   └── model.sdf
│   ├── bat_bin
│   │   ├── meshes
│   │   │   ├── bat.mtl
│   │   │   ├── bat.obj
│   │   │   ├── bat.png
│   │   │   ├── black.png
│   │   │   ├── orange.png
│   │   │   ├── white.png
│   │   │   └── yellow.png
│   │   ├── model.config
│   │   └── model.sdf
│   ├── bin_cover
│   │   ├── meshes
│   │   │   ├── bin_cover.mtl
│   │   │   ├── bin_cover.obj
│   │   │   ├── orange.png
│   │   │   └── purple.png
│   │   ├── model.config
│   │   └── model.sdf
│   ├── bootlegger_bin
│   │   ├── meshes
│   │   │   ├── bootlegger_bin_image.png
│   │   │   ├── bootlegger_bin.mtl
│   │   │   └── bootlegger_bin.obj
│   │   ├── model.config
│   │   └── model.sdf
│   ├── bootlegger_buoy
│   │   ├── meshes
│   │   │   ├── bootlegger_buoy.mtl
│   │   │   ├── bootlegger_buoy.obj
│   │   │   └── tommy_gun.png
│   │   ├── model.config
│   │   └── model.sdf
│   ├── buoy
│   │   ├── meshes
│   │   │   ├── buoy.mtl
│   │   │   ├── buoy.obj
│   │   │   └── jiangshi.png
│   │   ├── model.config
│   │   └── model.sdf
│   ├── buoys
│   │   ├── meshes
│   │   │   ├── badge.png
│   │   │   ├── buoys_collision.stl
│   │   │   ├── buoys.mtl
│   │   │   ├── buoys.obj
│   │   │   └── tommy_gun.png
│   │   ├── model.config
│   │   └── model.sdf
│   ├── gate
│   │   ├── meshes
│   │   │   ├── black.png
│   │   │   ├── bootlegger.jpg
│   │   │   ├── gate_collision.stl
│   │   │   ├── gate.mtl
│   │   │   ├── gate.obj
│   │   │   ├── gman.jpg
│   │   │   └── orange.png
│   │   ├── model.config
│   │   └── model.sdf
│   ├── gman_bin
│   │   ├── meshes
│   │   │   ├── gman_bin_image.png
│   │   │   ├── gman_bin.mtl
│   │   │   └── gman_bin.obj
│   │   ├── model.config
│   │   └── model.sdf
│   ├── gman_buoy
│   │   ├── meshes
│   │   │   ├── badge.png
│   │   │   ├── gman_buoy.mtl
│   │   │   └── gman_buoy.obj
│   │   ├── model.config
│   │   └── model.sdf
│   ├── octagon
│   │   ├── meshes
│   │   │   ├── octagon.mtl
│   │   │   ├── octagon.obj
│   │   │   └── white.png
│   │   ├── model.config
│   │   └── model.sdf
│   ├── path
│   │   ├── meshes
│   │   │   ├── path.mtl
│   │   │   └── path.obj
│   │   ├── model.config
│   │   └── model.sdf
│   ├── transdec
│   │   ├── meshes
│   │   │   ├── brownrock.png
│   │   │   ├── sand.png
│   │   │   ├── transdec_collision.stl
│   │   │   ├── transdec.dae
│   │   │   └── white.png
│   │   ├── model.config
│   │   └── model.sdf
│   ├── tribuoy
│   │   ├── meshes
│   │   │   ├── aswang.png
│   │   │   ├── draugr.png
│   │   │   ├── tribuoy_collision.stl
│   │   │   ├── tribuoy.mtl
│   │   │   ├── tribuoy.obj
│   │   │   ├── vetalas.png
│   │   │   └── white.png
│   │   ├── model.config
│   │   └── model.sdf
│   ├── water
│   │   ├── model.config
│   │   └── model.sdf
│   └── wolf_bin
│       ├── meshes
│       │   ├── black.png
│       │   ├── orange.png
│       │   ├── white.png
│       │   ├── wolf.mtl
│       │   ├── wolf.obj
│       │   ├── wolf.png
│       │   └── yellow.png
│       ├── model.config
│       └── model.sdf
├── package.xml
├── README.md
├── robots
│   └── default.xacro
├── scripts
│   ├── create_sim_ports.sh
│   └── randomize_props.py
├── src
│   ├── commandParser.cpp
│   ├── PIDController.cpp
│   ├── simulator.cpp
│   └── utils.cpp
├── urdf
│   ├── actuators.xacro
│   ├── base.xacro
│   ├── gazebo.xacro
│   ├── sensors.xacro
│   └── snippets.xacro
└── worlds
    └── transdec.world

```

## How It Works With the Rest of the Stack

In the `src` folder, the main file to look for is `simulator.cpp`; when the simulator is launched via the launch file (discussed above), it also runs this code file which creates a ROS node that controls the motors of the simulated Nemo (the motor control code is copied over from Nautical, slightly edited to redirect motor thrusts to the simulator.) Usually, BB communicates with Nautical by sending messages (eg. what state to move to, what depth to move to, etc.) over serial to the Atmega, but with the sim, sub_control redirects this request to instead write to a text file (created by `scripts/create_sim_ports.sh`, which is called each time by the launch file when the simulator is launched) that the simulator ROS node reads from. Once the simulator node receives this information of where to move, it adjusts the motors accordingly to move to that position. So, we run the entire code stack and sub_mission normally, but its just that sub_mission's commands are sent to the text file (which the simulator node reads from and controls Nemo accordingly) instead of to the Atmega. Also, virtual cameras publish their images onto a topic, which sub_vision can also access as if they were from the real camera.

## How it Controls the Sub

In the `src` folder, `commandParser.cpp` contains convenience definitions that allow the simulator node to parse info read from the text file, and `PIDController.cpp` contains the functions that do the meat of the controlling of Nemo's simulated thrusters, while `util.cpp` just contains some convenience functions. The way it controls Nemo is that once it receives a request to move to a specific state, the functions in `PIDController.cpp` the error of Nemo to its target state, and then it activates the motors that move Nemo in the desired direction (called PID control.) It knows where its current state is by subscribing to a DVL topic that tells Nemo's distance to the floor and velocity (we can multiply velocity by time interval to get how much we move, then add that over time to see our position relative to the origin/where the sub turned on), an IMU topic that tells Nemo its orientation (yaw, pitch, roll), and a pressure topic that tells the current pressure (which we can use to calculate the depth from the surface.)

## Mimicking Real-Life

To mimic real life settings, we have a strong water current that jostles Nemo around (defined in `transdec.world` near the bottom), and we also randomize the position of the competition props each run slightly (like in real life) (defined in `scripts/randomize_props.py`, which is run by the launch file every time the launch file launches jeez that was a mouthful.)

## Future Improvements

Here are some ways we could improve the simulator:
* More realistic graphics (migrate to use Unity instead of Gazebo, like Team Inspiration?)
* Separate scenarios for each comp task, so that we can test comp tasks individually (would require, restruction sub_mission's tasks.cpp to create new functions in between the main functions that move from spot to spot, so we can have functions that only do the task without first moving to it)
* Adding Nemo's actual parameters: Right now, Nemo's values (eg. mass, inertia) are not actually Nemo's, but rather they're copied from a uuvsimulator example robot. I tried to put Nemo's actual parameters in before, but it seemed that some of the values were too small (which Gazebo couldn't handle), causing the sim to crash each time. However, I probably did something wrong, and if we could get Nemo's actual specs in there, that would be nice and more realistic.

## How the Sim was Created

To create the sim, I first copied over the default examples from `uuvsimulator` and got that running, then I put Nemo's stuff (models, sensors) in one by one until Nemo was inside the sim instead.

For future projects, to whoever may be reading this (hi there), remember that nothing is impossible (kinda corny ik.) However, if people can literally put a rocket on the moon, there's no reason why you can't spawn a box inside a screen. You can also apply this to other projects as well; just know that it is possible. When you feel that you are getting stuck on a frontier project, just keep hacking away at it, and eventually it has to fall. For example, a single drop of water, applied consistently, can eventually carve up an entire mountain into a valley (so if you keep going, it has to fall eventually.) For tips on how to do this, read Elon Musk's biography, Outliers, and Atomic Habits (those will teach you why I say what I say). Another thing I learned is to always follow your own standards; don't let lower standards that others might have make you feel better about yourself to do less work, but also don't let higher standards of someone else mess with your psyche. Keep chugging along at a pace that is comfortable to you where you can maintain a healthy mind and body, and that will do you wonders. Also, if someone reading this is a VP or is thinking of becoming a VP, how to be a good leader is just remembering these 3 things: vision, empathy, and hard work. You want a vision of how you want the club to look like/do (center your vision around creating something, around work usually works better). You want to be empathetic, to care for the squad, which makes people not hate you. Finally, don't be afraid to work as hard, or even harder than anyone in the squad. This will prompt others to also pick up the pace since you're leading by example, and you'll also get more done as a club with your contributions. Some last things that Ima just plug in here because I feel too lazy to make the whole paragraph flow is to not get lost in the sauce (don't fall too in love with looking smart with fancy words or programs that other people don't know; this makes you look like a zob who doesn't actually do any work and is annoying to other people), and don't let other people tell you that something is hard or impossible (because we're just space monkeys moving some blocks around on a screen, it's really not that complex, keep things simple). I wish whoever is reading this best of luck in the club; I didn't mean to get so philosophical but I don't have much else to do rn so good luck lol.