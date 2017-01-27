#!/bin/bash
if [ -d "%teamcity.build.checkoutDir%/ci-test" ]; then
sudo easy_install -U pip
sudo pip install --upgrade pip
sudo pip install docker-compose
echo "Working in %teamcity.build.checkoutDir%"
dependency_branch=$(echo "%dep.Lumis_Lumis.teamcity.build.branch%" | sed "s,refs/heads/,,g" | sed "s,refs/tags/,,g")
if [ "$dependency_branch" == "master" ]; then
     tags="build-%build.number%"
else
     version=$(echo "$dependency_branch" | sed "s,release/,,g" | sed "s,/,-,g")
     tags="$version"
fi
echo "Using image tags: $tags"
cd %teamcity.build.checkoutDir%/ci-test
chmod +x ./run_tests.sh
./run_tests.sh $tags
fi