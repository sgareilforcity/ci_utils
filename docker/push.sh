#!/bin/bash

catalog=$(cat catalog)
docker login -u %docker_login% -p "%docker_password%" https://%docker_registry%
dependency_branch=$(echo "%dep.Lumis_Lumis.teamcity.build.branch%" | sed "s,refs/heads/,,g")
for imagename in $catalog; do
    imagepath=$(echo $imagename|sed "s,@,/,g")
    imagename=$(echo $imagename|sed "s/@/_/g")
    if [ -d "$imagepath" ]; then
        if [ "$dependency_branch" == "master" ]; then
            version="latest"
            tags="latest build-%build.number%"
        else
            version=$(echo "$dependency_branch" | sed "s,release/,,g" | sed "s,/,-,g")
            tags="$version"
            echo "Processing $imagename:$tags...."

        fi
        for tag in $tags; do
            echo "Pushing %docker_registry%/$imagename:$tag"
            docker push %docker_registry%/$imagename:$tag
            result=$?
            if [ "$result" != "0" ];then
                echo "Error while pushing."
                exit 1
            fi
        done
    else
      echo "Cannot find $imagepath"
    fi

done