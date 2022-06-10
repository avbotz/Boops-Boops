## Setting Up the Onboard Computer

These are instructions to setup the onboard computer from absolute scratch:
- Contact electrical to have them wire up the GPU to the motherboard.
- Install Ubuntu 20.04 on the computer (search up how to do this online.)
- Once inside Ubuntu, install the Nvidia drivers for the GPU. For the RTX 3050, we used this link: https://forums.developer.nvidia.com/t/nvidia-drivers-are-not-running-in-ubuntu-20-04-rtx-3050-with-ryzen-9-5900hx/191729/7?u=craigwang1
  - ^but instead of installing the 470 drivers, we installed the 510 drivers.
- Next, install CUDA and CUDNN to be able to use the GPU for running ML models.
  - We followed this tutorial: https://denishartl.com/cuda-cudnn-tensorflow-remote-ssh-on-headless-ubuntu-20-04-server-2/
  - Make sure to swap out their CUDA and CUDNN versions for the versions that match with your current version of PyTorch. For us, PyTorch 1.11 used CUDA 11.3 and CUDNN 8.2.0, so that's what we installed. You can find this information online.
- Install the PyTorch and Torchvision versions that match your CUDA version.
  - You can get the install commands from here: https://pytorch.org/get-started/locally/ 
- Follow the BB instructions to install BB on the onboard computer.
  - Make sure in the installing YOLOv5 requirements part, you can delete that line and manually install each dependency except for torch and torchvision, so that you don't override the custom installations that work for your GPU.
- Follow the Nautical-Private instructions to install Nautical-Private on the onboard computer.

You're done! You can follow BB README instructions to run the sim to test that everything works. 

In pool tests, you can run the sub using the instructions in the BB README under the "Pool Test Procedure" section.