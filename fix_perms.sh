USER=$(whoami)
sudo usermod -aG video $USER
sudo usermod -aG dialout $USER
