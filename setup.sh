#!/bin/bash
echo "initiate environnement test"
sudo apt-get update -yqq
sudo apt-get install python3-dev -yqq
sudo apt-get install libpython-dev -yqq
sudo apt-get install postgresql -yqq
sudo pip install -r requirements.txt
echo "------------------------------"
