#!/bin/bash
# Build articacts directory

# Log into docker registry
docker login -u %docker_login% -p "%docker_password%" https://%docker_registry%
imagename=$1
tag=$(echo sh extract_tag.sh "%teamcity.build.branch%")

   # Check the image dir exists
    if [ -d "$imagename" ]; then
        # Move artifacts into this directory
        mv %system.teamcity.build.checkoutDir%/artifacts "$imagename/"

        # update teamcity progress bar
        echo "##teamcity[progressMessage 'Building image %docker_registry%/$imagename']"

        cd $imagename

        # dynamically replace "auto_version" in FROM line with target tag
        sed -r "s,FROM %docker_registry%/(.*):auto_version,FROM %docker_registry%/\1:$tag,g" Dockerfile > ./Dockerfile_tmp

        # build docker image
        imghash=$(docker build -t %docker_registry%/$imagename -f Dockerfile_tmp .)
        result=$?
        rm ./Dockerfile_tmp

        # If docker building was unsuccesful, bail out
        if [ "$result" != "0" ]; then
            echo "##teamcity[message text='Error while building image $imagename' errorDetails='Error while building image $imagename' status='ERROR']"
            echo "Error while building $imagename"
            exit 1
        fi
        imghash=$(echo $imghash | tail -1 | sed 's/.*Successfully built \(.*\)$/\1/')
        for tag in $tags;do
            echo "##teamcity[progressMessage 'tagging image %docker_registry%/$imagename with $tag']"
            echo "tagging image %docker_registry%/$imagename with $tag"
            docker tag $imghash %docker_registry%/$imagename:$tag
        done
        cd %teamcity.build.checkoutDir%
        mv "$imagename/artifacts" %system.teamcity.build.checkoutDir%/
    fi
    echo "##############################################"
    echo "Done building %docker_registry%/$imagename"
    echo "##############################################"
