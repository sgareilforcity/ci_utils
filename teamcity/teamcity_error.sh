#!/bin/bash
# 1 : result=$?
# 2 : new exit code
# 3 : status
if[ -z $3 ]; then
    status=$3
else
    status='WARN'
fi
if [ "$1" != "0" ]; then
    echo "##teamcity[message text='Error while fetching image $imagename' errorDetails='Error while fetching image $imagename' status='$status']"
    return $2
fi
return $1