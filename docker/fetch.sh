#!/bin/bash
#1 : catalog name if not filed

docker login -u %docker_login% -p "%docker_password%" https://%docker_registry%
catalog= $(echo sh extract_catalog.sh $1)
tag= $(echo sh extract_tag.sh "%teamcity.build.branch%")
echo "fetching %docker_registry%/$imagename:$tag"
docker pull %docker_registry%/$imagename:$tag

exit 0