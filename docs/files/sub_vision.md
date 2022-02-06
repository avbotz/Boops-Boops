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

## Where to Put the Trained ML Models