#!/bin/bash
# sed -i -r "s,FROM %docker_registry%/(.*):latest,FROM %docker_registry%/\1:$version,g" ./Dockerfile_tmp
catalog=$(cat catalog)
docker login -u %docker_login% -p "%docker_password%" https://%docker_registry%
dependency_branch=$(echo "%dep.Lumis_Lumis.teamcity.build.branch%" | sed "s,refs/heads/,,g" | sed "s,refs/tags/,,g")
echo "DEPENDENCY BRANCH:$dependency_branch"
for imagename in $catalog; do
    imagepath=$(echo $imagename|sed "s,@,/,g")
    imagename=$(echo $imagename|sed "s/@/_/g")
    logname=$(echo $imagename|sed "s,/,_,g")
    if [ -d "$imagepath" ]; then
        if [ "$dependency_branch" == "master" ]; then
            version="build-%build.number%"
            tags="latest build-%build.number%"
        else
            version=$(echo "$dependency_branch" | sed "s,release/,,g" | sed "s,/,-,g")
            tags="$version"
        fi

        echo "##teamcity[progressMessage 'Building image %docker_registry%/$imagename']"
        echo "##############################################"
        echo "building %docker_registry%/$imagename:$tags"
        echo "##############################################"
        echo ""
        cd $imagepath
        sed "s,%%version%%,$version,g" Dockerfile > ./Dockerfile_tmp

        sed -i "s,%%branch%%,$dependency_branch,g" ./Dockerfile_tmp
        sed -i "s,%%revision%%,%dep.Lumis_Lumis.build.vcs.number.Lumis_Lumis%,g" ./Dockerfile_tmp
        cat Dockerfile_tmp
        docker build --no-cache --build-arg LUMIS_BRANCH="$dependency_branch" -t %docker_registry%/$imagename -f Dockerfile_tmp . > $logname.buildlog.txt 2>&1
        echo "##teamcity[publishArtifacts '$imagepath/$logname.buildlog.txt']"
        result=$?
        rm ./Dockerfile_tmp
        imghash=$(tail -1 $logname.buildlog.txt | sed 's/.*Successfully built \(.*\)$/\1/')
        if [ "$result" != "0" ]; then
            echo "##teamcity[message text='Error while building image $imagename' errorDetails='Error while building image $imagename' status='ERROR']"
            echo "Error while building $imagename, check $logname.buildlog.txt"
            exit 1
        fi
        for tag in $tags; do
            echo "##teamcity[progressMessage 'tagging image %docker_registry%/$imagename with $tag']"
            echo "tagging image %docker_registry%/$imagename ($imghash) with $tag"
            docker tag $imghash %docker_registry%/$imagename:$tag
        done
        cd %teamcity.build.checkoutDir%
    fi
        echo "##############################################"
        echo "Done building %docker_registry%/$imagename"
        echo "##############################################"


done