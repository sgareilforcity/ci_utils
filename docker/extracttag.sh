#!/bin/bash
#verify args
if [ -z $1 ]; then
     echo "1 : branch  full name to extract (ex : refs/heads/master)"
     exit 418
else
    if [ -z $2 ]; then
        echo "latest"
        exit 0
    fi
fi

#parse args to extraction
version=$(echo $1 | sed "s,refs/heads/,,g" | sed "s,refs/tags/,,g")

#master args exception
if [ $version = "master" ]; then
    echo $2
    exit 0
fi

#return the extraction
echo $version

exit 0