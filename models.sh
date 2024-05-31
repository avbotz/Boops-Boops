#!/bin/bash
# Author Kush Nayak

# Download YOLOv5 ML Models from AVBotz's Google Drive (Models folder)
mkdir -p weights

pip install -U --no-cache-dir gdown --pre

function get_model {
	gdown -O weights/${1} "https://drive.google.com/uc?export=download&id=${2}"
}

GATE_ID="1L8H6b_PiN5qG7jL7ZOkyPW4ldba-gC23"
BUOY_ID="1_0fDRlG7czr7XOEjjLIZkN7Hjl29rIB-"
BINS_ID="13sVRtqkDhirejGSCT2Rhx88O1_eWbfHH"
TORP_ID="1Qdi9Xasul0z_3fVcz_rMaWGM1fgjhzyT"
DHD_FRONT_ID="1NZCSB88jZ2C8v__CK62NLnG3wwplmyOA"
DHD_DOWN_ID="1_1J1Oy2Jbj4E4sla4fZ7Pm4--mb4mtY6"
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