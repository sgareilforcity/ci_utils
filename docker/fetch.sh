#!/bin/bash
#1 : image name of the artifact
#2 : credential docker ex (-u %docker_login% -p "%docker_password%")
#3 : registry docker ex (%docker_registry%)
#4 : build branch ex (%teamcity.build.branch%)

ls -lisa

docker login $2 https://$3

tag=$(echo sh utils/docker/extract_tag.sh $4)
echo "fetching $3/$1:$tag"
docker pull $3/$1:$tag
result=$?
if [ "$result" != "0" ]; then
    echo "##teamcity[message text='Error while fetching image $imagename' errorDetails='Error while building image $imagename' status='ERROR']"
    echo "Error while building $imagename"
    exit 418
fi
exit 0