## Fixing AHRS Drift

Note: This is for the old $1k TRAX AHRS. We replaced this with a $30 WitMotion WT-901 AHRS, putting it in 6 axis mode through WitMotion's Windows Software (so it uses the gyro and accelerometer, no magnetometer (compass) -> no magnetometer means we don't have to worry about drift induced by changing magnetic fields like we did with the old AHRS.) This new AHRS in only gyro and accel mode multiplies angular velocity by time interval to get the change in angle and adds it to the overall angular position, so it will drift a little bit over time from the true position (but it won't be too bad, it is better than the uncalibrated TRAX that used a compass.)

Note: In the future it's probably better to design everything and use cheap sensors/components that still work very well, like our current WitMotion AHRS and the Cerulean Sonar DVL. Sometimes it's not worth it to buy expensive hardware, as a lot of times it is overkill for our needs, and the components can be very fragile and lead to accidental breakages that can drain up to tens of thousands of dollars. Sometimes it's better to invest in cheap sensors/parts that work well, to keep things replaceable and financiable by the club. 

For the WitMotion, if something is going weird:
- Use WitMotion Windows app (search up how to download it, it's on their website for the WT-901 AHRS)
- Connect the AHRS to computer using FTDI (which is a Serial to USB converter)
- Open their Windows app
- Click Config -> Reset
- Exit Config and reenter Config (for changes to update in the menu)
- Click 6 axis mode to not use magnetometer (because magnetic fields make the reading drift and wobble heavy)
- Make the output rate 100 Hz so that we get lots of data for the microcontroller to use and make PID adjustments fast to make the sub move smooth in the water (or else the sub might wobble back and forth on the yaw axis.)
- Make sure changes are saved and then exit.

For the $1k AHRS:

If you are running the sub with the tether, we theorized that the length of the tether creates strong magnetic fields that interfere with the AHRS, which uses the Earth's magnetic field to determine its current yaw. With this interference, even if you point the sub in the same direction, the yaw value of the AHRS might keep increasing steadily and not maintain itself at a set position.

To fix this issue, you can remove the tether and instead put the wifi access point/white and blue router box inside of the sub and VNC into it that way. Keep in mind that once the sub goes underwater, you will lose all connection to the sub, but this fixes the AHRS yaw drift.

You can also follow the PNI TRAX user manual to perform a 2D calibration using their Windows software (or sending commands through the Arduino sending byte commands to the TRAX) to calibrate the AHRS while the motors are powered up (just lifting the sub around to the yaw setpoints and taking the calibration samples to get the AHRS used to the magnetic fields of the motors).

For things like collecting images, you can still use the tether with the collecting images launch file/remote control, but keep in mind you'll probably have to keep manually turning the sub back on course after it drifts. 

For autonomous runs, you can probably use the untethered method of putting the wifi access point inside the sub.