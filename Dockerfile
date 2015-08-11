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
RUN apt-get install -y redis-server mysql-client mysql-server libmysqlclient-dev nodejs-legacy npm ruby-dev imagemagick libmagickwand-dev libmagickcore-dev libzmq-dev

# Update mysql config
RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

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
RUN /bin/bash -l -c "gem install --no-document rake i18n multi_json activesupport builder activemodel erubis journey rack rack-cache rack-test hike tilt sprockets actionpack mime-types polyglot treetop mail actionmailer arel tzinfo activerecord activeresource addressable json mini_portile nokogiri aws-sdk-v1 aws-sdk bcrypt bcrypt-ruby bluecloth choice climate_control clockwork cocaine coderay coffee-script-source execjs coffee-script rack-ssl rdoc thor railties coffee-rails commonjs connection_pool currencies countries country_select daemons orm_adapter responders thread_safe warden devise eventmachine em-synchrony exception_notification ezcrypto multipart-post faraday websocket-extensions websocket-driver faye-websocket gpgme hiredis multi_xml httparty it jquery-rails jquery-validation-rails jwt kaminari keepass-password-generator kgio language_list less less-rails less-rails-bootstrap libv8 mail-gpg metaclass method_source mimemagic minitest mocha mono_logger multipass mysql2 newrelic_rpm nifty-generators oj paperclip rbczmq pigato postmark postmark-rails power_assert slop pry rack-protection rack-timeout railroady rails ruby-graphviz rails-erd raindrops redis redis-namespace redis-objects ref sinatra vegas resque ringcaptcha rmagick rotp sass sass-rails settingslogic sqlite3 test-unit therubyracer thin typus uglifier unicorn utf8-cleaner; exit 0"

RUN /bin/bash -l -c "mkdir /home/docker/.ssh"
RUN echo "Host github.com\n\tStrictHostKeyChecking no\n" >> /home/docker/.ssh/config
RUN echo "Host bitbucket.org\n\tStrictHostKeyChecking no\n" >> /home/docker/.ssh/config

EXPOSE 3000 3306
ENTRYPOINT ["/docker/setup.sh"]
