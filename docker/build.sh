#!/bin/bash
# Log into docker registry
docker login -u %docker_login% -p "%docker_password%" https://%docker_registry%
imagename=$1
tag=$(echo ./utils/extract_tag.sh "%teamcity.build.branch%")
# Move artifacts into this directory
cd %system.teamcity.build.checkoutDir%/artifacts
# update teamcity progress bar
echo "##teamcity[progressMessage 'Building image %docker_registry%/$imagename:$tag']"
# build docker image
docker build -t %docker_registry%/$imagename:$tag -f Dockerfile .
result=$?
# If docker building was unsuccesful, bail out
if [ "$result" != "0" ]; then
    echo "##teamcity[message text='Error while building image $imagename' errorDetails='Error while building image $imagename' status='ERROR']"
    echo "Error while building $imagename"
    exit 418
fi
cd %teamcity.build.checkoutDir%
echo "##############################################"
echo "Done building %docker_registry%/$imagename:$tag"
echo "##############################################"
