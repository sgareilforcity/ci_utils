#!/bin/bash
# exemple :sh fetch.sh -u teamcity -p ******* registry-v2.forcity.io refs/tags/1.0.0-alpha
####################################################################
#1 : build branch ex (%teamcity.build.branch%)
#2 : repo git ex (sgareilforcity/)
#####################################################################
image_name=$(cat artifacts/docker/artifact.yml | shyaml get-value image.name)
tag=$(sh utils/docker/extract_tag.sh $3)
echo "##teamcity[progressMessage 'pull requesting on Master of $1']"

if[ $1 = "refs/heads/release-candidate" ];then
curl post {
  "title": "Amazing new feature",
  "body": "Please pull this in!",
  "head": "sgareilforcity:release-candidate",
  "base": "master"
}
fi
exit 0