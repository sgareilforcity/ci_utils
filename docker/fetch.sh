#!/bin/bash
#1 : image name of the artifact
#2 : credential docker ex (-u %docker_login% -p "%docker_password%")
#3 : registry docker ex (%docker_registry%)
#4 : build branch ex (%teamcity.build.branch%)

ls -lisa

docker login $2 https://$3

tag= $(sh utils/docker/extract_tag.sh $4)
echo "fetching $3/$1:$tag"
docker pull $3/$1:$tag

exit 0