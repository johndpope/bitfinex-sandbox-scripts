#!/bin/bash
# Run this script as sudo with -E flag to export environment variables
# Example:
# sudo -E ./deploy.sh branch_name

if [ "$(whoami)" != "root" ]; then
    echo "Run this script with sudo."
    exit 1
fi

if [ -z "$GITHUB_TOKEN" ]; then
    echo "Please create a token at https://github.com/settings/tokens and set up a GITHUB_TOKEN variable!"
    exit 1
fi
 
BASE=25000
INCREMENT=1
SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`
branch=$1
 
port=$BASE
isfree=$(netstat -tapln | grep $port)
 
# Find free port starting from $BASE
while [[ -n "$isfree" ]]; do
  port=$[port+INCREMENT]
  isfree=$(netstat -tapln | grep $port)
done

echo "Starting container with branch $branch at port $port"
docker stop $branch > /dev/null 2>&1
docker rm $branch > /dev/null 2>&1

# Run container
docker run -p $port:3000 -e GITHUB_TOKEN -i -t --name $branch -v $SCRIPTPATH:/docker andrey/bitfinex $branch $port
#docker run -p $port:3000 -i -t --rm -v $SCRIPTPATH:/docker andrey/bitfinex $branch $port 
