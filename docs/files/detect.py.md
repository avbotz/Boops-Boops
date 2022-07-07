`detect.py` has the code that handles detections using the YOLOv5s ML models. It detects the pixel coordinates of the center of the bounding box around the object, it uses that information to calculate the angle to the object, and in some cases (i.e. gate, buoys) it also calculates the distance to the object.

### TaskWeights

This is a dictionary that maps the integer that represents each task, to the filepath of the model that is used for each task.

### Parameters

There are a bunch of parameters at the top of the page that have information about the size of the images, the height of some props in real life, and some sensor values (which are used for calculating distances to some objects such as the gate and bouys).

### class Camera

This class is used to make code more readable by mapping integers that represent which camera to use (with 0 representing that we want the front camera and 1 representing that we want the down camera) with variable names.

### class Observation

This class makes an object that contains information about the detection/observation information from the ML detection. It works by first passing through the values such as the pixel coordinates of the center of the bounding box, and it will then use those values to calculate the angle to the object and the distance to the object if applicable. The angle formula is a custom formula using trig to calculate what should be the exact angle to the object, and the distance is a formula taken from [online](https://photo.stackexchange.com/a/12437).

### class Detector

This class makes an object that has functions that perform ML detections.

### load_task_model()

This loads the model that corresponds to the task (represented by an integer) that is inputted into the function. The definitions for which integers correspond to which tasks is found in sub_vision_interfaces's Task.msg. Since we don't have wifi during the comp run, we load these models locally, as we previously cloned the yolov5 repo during installation on our local machine, that we can use to load the model locally here.

### run_detection_path_marker()

This is a special case function that uses OpenCV to detect the path marker, and it returns the Observation object with the pixel coordinates of the center of the path marker, along with the orient of the path marker, which is the relative angle that the path marker is pointing to. Here are the steps for path marker detection:
* Convert image to BGR (necessary to apply HSV filter to image)
* Apply HSV filter to mask out colors not in the orange color threshold 
* Apply strong image blur and Canny Edge Detection with high threshold
* Erode image to create a black-white mask
* Find contours in image, filter out small objects, and iterate for contour with lowest hue
* Get contours that have a hue close to the lowest hue (in case there are 2 path markers in sight)
* Get contour closest to image and draw bounding contour and rectangle around it
* Find top and bottom pixels of bounding contour using argmin() and argmax()
* Use angle detection code to find the angle between the top and bottom pixels of the bounding contour

### run_detection_bins()

This is another special case function that runs the ML model trained on the bins to return the detection information (the pixel coordinates of the center of the bounding box of the bin, which is later used to calculate the angles to the bin as soon as the Observation object is initialized). The reason why we need this separate function instead of running the default `run_detection()` function is so that we can parse cases to make sure we can return the bounding box for only the "bin" class, not the "opening" (the opening of the bin class), as the bin model is trained on both classes.

### run_detection_bins_opening()

This is another special case function, where we have to do a little bit more processing. Basically, we were trying to prepare for the worst case scenario where the bin lid is in the center of the bin with the two openings being exactly the same size. To process this edge case, we need to select one side of the bin and stick to it, whether it be the top/bottom side if the bin is more oriented that way, or the left/right side if the bin is more oriented horizontally. This function basically chooses which side based on which opening is bigger, and on subsequent calls, it will return to that same side because it saved which side it wants to go to. This function also does the same as the other functions in that it returns the center pixel coordinates information about the detection which we can use to calculate the angles to the object (relative yaw and pitch angles to the object).

### run_detection()

This is the mother function, which is the default function for processing vision detections that don't need special case processing. It essentially runs the model to inference on the image, and it returns an Observation object that has the center pixel coordinate and pixel height of the detection information of the detection which we can use to calculate the angles to the object and the distance to the object (if applicable). It only returns an observation if the confidence is above 0.3, so we don't send back bad/false detections. Also, it logs the images before and after the detections for debugging and cool purposes.