# Sandbox deployment tool

In this documentation all examples uses `master` branch. Replace it with any branch you need.
Make sure that BFX-92-sandbox branch is merged to your working branch before deployment.

### Getting started
Clone automation project to user home directory on sandbox server:

``` bash
> cd ~
> git clone git@github.com:tetherto/bitfinex-sandbox-scripts.git
```

Set GITHUB_TOKEN environment variable in your shell. You can do it by adding `export GITHUB_TOKEN=xxxxxxx` to your .profile (or .bash_profile or .zshrc or what shell are you using). You can generate a token (with default permissions) here - https://github.com/settings/tokens

#### Configs
You need to copy all `*.yml` configs to `~/bitfinex-sandbox-scripts/config` directory (in case you've cloned into `~/bitfinex-sandbox-scripts`). If you don't have any configs feel free to grab them from `/home/oleh/docker/config`.

### Usage
Following command will run container with master branch at any free port >25000:

``` bash
> cd ~/bitfinex-sandbox-scripts
> sudo ./deploy.sh master
# Starting container with branch master at port 25000
# cee0acba895419bc7b37fe163b71f5a6c3680be5fe26a11dbb176bf6707fbff0
```

### Removing containers
When code branch is tested developer should stop and delete testing container
``` bash
> sudo docker stop master
> sudo docker rm master
```

## Exploring containers data
When you need to explore logs or some other data you should use following command, it will login you to running container's shell:

``` bash
> sudo docker exec -it master bash
```

For example, to get to rails console of the container you have to run:

``` bash
> sudo docker exec -it master bash
> su docker
> bash --login
> cd ~/app/
> rails console
````

## Connecting to MySQL
Sandbox DB can be accessed by connecting to the port shown by `sudo docker ps` (>= 33000) with following credentials:

```
username: remote
password: AP5FZnadm029n
host: sandbox.bitfinex.com
port: see `sudo docker ps` response
```

### Attach to running container (to see the deployment process's errors). To exit from attached shell and do not brake flow: Ctrl+P, Ctrl+Q

``` bash
> sudo docker attach master
```

### Building an image
Waring: don't build image yourself - contact maintainer (Oleh or Andrey B.)

``` bash
> sudo docker build -t andrey/bitfinex .
```
