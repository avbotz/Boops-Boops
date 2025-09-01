#!/bin/bash

# Download YOLOv8 ML Models from AVBotz's Google Drive (Models folder)
mkdir -p weights

function get_model {
	gdown -O weights/${1} "https://drive.google.com/uc?export=download&id=${2}"
}

GATE_ID="1L8H6b_PiN5qG7jL7ZOkyPW4ldba-gC23"
BUOY_ID="19UICBVFu-zuT1yEe3ichgfm4iEbPyavw"
BINS_ID="1C0PVH8j-IWb8SM6kBrCsQozQxzMxiL80"
TORP_ID="1RJkziRk7B6uulfgHfi_Mdm17I6zgubn3"
DHD_FRONT_ID="1gnJ1R7G3ppu904XWvpCX7L9jOocuQHgP"
DHD_DOWN_ID="1E4MyB3p3Sj3CuMPW2XyMjQqYSqxy7zVF"
CHEVRON_ID="1nS73c4cax0qq_I_a_fizp75pJNFJ1z7Z"
PATH_MARKER_ID="10NYWxMqjRV7mZMBSUL5lKkNr8t_48PCE"
SLALOM_ID="1YaGnFYl4W_8gtgS_h7uCtObqtg1Yf70m"
OCEANCLEANUP_ID="1W-jYtUw31bG7j0XgaFTTklDj9OOuv7hv"

get_model gate.pt $GATE_ID
get_model buoy.pt $BUOY_ID
get_model bins.pt $BINS_ID
get_model torp.pt $TORP_ID
get_model dhd_front.pt $DHD_FRONT_ID
get_model dhd_down.pt $DHD_DOWN_ID
get_model chevron.pt $CHEVRON_ID
get_model path_marker.pt $PATH_MARKER_ID
get_model slalom.pt $SLALOM_ID
get_model oceancleanup.pt $OCEANCLEANUP_ID
