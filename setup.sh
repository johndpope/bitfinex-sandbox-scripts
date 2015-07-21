#!/bin/bash
set -e

U=$(whoami)
if [ "$U" != "docker" ]; then
	echo "Existing. You should run this script inside docker container!"
	exit 2
fi

branch=$1
port=$2
workDir="/home/docker"
token="d8f16a5bedcc0e09a4a41c8be2848c0b209e047b"
gitRepo="https://d8f16a5bedcc0e09a4a41c8be2848c0b209e047b@github.com/tetherto/bitfinex.git"

cd $workDir

# Clone project
git clone -b $branch $gitRepo app/

# Copy configs
sudo cp -r /docker/config/*.yml "$workDir/app/config"
cp /docker/server.rb "$workDir/app"
cp /docker/config/initializers/mailtrap.rb "$workDir/app/config/initializers"

# Install packages
cd "$workDir/app"
source /home/docker/.rvm/scripts/rvm
rvm use 2.0.0
gem update --system
gem install bundler
bundle install

# Start services
sudo service mysql start
sudo service redis-server start

# Start scripts
cd "$workDir/app"
rake db:setup
rake db:migrate
rake db:seed

# Send message to slack #automation channel
#slackmsg="$branch%3A+http%3A%2F%2Fsandbox.tether.to%3A$port"
#url="https://slack.com/api/chat.postMessage?token=xoxp-3357153413-3438545863-3802630863-95a1c2&channel=%23automation&text=$slackmsg&pretty=1"
#curl -X POST $url

#rails s
ruby server.rb
