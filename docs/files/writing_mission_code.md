## Writing Mission Code

To write mission code, we pretty much just reuse the same fundamental building blocks, but apply them to different tasks.

The `sub_mission` documentation has a lot more information on this topic.

Basically, sub_mission ultimately sends commands to Nautical-Private, and Nautical-Private, which runs on the Atmega Arduino, controls the thrusters to move to the desired setpoint.

In `sub_mission`, there is a root function that everything else pretty much routes to, and that is the `write_state()` function. Here, you can input a variable of type State, which has the elements of x, y, z, yaw, pitch, and roll, and the function will transfer over that setpoint to Nautical-Private for it to move to. Note that this function is not blocking, so  you can call it and it won't block the code waiting for the sub to move to the setpoint; it will just move on with your code almost instantly.

The next higher level up is the `move()` function, which calls the `write_state()` function and actually blocks the code by sleeping for 1 second incremends before until we arrive close enough to our desired destination. Numerous functions ultimately route to the move() function, including fundamental functions such as `setForward()`, `setHorizontal()`, `setForwardAtDepth()`, `setHorizontalAtDepth()`, `setAngle()`, `addAngle()`, etc. (There are more in depth explanations of each function inside the sub_mission documentation.)

With this information already, you can already write basic mission code. For example, if you want the sub to move forward 5 meters, turn right, and move left 2 meters, you can run the following in the gate() function in tasks.cpp for example:
```
setForward(5);
addAngle(90.);
setHorizontal(-2);
```

### Detecting Objects

Now moving isn't enough; you also have to be able to detect competition objects.

For this, the base function is `service_client::vision()`, where you input the integer that represents the task that you want to do (which are encoded in values like Task::GATE_ML for example which is the integer that represents the GATE_ML task), and the integer that corresponds to the camera you want to do the detection on. For front camera, use the `FRONT` variable, which equals 0, and for the down camera, use the `DOWN` variable, which equals 1.

The `service_client::vision()` function will return an object of type `Observation`, which contains elements such as the angle to the object and the distance to the object. 

One function that we use to align with object is called the `align()` function, which queries `sub_vision` using the `service_client::vision()` function your specified amount of times and returns the average absolute angle to the object. 

For example, to detect the gate and move to face towards it, you could do something like:
```
int attempts = 4;
float angle = align(attempts, Task::GATE_ML, FRONT);
if (isValidAngle(angle))
    setAngle(angle);
```

### Controlling Depth

Most of the time, we control depth measured from the bottom (aka altitude), which is measured by the DVL. This may seem counterintuitive, but it works will because the way that certain functions like `move()` and `setForward()` works is that they take the current state, edit some values, and then pass it through to Nautical-Private. This works for things like moving forward/horizontally, but if it gets the current z value and passes it on, the z value (depth from surface) that you set a few minutes ago is overrided with the new z value, which makes things more complicated. For this reason, we primarily control depth from the bottom, since in Nautical-Private a set desired altitude will override all depth from the surface requests, fixing our issue of the z value drift. If you do really want to control depth from the surface, you can use functions like `disableAltitudeControl()` and then `setDepthFromSurface()` to do so (but keep in mind they face the problems of z value drift).

To set depth from the bottom, we use the `setDepth()` function. For example, to set the sub to maintain a 1 meter altitude, we would say `setDepth(1);`.

### Adding a Little Sauce

Now, you have the tools to submerge the sub, align to an object, and move to the object. However, if you want to be a little more advanced, and (hopefully) a little more accurate, you can use continuous functions like `forwardAlign()` or `downContinuousAlign()`. These functions esssentially do everything we did at the top, except they continually get the latest vision detection and readjust the sub's trajectory using `write_state()` to continuously readjust. This way, you don't have to rely on just one detection, but you can essentially average these values out using multiple continuous detections to sort of "lock on" to the target.

### Final:

Now, we have pretty much all the tools in our bag that we need. For gate, we might do something like:
```
setDepth(1.5);
setForward(2);
forwardAlign(15, Task::GATE_ML, FRONT, 80);
std::this_thread::sleep_for(17s);
continuousSpin(720);
```

If you see some function parameters you don't recognize, see `sub_mission`'s documentation. If you see some functions you don't recognize, you can probably guess what they do based on their name, and see `sub_mission`'s documentation for an explanation.