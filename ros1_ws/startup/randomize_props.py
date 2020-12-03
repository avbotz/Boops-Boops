"""
This is a script to add an element of randomness to 
the props' spawn locations in the simulator to mimic competition settings.
@author Craig Wang
6/10/20
"""

import random
import xml.etree.ElementTree as ET

X = 0
Y = 1
Z = 2
ROLL = 3
PITCH = 4
YAW = 5

BIN_TYPES = ["wolf_bin", "bat_bin"]

def pick(choices):
	"""
	Helper function to return a random element from the inputted list
	"""
	choice = random.randint(0, len(choices) - 1)
	return choices[choice]

def generate_pos_offsets(start_loc, coordinate, offset_range):
	"""
	Randomize starting location of object between provided range.
	Args:
	start_loc = list of [x, y, z, r, p, y] East-North-Up Coordinates
	coordinate = int, 0 through 5 (use X Y Z ROLL PITCH YAW constants)
	offset_range = list of 2 (eg. [-1, 1]) lower bound of offset to upper bound to select random offset from
	"""
	offset = random.uniform(offset_range[0], offset_range[1])
	start_loc[coordinate] += offset
	return start_loc

def generate_yaw_offsets(start_loc):
	"""
	Randomize yaw positioning to 0, 120, or 240 degrees (used for tribuoy)
	Args:
	start_loc = list of [x, y, z, r, p, y] East-North-Up Coordinates
	"""
	possible_yaws = [0, 2.09, 4.19]
	random_pick = random.randint(0, 2)
	yaw_offset = possible_yaws[random_pick]
	start_loc[YAW] += yaw_offset
	return start_loc

def edit_world_file(file, prop_name, new_loc):
	tree = ET.parse(file)
	root = tree.getroot()

	new_pose = "{} {} {} {} {} {}".format(
		new_loc[X],
		new_loc[Y],
		new_loc[Z],
		new_loc[ROLL],
		new_loc[PITCH],
		new_loc[YAW],
	)

	prop_name = "model://{}".format(prop_name)

	# Edit in new position
	world = root.find("world")
	for model in world.findall("include"):
		name = model.find("uri")
		if prop_name == name.text:
			model.find("pose").text = new_pose

	# Save changes
	tree.write(file)
	line_prepender(file, '<?xml version="1.0"?>')

def randomize_bin_edit_world_file(file, new_loc):
	""" 
	Randomly chooses between wolf or bat bin
	"""
	tree = ET.parse(file)
	root = tree.getroot()

	new_pose = "{} {} {} {} {} {}".format(
		new_loc[X],
		new_loc[Y],
		new_loc[Z],
		new_loc[ROLL],
		new_loc[PITCH],
		new_loc[YAW],
	)

	prop_name = pick(BIN_TYPES)
	prop_name = "model://{}".format(prop_name)

	# Edit in new position
	world = root.find("world")
	for model in world.findall("include"):
		name = model.find("uri")
		if "bin" in name.text:
			model.find("pose").text = new_pose
			name.text = prop_name

	# Save changes
	tree.write(file)
	line_prepender(file, '<?xml version="1.0"?>')

def line_prepender(filename, line):
    with open(filename, 'r+') as f:
        content = f.read()
        f.seek(0, 0)
        f.write(line.rstrip('\r\n') + '\n' + content)

if __name__ == "__main__":
	world_file = "./src/sub_sim/worlds/transdec.world"

	# Base prop positions in X Y Z Roll Pitch Yaw (East North Up system)
	gate_loc = [10, -3.5, -2.5, 0, 0, 1.3]
	buoy_loc = [17.5, -4, -3, 0, 0, 1.3]
	tribuoy_loc = [17, -6.5, -3.2, 0, 0, 0.85]
	bin_loc = [27.5, -9, -4, 0, 0, -2.14]

	gate_loc = generate_pos_offsets(gate_loc, coordinate=X, offset_range=[-1, 1])
	gate_loc = generate_pos_offsets(gate_loc, coordinate=Y, offset_range=[-0.5, 0.5])
	gate_loc = generate_pos_offsets(gate_loc, coordinate=Z, offset_range=[-0.25, 0.25])
	gate_loc = generate_pos_offsets(gate_loc, coordinate=ROLL, offset_range=[-0.05, 0.05])
	gate_loc = generate_pos_offsets(gate_loc, coordinate=YAW, offset_range=[-0.1, 0.1])

	buoy_loc = generate_pos_offsets(buoy_loc, coordinate=X, offset_range=[-1, 1])
	buoy_loc = generate_pos_offsets(buoy_loc, coordinate=Y, offset_range=[-0.25, 0.25])
	buoy_loc = generate_pos_offsets(buoy_loc, coordinate=Z, offset_range=[-0.15, 0.15])
	buoy_loc = generate_pos_offsets(buoy_loc, coordinate=YAW, offset_range=[-0.1, 0.1])

	tribuoy_loc = generate_pos_offsets(tribuoy_loc, coordinate=X, offset_range=[-1, 1])
	tribuoy_loc = generate_pos_offsets(tribuoy_loc, coordinate=Y, offset_range=[-0.25, 0.25])
	tribuoy_loc = generate_pos_offsets(tribuoy_loc, coordinate=Z, offset_range=[-0.15, 0.15])
	tribuoy_loc = generate_pos_offsets(tribuoy_loc, coordinate=YAW, offset_range=[-0.1, 0.1])
	tribuoy_loc = generate_yaw_offsets(tribuoy_loc)

	bin_loc = generate_pos_offsets(bin_loc, coordinate=X, offset_range=[-1, 1])
	bin_loc = generate_pos_offsets(bin_loc, coordinate=Y, offset_range=[-1, 1])
	bin_loc = generate_pos_offsets(bin_loc, coordinate=YAW, offset_range=[-3.14, 3.14])

	edit_world_file(world_file, prop_name="gate", new_loc=gate_loc)
	edit_world_file(world_file, prop_name="buoy", new_loc=buoy_loc)
	edit_world_file(world_file, prop_name="tribuoy", new_loc=tribuoy_loc)
	randomize_bin_edit_world_file(world_file, new_loc=bin_loc)
