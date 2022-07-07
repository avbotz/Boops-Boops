`log.cpp` contains functions to log images, but it's not used anymore in the `sub_acquisition` package. Instead, `sub_vision_yolov5` logs the images instead if that package is specified to do so.

### void log()

Writes the inputted image and saves it to the folder. Although it is present in `sub_acquisition`, it's not currently being used, and instead, an equivalent function is used to log images in `sub_vision_yolov5`. (It's more convenient to log images there if specified because it already logs image detections, so might as well log everything there.)

### void init()

I think this function is supposed to create the image logging folder, but I don't think it's being used right now (or at least utilized correctly, or not important too.) An equivalent function in `sub_vision_yolov5` creates the folder instead. 