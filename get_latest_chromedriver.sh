#!/bin/bash
latest_chromedriver=$(wget -qO- http://chromedriver.storage.googleapis.com/LATEST_RELEASE)
#echo "LATEST:"
version_to_get="$latest_chromedriver"
wget https://chromedriver.storage.googleapis.com/$version_to_get/chromedriver_linux64.zip
unzip chromedriver_linux64.zip 
sudo cp chromedriver /usr/bin/chromedriver
sudo chown root /usr/bin/chromedriver
sudo chmod +x /usr/bin/chromedriver
sudo chmod 755 /usr/bin/chromedriver
rm chromedriver*
