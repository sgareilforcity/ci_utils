#!/bin/bash
# 1 : result=$?
# 2 : new exit code
# 3 : status
if [ -z $1 ] ; then
   echo "# 1 : result=$?"
   echo "# 2 : new exit code"
   echo "# 3 : status"
   exit 418
else
    status=$3
    if [ -z $status ] ; then
       status='WARN'
    fi
    if [ "$1" != "0" ]; then
        echo "##teamcity[message text='Error while fetching image $imagename' errorDetails='Error while fetching image $imagename' status='$status']"
        return $2
    fi
    return $1
fi