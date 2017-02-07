#!/bin/bash
# exemple :sh fetch.sh platform/ci/template -u teamcity -p ******* registry-v2.forcity.io refs/tags/1.0.0-alpha
####################################################################
#1 : image name of the artifact
#2 : credential docker ex (-u %docker_login% -p "%docker_password%")
#3 : registry docker ex (%docker_registry%)
#4 : build branch ex (%teamcity.build.branch%)
#####################################################################
sh utils/teamcity/extract_utils.sh
image_name=$(cat artifacts/docker/artifact.yml | shyaml get-value image.name)
docker login $2 https://$3
tag=$(sh utils/docker/extract_tag.sh $4)
echo "##teamcity[progressMessage 'fetching $3/$1:$tag']"
docker pull $3/$1:$tag
sh utils/teamcity/teamcity_error.sh
exit 0



