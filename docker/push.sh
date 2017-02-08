#!/bin/bash
####################################################################
#1 : credential docker ex (-u %docker_login% -p "%docker_password%")
#2 : registry docker ex (%docker_registry%)
#3 : build branch ex (%teamcity.build.branch%)
#####################################################################
image_name=$(cat artifacts/docker/artifact.yml | shyaml get-value image.name)
docker login $1 https://$2
tag=$(sh utils/docker/extract_tag.sh $3)
cd artifacts
docker push %docker_registry%/$imagename:$tag
result=$?
cd ..
sh utils/teamcity/teamcity_error.sh $? 1 ERROR