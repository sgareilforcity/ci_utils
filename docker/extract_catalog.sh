#!/bin/bash
#verify args
#1 : catalog name if not filed

if[ -n catalog];then
    catalog=$(cat catalog)
else
    if[ -n $1 ];then
        catalog=$1
    else
        echo "catalog of image not found"
        exit 418
    fi
fi

exit 0