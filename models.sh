#!/bin/bash
# Author Kush Nayak

# Download YOLOv5 ML Models from Craig's Google Drive
mkdir -p weights
function get_model {
	wget -q --show-progress --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate "https://docs.google.com/uc?export=download&id=${2}" -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=${2}" -O weights/$1 && rm -rf /tmp/cookies.txt
}

GATE_ID="18RodtGfvfKXPwqY8TSPaB2BxQMSDjJUN"
BUOY_ID="1DZmDkJSpwqXFEaNzEVfyt6S6tbbdZM8Z"
BINS_ID="1Md1hlqaeyzRoSU-iofml74sxICNaBhoh"
TORP_ID="131OonTbYDo3CRPlDTDod2y4XG5XJf-Ot"
OCTAGON_FRONT_ID="1s8Wz99FS49KqaNYjz9cyIPXXjok4xcUw"
OCTAGON_DOWN_ID="1_KhywObJfsyBUvMKwrwuDaWOQFsS1K5L"
BOTTLES_ID="18dKo4wAZppFKxs5vw2Uv09GWjMOYQEq2"
PATH_MARKER_ID="1keu8EevbXNRI0KRFCapySPcwuOh1y7mQ"

get_model gate.pt $GATE_ID
get_model buoy.pt $BUOY_ID
get_model bins.pt $BINS_ID
get_model torp.pt $TORP_ID
get_model octagon_front.pt $OCTAGON_FRONT_ID
get_model octagon_down.pt $OCTAGON_DOWN_ID
get_model bottles.pt $BOTTLES_ID
get_model path_marker.pt $PATH_MARKER_ID