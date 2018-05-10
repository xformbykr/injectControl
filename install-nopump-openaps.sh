# commands for installing openAPS and oref0 when you have no pump
sudo apt-get -o  Acquire::ForceIPv4=true install -y git python python-dev software-properties-common python-numpy python-pip nodejs-legacy npm watchdog vim locate jq lm-sensors
sudo pip install git+https://github.com/openaps/openaps.git@nogit
sudo openaps-install-udev-rules
sudo activate-global-python-argcomplete
sudo npm install -g json oref0
sudo pip install -U openaps
sudo pip install -U openaps-contrib
sudo activate-global-python-argcomplete
sudo npm install -g json oref0
openaps --version
git config --global user.email "jrd@example.com"
git config --global user.name "jrd"
openaps init myOpenAPS
