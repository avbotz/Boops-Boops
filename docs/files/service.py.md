`service.py` has the code that creates the "vision" node, which provides a ROS2 service, where every time someone (i.e. mission node) requests a vision detection, this code calls the functions defined in `detect.py` to perform the detection and return the relevant information to the service client.

### class YOLOV5VisionService()

This is the class that creates a service object, which can be spun later. Spinning a node means that it is continually checking if anyone else made a request to it, and if so it will perform the necessary function to respond to that request and send back data if necessary.

### __init__()

This function gets called every time a variable of type YOLOV5VisionService is created. This initializes the detector object, which has the detection functions defined in `detect.py`, creates the vision service, checks for parameters that were passed to it (with the default value set to false if they didn't pass that parameter through), and subscribes to the front camera and down camera image topics. Every time a new image comes through on those topics, it will trigger the inputted callback function, which we will touch over later on this page. 

### handle_front_capture()

This function gets triggered every time the node sees that there is a new image available on the front camera image topic that it is subscribed to. It converts the image message to an image stored in an OpenCV type image variable, it logs the image if we specified that we want to log the images, we convert the image from BGR (Blue-Green-Red) format to RGB (which the YOLO model likes to detect on), and we store that image in the latest image variable that we keep track of.

### handle_down_capture()

This function getse triggered every time the node sees that there is a new image available on the down camera image topic that it is subscribed to. It then performs the same actions as the `handle_front_capture()` function, but it does them instead for the down camera image. 

### detect_callback()

This function gets triggered every time someone (i.e. mission node) makes a request to the vision service for a detection. If the task is different from the previous task, we will load up the new model, perform the detection on the specified camera image (using the functions specified in detect.py), and return the relevant information (the most important of which are the angles to the object and the distance to the object) to the service client.  

### main()

This function gets run every time you start up a "vision" node from the `sub_vision_yolov5s` package, and it will create the service, set up all the variables, and run all of the functions above when they are meant to be run (i.e. every time there is a new image on the image topic, or when a client requests a vision detection).