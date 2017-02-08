#!/bin/bash
# Log into docker registry
####################################################################
#1 : image name of the artifact
#2 : credential docker ex (-u %docker_login% -p "%docker_password%")
#3 : registry docker ex (%docker_registry%)
#4 : build branch ex (%teamcity.build.branch%)
#####################################################################
tag=$(sh utils/docker/extract_tag.sh "$4")
docker login $2 https://$3
cd artifacts
imagename=$(cat docker/artifact.yml | shyaml get-value image.name)
echo "##teamcity[progressMessage 'Building image $3/$imagename:$tag']"
docker build -t $3/$imagename:$tag -f  docker/Dockerfile .
result=$?
cd ..
sh utils/teamcity/teamcity_error.sh $result 418
