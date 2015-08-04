# On Mac OS hosts please modify VirtualBox rules for each port
# you want to access.
# Examples:
# VBoxManage modifyvm "boot2docker-vm" --natpf1 "guestnginx,tcp,,80,,80"
# VBoxManage modifyvm "boot2docker-vm" --natpf1 "guestnginx,tcp,,3000,,3000"
# and that restart boot2docker.
# Also, when boot2docker is running, you will be not able to access modified ports,
# in our case it is 80 and 3000 port numbers.
FROM ubuntu
MAINTAINER Andrey Bubis "firstrow@gmail.com"

# Basics
RUN apt-get update
RUN apt-get install -y openssh-server openssh-client git curl vim build-essential

# Projects dependencies
RUN apt-get install -y redis-server mysql-client mysql-server libmysqlclient-dev nodejs-legacy npm ruby-dev imagemagick libmagickwand-dev libmagickcore-dev 

# Create user
RUN apt-get -y install sudo
RUN useradd docker && echo "docker:docker" | chpasswd && adduser docker sudo
RUN mkdir -p /home/docker && chown -R docker:docker /home/docker

RUN echo "root ALL=(ALL) ALL" > /etc/sudoers
RUN echo "docker ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers

USER docker

# Install RVM, Ruby, and Bundler
RUN \curl -sSL https://rvm.io/mpapis.asc | gpg --import -
RUN \curl -L https://get.rvm.io | bash -s stable
RUN /bin/bash -l -c "sudo rvm requirements"
RUN /bin/bash -l -c "source ~/.rvm/scripts/rvm"
RUN /bin/bash -l -c "rvm install 2.0.0"
RUN /bin/bash -l -c "rvm use 2.0.0"
RUN /bin/bash -l -c "gem install rbczmq"

RUN /bin/bash -l -c "mkdir /home/docker/.ssh"
RUN echo "Host github.com\n\tStrictHostKeyChecking no\n" >> /home/docker/.ssh/config
RUN echo "Host bitbucket.org\n\tStrictHostKeyChecking no\n" >> /home/docker/.ssh/config

EXPOSE 3000
EXPOSE 3306
ENTRYPOINT ["/docker/setup.sh"]
