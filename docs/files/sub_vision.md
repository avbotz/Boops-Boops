`sub_vision` is the package that handles detection of competition objects from the camera, and it returns information such as the angle and distance to the objects to sub_mission.

## Structure

## How it Works

First, `sub_vision` has a file that creates a node that handles the main vision detections. This `vision` node creates a service, that when called on by `sub_mission`, performs the detection that it is requested to do. It does this by taking the latest image that it receives from the camera that corresponds with the detection request (these images are constantly being read from the hardware by a separate node called `acquisition` node, which publishes these images onto a topic that `vision` can read from), loading up the ML model that sub_mission requests for, and performing the detection on the image.

Usually, the ML model will identify the object in the image and return the coordinates of a "bounding box" that surrounds an object; for our purposes, we take the pixel coordinates of the center of the box, we input those pixel coordinates into an equation developed by former VP Suhas Nagar to calculate the horizontal and vertical angles from the camera to the object, and we return this angular information back to sub_mission. For some cases, we also calculate the distance to the object using a [formula](https://photo.stackexchange.com/a/12437) copied from some random dude online, and we return that as well to sub_mission. 

Using this information, sub_mission is able to send commands to turn towards the object and approach it if it desires to do so, since it knows both the angle and distance to the object

## How to Train ML Models 

To train ML models, you will first need a labeled dataset (which is a folder with the images you want to train the model on + corresponding .xml files that contain information about where the object is in the image.)

The steps to train are as follows:
* Collect images (see "Image Collection Run" or "Simulated Image Collection Run" sections in README)
* Annotate the images (use [CVAT](https://github.com/openvinotoolkit/cvat), which has the capability of [interpolating](https://youtu.be/Hc3oudNuDsY) between images to automatically label some images for you, which speeds up the process a ton), and export them into PASCAL VOC format (to put them into one directory with images + corresponding .xml annotation files)
* Train - Follow this Google Colab [link](https://colab.research.google.com/drive/1BQJQTtTJBKeh5aI53_zLtkuy93W6ZN11?usp=sharing) to train your model (you may have to upload a .zip file of your images+annotations dataset onto your Google Drive first)
* Deploy - (put instructions here (maybe download the model, put it into the BB models folder, upload the download models script in BB?)))

## OpenCV

Besides using ML models, we also use OpenCV (Open Computer Vision), which are traditional computer vision techniques that do not require ML. These include techniques such as filtering out colors, detecting edges in an image, etc. Currently, we plan on using OpenCV for tasks that do not require distinguishing specific objects, such as the path markers, or orienting ourselves to the bin (perhaps).

**Pathmarker Detection**

* Convert image to BGR (necessary to apply HSV filter to image)
* Apply HSV filter to mask out colors not in the orange color threshold 
* Apply strong image blur and Canny Edge Detection with high threshold
* Erode image to create a black-white mask
* Find contours in image, filter out small objects, and iterate for contour with lowest hue
* Get contours that have a hue close to the lowest hue (in case there are 2 path markers in sight)
* Get contour closest to image and draw bounding contour and rectangle around it
* Find top and bottom pixels of bounding contour using argmin() and argmax()
* Use angle detection code to find the angle between the top and bottom pixels of the bounding contour

## sub_acquisition

sub_acquisition is sort of like sub_vision, and its role is to take in images from the physical cameras and provide them to sub_vision. In the sub_acquisition package, the acquisition node continually interfaces with the cameras via Spinnaker SDK to get the latest image, it converts these into OpenCV format images, it downsizes the images (because the raw images for the front cam are like ~5000x3000 pixels, and the raw images for the down cam are like ~1280x800 pixels, which are too big for our YOLOv5s model), it filters the images if specified (configured in config.hpp of sub_acquisition), and it publishes these images onto a ROS2 topic that sub_vision listens and subscribes to.