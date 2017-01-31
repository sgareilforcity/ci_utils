#!/bin/bash
#1 : catalog name if not filed

if[ -n catalog];then
    catalog=$(cat catalog)
else
    if[ -n $1];then
        catalog=$1
    else
        echo "catalog of image not found"
        exit 418
    fi
fi

docker login -u %docker_login% -p "%docker_password%" https://%docker_registry%
tag= $(echosh extracttag.sh "%teamcity.build.branch%")

for imagename in $catalog; do
    if [ -d "$imagename" ]; then
        echo "fetching %docker_registry%/$imagename:$tag"
        docker pull %docker_registry%/$imagename:$tag
    fi
done
exit 0