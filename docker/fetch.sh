#!/bin/bash
# exemple :sh fetch.sh platform/ci/template -u teamcity -p ******* registry-v2.forcity.io refs/tags/1.0.0-alpha
####################################################################
#1 : image name of the artifact
#2 : credential docker ex (-u %docker_login% -p "%docker_password%")
#3 : registry docker ex (%docker_registry%)
#4 : build branch ex (%teamcity.build.branch%)
#####################################################################
image_name=$(cat artifacts/docker/artifact.yml | shyaml get-value image.name)
docker login $2 https://$3
tag=$(sh utils/docker/extract_tag.sh $4)
echo "##teamcity[progressMessage 'fetching $3/$1:$tag']"
docker pull $3/$1:$tag
result=$?
if [ "$result" != "0" ]; then
    echo "##teamcity[message text='Error while fetching image $imagename' errorDetails='Error while fetching image $imagename' status='WARN']"
fi
exit 0


python trufflehog.py git@github.com:sgareilforcity/template_ci.git /refs/heads/master