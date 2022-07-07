`acquisition.cpp` is the file that creates the node executable that reads in images rom the front and down cameras and publishes them onto a ROS2 topic for the node from `sub_vision` to read from to have images to run detections on.

### void setupContinuousAcquisition()

This function uses the Spinnaker SDK API to initialize reading images from a camera that is connected via USB or Ethernet.

### void setupContinuousAcquisition() (the other one)

This function also sets up a camera to have the inputted exposure time. According to Google, the exposure time is the amount of time that the camera is exposed to light when taking a photograph. I think changing this value would change the brightness of the camera. 

### void setupFramerate()

Theoretically passing one of the variables of type Spinnaker Camera to this function, along with your desired framerate, should set the framerate of the camera. But, when testing this it didn't seem to work, so I don't really know about this one chief.

### void runCamera()

This is the function that starts reading the images from the specified inputted camera and publishes them onto a ROS2 topic. If we have the filter variable flag set to on (true), then it will also filter the image to improve visibility (developed by alumni former Software VP Phoebe Tang). It will also downsize the images because our ML models run on smaller images and don't need larger images, and it will finally publish the image. 

### void forwardSimCap()

This is similar to runCamera, except it takes in the raw image from the image topic in the sim, and it republishes them (after filtering if specified and downsizing) to the final image topic that `sub_vision` will read from when it's in sim mode. 

### int initSimCamera()

This is sort of like runCamera but for the sim (I know I already said this about forwardSimCap, but forwardSimCap is called by this function). Essentially, this function subscribes to the raw image topics that get images from the camera in the sim, and it links the callback function as forwardSimCap. Every time the subscriber reads in a new image from the topic, it will trigger the callback function and call it, which ends up being forwardSimCap, so forwardSimCap does the aforementioned editing and publishes it onto a final, different topic. 

### int main()

This is the function that is run whenever an `acquisition` from the `sub_acquisition` package is run. It will run the following:
- Declare and get parameter settings that are set either from the launch file or the command line, saving them into global variables. The second parameter of the declare_parameter function is the default value, so if we don't receive a setting from the launch file or the command line, then the default value is false.
- If we are in simulator mode (which is set by the parameter that is passed from the launch file or command line), then run the function that gets the images from the sim and edits and republishes them instead.
- Sets up the image logging folders is necessary, but it seems like this function isn't used anymore? (The log folder is set up by `sub_vision_yolov5`)
- Uses Spinnaker SDK to find the cameras that are connected and create variables that represent the cameras. 
- If there's only one camera, then just call the `runCamera` function on that one camera to take images from the hardware and publish them onto ROS2 topics. If there are two cameras, then it uses `std::thread`s to (I think) split the process into two different processes, both of which are running at the same time to ultimately get images from both cameras and publish them onto ROS2 topics.
- Finally, when the system receives a kill signal (such as entering Ctrl-C) through the terminal, it seems like it de-initializes the cameras (don't really know what this does).