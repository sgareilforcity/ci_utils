#!/bin/bash
#1 : image name of the artifact
#2 : credential docker ex (-u %docker_login% -p "%docker_password%")
#3 : registry docker ex (%docker_registry%)
#4 : build branch ex (%teamcity.build.branch%)

docker login $2 https://$3
chmod -x utils/extract_tag.sh
tag= $(sh utils/extract_tag.sh $4)
echo "fetching $3/$1:$tag"
docker pull $3/$1:$tag

exit 0