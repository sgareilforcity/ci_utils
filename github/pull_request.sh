#!/bin/bash
# pull request on github of release-candidate to master
# utils/github/pull_request.sh
# exemple :sh github/pull_request.sh refs/heads/release-candidate sgareilforcity/template_ci 200a-7a29f7f1-0d6b02339425f
####################################################################
#1 : build branch ex (%teamcity.build.branch%)
#2 : repo git ex (sgareilforcity/template_ci)
#3 : access token git
#####################################################################
release="refs/heads/release-candidate"
image_name=$(cat artifacts/docker/artifact.yml | shyaml get-value image.name)
tag=$(sh utils/docker/extract_tag.sh $1)
branch="$1"

echo "##teamcity[progressMessage 'pull requesting on Master of $branch']"

if [ $branch = $release ]; then
    curl -b cookie -X post -H "Content-Type: application/json" -H "authToken: $3"  --data '{
      "title": "Amazing new feature",
      "body": "Please pull this in!",
      "head": "release-candidate",
      "base": "master"
    }' https://github.com/api/repos/$2/pulls
fi
exit 0