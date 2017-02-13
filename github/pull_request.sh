#!/bin/bash
# pull request on github of release-candidate to master
# utils/github/pull_request.sh
# exemple :sh fetch.sh -u teamcity -p ******* registry-v2.forcity.io refs/tags/1.0.0-alpha
####################################################################
#1 : build branch ex (%teamcity.build.branch%)
#2 : repo git ex (sgareilforcity/template_ci)
#3 : access token git
#####################################################################
release="refs/heads/release-candidate"
image_name=$(cat artifacts/docker/artifact.yml | shyaml get-value image.name)
tag=$(sh utils/docker/extract_tag.sh $1)

echo "##teamcity[progressMessage 'pull requesting on Master of $1']"

if[ $1 = $release ]; then
    curl -b cookie -X post -H "Content-Type: application/json" -H "authToken: $3"  --data '{
      "title": "Amazing new feature",
      "body": "Please pull this in!",
      "head": "release-candidate",
      "base": "master"
    }' https://github.com/api/repos/$2/pulls
fi
exit 0