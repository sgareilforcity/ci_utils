#!/bin/bash
# exemple :sh install.sh -u teamcity -p ******* registry-v2.forcity.io refs/tags/1.0.0-alpha
####################################################################
#1 : credential docker ex (-u %docker_login% -p "%docker_password%")
#2 : registry docker ex (%docker_registry%)
#3 : build branch ex (%teamcity.build.branch%)
#####################################################################
echo "############################## begin install ###############################"
image_name=$(cat artifacts/docker/artifact.yml | shyaml get-value image.name)
docker login $1 https://$2
tag=$(sh utils/docker/extract_tag.sh $3)

echo "##teamcity[progressMessage 'launch install platform ... ']"
sh artifacts/forcity_devenv_install.run --quiet