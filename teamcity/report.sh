#!/bin/bash
# 1 : key
# 2 : type
# 3 : build_id
# 4 : order
curl -X post -H "Content-Type: application/json"  --data '{
      "key": "%build.owner.github%/%build.repository.github%",
      "type": "%teamcity.project.id%",
      "build_id": "%teamcity.build.id%",
      "order": "$4"
    }' http://teamcity.forcity.io:5000/api/report
result=$?
sh utils/teamcity/teamcity_error.sh $result 0