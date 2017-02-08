#!/bin/bash
# Log into docker registry
####################################################################
#1 : credential docker ex (-u %docker_login% -p "%docker_password%")
#2 : registry docker ex (%docker_registry%)
#3 : build branch ex (%teamcity.build.branch%)
#####################################################################
image_name=$(cat artifacts/docker/artifact.yml | shyaml get-value image.name)
docker login $1 https://$2
tag=$(sh utils/docker/extract_tag.sh $3)
cd artifacts
echo "##teamcity[progressMessage 'Building image $2/$image_name:$tag']"
docker build -t $2/$image_name:$tag -f  docker/Dockerfile .
result=$?
cd ..
sh utils/teamcity/teamcity_error.sh $result 418
