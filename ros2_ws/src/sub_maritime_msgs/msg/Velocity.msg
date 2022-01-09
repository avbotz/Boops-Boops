# A velocity message. Operates in NED coordinates.
# All variables are in meters per second.
#
# Note that the Position controller feeds into the Velocity
# controller. Directly setting a Velocity setpoint will
# disable the position setpoint until a new one is sent.

float32 forward_m_s
float32 right_m_s
float32 down_m_s
