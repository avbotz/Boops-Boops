#!/bin/bash
# Author Kush Nayak

# Download YOLOv5 ML Models from Craig's Google Drive
mkdir -p weights
function get_model {
	gdown -O weights/${1} "https://drive.google.com/uc?id=${2}"
}

GATE_ID="17PscSdU3oLgse5PIPkYnhb_v3SJ0jiBP"
BUOY_ID="17bpkjeoXu22Rag2bEVyzTbnZyi-9fClV"
BINS_ID="1xxajj2IMYhU1WjKOV9beIq48ZpfgYYJP"
TORP_ID="1Aj2WbU_t_qs5BwA82D42WumvU6QQm2tG"
DHD_FRONT_ID="1rsVM3gEGG6_eQscGotISide9YdsSnVIZ"
DHD_DOWN_ID="1_KhywObJfsyBUvMKwrwuDaWOQFsS1K5L"
CHEVRON_ID="1taykZqAB17bMUQSb_csjp8vhgVNEshrb"
PATH_MARKER_ID="147WSg3n5Wdnxpz8rimX9Kx_EXjUYGcnZ"

get_model gate.pt $GATE_ID
get_model buoy.pt $BUOY_ID
get_model bins.pt $BINS_ID
get_model torp.pt $TORP_ID
get_model dhd_front.pt $DHD_FRONT_ID
get_model dhd_down.pt $DHD_DOWN_ID
get_model chevron.pt $CHEVRON_ID
get_model path_marker.pt $PATH_MARKER_ID