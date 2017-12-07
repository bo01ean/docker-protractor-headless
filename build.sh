HUB=docker-gis-eaaps.dockerhub.illumina.com
PROJECT_NAME=headless-horseman
PROJECT_TAG=meteor

REV="$PROJECT_NAME:$PROJECT_TAG"
REMOTE_IMAGE="$HUB/$REV"

docker build . -t $REV

docker login $HUB
docker tag $REV $REMOTE_IMAGE
docker push $REMOTE_IMAGE
