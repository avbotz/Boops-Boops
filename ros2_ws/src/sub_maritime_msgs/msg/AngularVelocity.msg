# An angular velocity message. Axes are standard roll, pitch and yaw.
# All variables are in radians per second (NOT DEGREES!)
#
# Note that the Attitude controller feeds into the AngularVelocity
# controller. Directly setting an AngularVelocity setpoint will
# disable the attitude setpoint until a new one is sent.

float32 yaw_rad_s
float32 pitch_rad_s
float32 roll_rad_s
