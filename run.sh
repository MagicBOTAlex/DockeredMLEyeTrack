#!/bin/sh
IMAGE_NAME="eyetrack"

git clone https://github.com/MagicBOTAlex/MLEyeTrack.git

set -e           # ← exit on any command failure

echo "Building Docker image..."
docker build -t "$IMAGE_NAME" .

# only reached if build succeeded
docker stop  "$IMAGE_NAME" 2>/dev/null || true
docker rm    "$IMAGE_NAME" 2>/dev/null || true

echo "Running the container..."
docker run --gpus=all --network=host --shm-size=1g --name $IMAGE_NAME -it "$IMAGE_NAME"