`commandParser.cpp` is the file that contains helper functions to parse commands coming from BB's `sub_control` to `sub_sim`. This sort of mimics how Nautical-Private parses commands, as I wanted to get these two as similar as possible.

### commandParser::init()

Initializes the file that we read from. BB will write commands to this file, and the simulator node will read the commands from that file.

### commandParser::split()

This function splits the command string by space into a vector, where each element of the vector is an std::string of the full word/character string that was in between two spaces.

### commandParser::parseInt()

This function takes the next element of the command, stored as a std::string into the vector that we created above, and it converts it into an integer. This is useful for if the controller in the simulator node is expecting an integer as the next value of the command, so this function will give the next element as an integer.

### commandParser::parseFloat()

Does the same thing as parseInt() but instead returns the value as a float.

### commandParser::available()

This function reads the next command that we have from the file and vectorizes it (splits it up by word/element into a std::vector, std::vectors are like lists in python or arrays), and it returns the number of elements/words that are not spaces in the command. If there are no new commands, this will just not do anything and return 0.