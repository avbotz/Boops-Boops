`Vision.srv` is the file that defines what type of values and how many of them are inputted and outputted to/from the vision service. 

The values/variables on top of the line are the values that are passed from the client to the service, whereas the values/variables below the line are the values that are returned from the service to the client.

int8 means an 8-bit integer, and float32 means a 32-bit float. 

The values:
* task = The integer that represents which task you want to detect on. The numbers that correspond to each task are defined in Task.msg.
* camera = The integer that represents which camera you want to use on your detection. 0 = front camera, 1 = down camera.
* confidence = The confidence, expressed as a decimal from 0-1, of how confident the detector is in its detection. Usually, ML models will output a confidence of their detection. If it's an OpenCV detection, we usually just return something like 0.8 for the confidence. 
* r = Which row the center of the detection's pixel is on. In other words, this is the y pixel coordinate of the detection.
* c = Which column the center of the detection's pixel is on. In other words, this is the x value coordinate of the detection. 
* dist = The distance to the object (applicable to gate and buoys).
* orient = The orientation of the object. Applicable to path marker. For path marker, this is the relative angle that the path marker is pointing to. 
* hangle = The horizontal angle (relative yaw) from the camera to the object. These are in the NED (North-East-Down) coordinate frame, and positive yaw = right, negative yaw = left.
* vangle = The vertical angle (relative pitch) from the camera to the object. These are in the NED (North-East-Down) coordinate frame, and positive pitch = up, negative pitch = down.