#!/bin/bash
result=$?
if [ "$result" != "0" ]; then
    echo "##teamcity[message text='Error while fetching image $imagename' errorDetails='Error while fetching image $imagename' status='WARN']"
fi