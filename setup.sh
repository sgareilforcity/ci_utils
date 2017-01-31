#!/bin/bash
echo "initiate environnement test"
sudo apt-get install software-properties-common python-software-properties -yqq
#sudo add-apt-repository ppa:fkrull/deadsnakes
sudo apt-get update -yqq
sudo apt-cache show python
sudo apt-get install python2.7 -yqq
sudo apt-get install libpython-dev -yqq
sudo apt-cache show python3
sudo apt-get install python3=3.5.1* -yqq
sudo apt-get install postgresql -yqq
sudo pip install -r requirements.txt
echo "------------------------------"
