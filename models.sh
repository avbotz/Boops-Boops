#!/bin/bash
# Author Kush Nayak

# Download YOLOv5 ML Models from Craig's Google Drive
mkdir -p weights
function get_model {
	wget -q --show-progress --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate "https://docs.google.com/uc?export=download&id=${2}" -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=${2}" -O weights/$1 && rm -rf /tmp/cookies.txt
}

GATE_ID="18RodtGfvfKXPwqY8TSPaB2BxQMSDjJUN"
BUOY_ID="1Nn65ZOOkcQFiYATDIkBQX1V-agAF2pB-"
BINS_ID="117WsRQgEZlVJhpxTeXip0eRNoWGyTPNc"

get_model gate.pt $GATE_ID
get_model buoy.pt $BUOY_ID
get_model bins.pt $BINS_ID