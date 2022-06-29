## Fixing AHRS Drift

If you are running the sub with the tether, we theorized that the length of the tether creates strong magnetic fields that interfere with the AHRS, which uses the Earth's magnetic field to determine its current yaw. With this interference, even if you point the sub in the same direction, the yaw value of the AHRS might keep increasing steadily and not maintain itself at a set position.

To fix this issue, you can remove the tether and instead put the wifi access point/white and blue router box inside of the sub and VNC into it that way. Keep in mind that once the sub goes underwater, you will lose all connection to the sub, but this fixes the AHRS yaw drift.

For things like collecting images, you can still use the tether with the collecting images launch file/remote control, but keep in mind you'll probably have to keep manually turning the sub back on course after it drifts. 

For autonomous runs, you can probably use the untethered method of putting the wifi access point inside the sub.