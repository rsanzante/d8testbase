#!/bin/sh

# Stop on any error.
set -e

# Alter system configuration.
##############################
# Increase memory_limit.
echo "\n\nAdding custom PHP ini"
echo     "---------------------"
echo -e "memory_limit = 512M\n" > /usr/local/etc/php/conf.d/90-md.ini


# Install Selenium.
###################
SELENIUM_VERSION="3.5"
SELENIUM_VERSION_FULL="3.5.3"

echo "\n\nInstall Selenium $SELENIUM_VERSION_FULL"
echo "-----------------------"
cd /tmp
wget "http://selenium-release.storage.googleapis.com/$SELENIUM_VERSION/selenium-server-standalone-$SELENIUM_VERSION_FULL.jar"
mv selenium-server-standalone-$SELENIUM_VERSION_FULL.jar /usr/local/bin/
[ -e /usr/local/bin/selenium-server-standalone.jar ] && rm /usr/local/bin/selenium-server-standalone.jar
ln -s /usr/local/bin/selenium-server-standalone-$SELENIUM_VERSION_FULL.jar /usr/local/bin/selenium-server-standalone.jar
java -jar /usr/local/bin/selenium-server-standalone.jar --version


# Install Google Chrome.
########################
echo "\n\nInstall Google Chrome"
echo "---------------------"
# Add Google public key to apt
wget -q -O - "https://dl-ssl.google.com/linux/linux_signing_key.pub" | apt-key add -
# Add Google to the apt-get source list
echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' > /etc/apt/sources.list.d/chrome.list
apt-get update
apt-get -y install google-chrome-stable
google-chrome --version


# Install Chrome Driver.
########################
CHROMEDRIVER_VERSION="2.34"
echo "\n\nInstall Selenium $CHROMEDRIVER_VERSION"
echo "---------------------"
# Chrome Driver
cd /tmp
wget "https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip"
unzip chromedriver_linux64.zip
[ -e /usr/local/bin/chromedriver ] && rm /usr/local/bin/chromedriver
mv chromedriver /usr/local/bin
chromedriver --version

# Install debug tools.
######################
echo "\n\nInstall some debug tools"
echo "------------------------"
apt-get install -y telnet vim lynx elinks


# Link webapp docroot to /var/www/html.
ln -s /var/webapp/docroot /var/www/html


