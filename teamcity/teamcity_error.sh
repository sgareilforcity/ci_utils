#!/bin/bash
# 1 : result=$?
# 2 : new exit code
if [ "$1" != "0" ]; then
    echo "##teamcity[message text='Error while fetching image $imagename' errorDetails='Error while fetching image $imagename' status='WARN']"
    return $2
fi
return $1