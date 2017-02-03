#!/bin/bash
#verify args
if [ -z $1 ]; then
     echo "1 : branch  full name to extract (ex : refs/heads/master)"
     exit 418
fi

#parse args to extraction
version=$(echo $1 | sed "s,/refs,refs,g" | sed "s,refs/heads/,,g" | sed "s,refs/tags/,,g")

#master args exception
if [ $version = "master" ]; then
    if [ -z $2 ]; then
       version= "latest"
    fi
    version=$2
fi

#return the extraction
echo $version

exit 0