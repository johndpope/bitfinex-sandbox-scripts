# Sandbox deployment tool

In this documentation all examples uses `master` branch. Replace it with any branch you need.

Control panel: http://sandbox.tether.to:9000

### Getting started
Clone automation project to user home directory
``` bash
> cd ~
> git clone git@github.com:WebLogicNow/automation.git
```
Then you should copy your `id_rsa` file to `~/automation/docker` dir.
Notice, you need to copy id_rsa that have access to tether github repo!
``` bash
> cp ~/.ssh/id_rsa ~/automation/docker
```
#### Configs.
Also, you need to copy all rails *.yml configs to `~/automation/docker/config` directory.

### Usage
Next command will run container with master branch at any free port >25000. So you do not
need to search for free port manually.

``` bash
> cd ~/automation/docker
> sudo ./deploy.sh master
# Starting container with branch master at port 25000
# cee0acba895419bc7b37fe163b71f5a6c3680be5fe26a11dbb176bf6707fbff0
```
Once deploy is finished(around 5 minutes) you will receive message in Slack #automation channel with link to container.

`NOTICE: Wait 30sec after slack message received, rails will start development server.`

### Removing containers
When code branch is tested developer should stop and delete testing container
``` bash
> sudo docker stop master
> sudo docker rm master
```
## Config editing
Basically there is two ways:
- You can change config before you run ./deploy script. This method also affects all future containers configs.   
- Change files directly in running container.   

### Changing configs in running container
Login to container and change files.  

`NOTICE: You do not need reload rails server to apply configs. Sandboxing tool will make it for you) So all you need is to save file.`

``` bash
> sudo docker exec -it master bash
> cd ~/app/config
> vim application.yml
> exit
```

## Exploring containers data
When you need to expore log, db or some other data you should use next command.
It will login you to running container.
``` bash
> sudo docker exec -it master bash
```

Once you are logged you can start exploring:

``` bash
> cd ~
> tailf app/log/development.log
> exit
````
### Exploring deployment process
In case when you need to see full process of building container you can start container from commandline:

``` bash
> sudo docker run -p 25555:3000 -i -t --rm -v /home/username/automation/docker:/docker andrey/tether master 25555
```
Keep in mind to change 25555 twice and change full path to docker automation dir.

### Building an image.
Waring: don't build image yourself - contact maintainer.
So, when new requirements added to projects and OS add changes to Dockerfile
and then build it:

``` bash
> cd ~/automation/docker
> sudo docker build -t andrey/tether .
```

# FAQ
How to attach to running container: sudo docker attach master   
How to exit from attached shell and not brake flow: Ctrl+p + Ctrl+q   

### Enjoy)  
Maintainer: andrey.b@tether.to
