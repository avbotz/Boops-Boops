#!/bin/bash
# Author Kush Nayak

# Download YOLOv5 ML Models from AVBotz's Google Drive (Models folder)
mkdir -p weights

pip install -U --no-cache-dir gdown --pre

function get_model {
	gdown -O weights/${1} "https://drive.google.com/uc?export=download&id=${2}"
}

GATE_ID="1L8H6b_PiN5qG7jL7ZOkyPW4ldba-gC23"
BUOY_ID="14QAeTO7JtNfHMjoB07mojDIb2iA34rxC"
BINS_ID="1C0PVH8j-IWb8SM6kBrCsQozQxzMxiL80"
TORP_ID="1e7IL6-E5axybd27jLMDF2_UziTmdX4rh"
DHD_FRONT_ID="1gnJ1R7G3ppu904XWvpCX7L9jOocuQHgP"
DHD_DOWN_ID="1E4MyB3p3Sj3CuMPW2XyMjQqYSqxy7zVF"
CHEVRON_ID="1nS73c4cax0qq_I_a_fizp75pJNFJ1z7Z"
PATH_MARKER_ID="10NYWxMqjRV7mZMBSUL5lKkNr8t_48PCE"

get_model gate.pt $GATE_ID
get_model buoy.pt $BUOY_ID
get_model bins.pt $BINS_ID
get_model torp.pt $TORP_ID
get_model dhd_front.pt $DHD_FRONT_ID
get_model dhd_down.pt $DHD_DOWN_ID
get_model chevron.pt $CHEVRON_ID
get_model path_marker.pt $PATH_MARKER_ID

mkdir weights/depth-anything-v2-small-hf
wget -O weights/depth-anything-v2-small-hf/config.json https://huggingface.co/depth-anything/Depth-Anything-V2-Small-hf/resolve/main/config.json?download=true
wget -O weights/depth-anything-v2-small-hf/model.safetensors https://huggingface.co/depth-anything/Depth-Anything-V2-Small-hf/resolve/main/model.safetensors?download=true
wget -O weights/depth-anything-v2-small-hf/preprocessor_config.json https://huggingface.co/depth-anything/Depth-Anything-V2-Small-hf/resolve/main/preprocessor_config.json?download=true
