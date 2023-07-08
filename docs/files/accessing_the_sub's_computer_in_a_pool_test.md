## Accessing the Sub's Computer in a Pool Test

During a pool test, we need to be able to connect to the sub's computer to run the code on the sub's computer to do all the tasks.

For this, there is an ethernet cable on that motherboard of the sub's computer, that extends through a subconn connector on the lid of the sub (the red connector things), that connects to a wifi access point device (like a box/router) on the ground outside the pool. This wifi access point creates a local wifi network, so we can use this local area network (LAN) to SSH or VNC into the sub's computer. SSH is like opening a terminal from that computer, and VNC is like remote controlling the screen of another computer, so with VNC you are able to control the sub's screen on your personal computer as if you were directly operating on the sub's computer. Once inside the sub's desktop screen, you can run maritime and Boops-Boops to run all of the code following the instructions in the "Pool Test Procedure" section.

## Issues with connecting?

The sub's computer uses Ubuntu 20.04, which has a default encryption setting for Vnc that not all programs support. Enter `gsettings set org.gnome.Vino require-encryption false` into the terminal of the sub to turn of the VNC encryption. It is also a good idea to regularly turn the encryption back on using `gsettings set org.gnome.Vino require-encryption true` (why this works is obvious), for increased security. Generally, disabling this encryption should be safe because we are using LAN for connection, so the wifi network is private and the sub is normally left off. 

If you need to access the terminal, you can set up a SSH tunnel. Mac users can input `ssh avbotz@192.168.1.100` into terminal where paramaters are `ssh [USERNAME]@[IP_ADDRESS]` of the computer you are accessing. Make sure to be connected to the same AVBOTZ network the sub is connected to. 

## Mac VNC Connection

Go to finder (can click on desktop background), press <kbd>Cmd</kbd> + <kbd>K</kbd>, and in the text field paste and connect to `vnc://192.168.1.100`, or the current ip address used. This is the mac inbuilt VNC software using the Screen Share feature. Fill in the prompt that asks for the password, and the screen of the sub should come up.
