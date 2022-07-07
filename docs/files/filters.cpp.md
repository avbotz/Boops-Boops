`filters.cpp` has functions that perform operations on images, most notably filtering them. It also has some functions to downsize the images. 

### cv::Mat equalizeHist() (not putting all the parameters cuz lazy)

This function takes in an image, (variable of type cv::Mat, meaning the Matrix type (because an image is represented by a matrix of the rgb values of each pixel) from the cv (OpenCV) library) and if specified, it will equalize the rgb colors on all three channels and return the updated image? When I test out this function it makes the image look cleaner and more visible, so that's cool. Unused for now.

### cv::Mat illumination()

Maybe this returns an illuminated image tho. Idk not used right now.

### cv::Mat homomorphic()

I don't really know what this function does, and when I run it on an image, it returns some weird stuff. Not used right now.

### void fft()

Performs a Fast-Fourier-Transform on an input image and writes it to a destination image variable that is passed through to the second parameter spot. FFTs are usually used for signal analysis, and idk why we have this lol. Unused right now.

### cv::Mat butterworth()

Don't know what this does, not used right now.

### void underwaterEnhance()

This is an important function (developed by alumni Software VP Phoebe Tang) that takes in an image and filters that same image. (So when you call this function, you can just pass that variable in and it will update that same variable.) Based on my understanding, it's similar to the `equalizeHist` function, where it equalizes the colors in the image, which seems to make underwater pictures more visible, which is pretty useful.

### void resize()

This function takes in an image (that will get updated in place, there is no returned image variable), and resizes it so that the longest edge of the image will become the inputted image_size variable. This is useful because it automatically resizes the image down to that image length while maintaining the aspect ratio, which is useful for running ML detections.

### void preprocess()

Not used anymore, but basically prepared the image for EfficientDet-D0 model input (a model that we used before YOLOv5s) by normalizing the values in the image (idk what normalizing is, think it's similar to shifting the values so that the mean of the values is 0 or something like that).

### float calcDistance()

This calculates the distance to the object based on the object's pixel height in the image, the object's actual height, and some sensor specific information (such as focal length which idk what it is but I searched it up for our camera), and it returns the distance in meters. Not used in the `sub_acquisition` package, but an equivalent function is used in the `sub_vision_yolov5` package.