#!/bin/bash
catalog=$(cat catalog)
docker login -u %docker_login% -p "%docker_password%" https://%docker_registry%
if [ "%teamcity.build.branch%" == "master" ]; then
    version="latest"
else
    version="%teamcity.build.branch%"
fi

for imagename in $catalog; do
    imagepath=$(echo $imagename|sed "s,@,/,g")
    imagename=$(echo $imagename|sed "s/@/_/g")
    if [ -d "$imagepath" ]; then
        echo "fetching %docker_registry%/$imagename:$version"
        tag=$(echo "$version" | sed "s,/,-,g")
        docker pull %docker_registry%/$imagename:$tag
    fi
done
exit 0