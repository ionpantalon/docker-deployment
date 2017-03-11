## Deploy on a Docker container 
This is a basic demo showing how to deploy a project from Git to a running Docker container. 

## Installation
```sh
$ git clone https://github.com/ionpantalon/docker_deployment.git
```
### Create the docker container
Get the version of Docker
```sh
$ docker version
```
Let's start by creating a Docker image from the Dockerfile. If you are not familiar with Docker or never used it before have a look at [Docker docs](https://www.docker.com/)
```sh
$ docker build -t 'my-image-name' .
```
Test if the image was created using 

```sh
$ docker images
```
Create a container using my-image-name 

```sh
$ docker run -dt --name dep_test my-image-name
```
- -t,--tty Allocate a pseudo-TTY
- -d, --detach Run container in background and print container ID

To check if the container is running and to get information about it like the name, size,etc, 'docker ps' can be used
```sh
$ docker ps or docker ps -a
```
### Use SSH to connect to Git
Check if SSH is installed 
```sh
$ ssh -V
```
Check the .ssh dir 
```sh
$  ls -a ~/.ssh 
```
To generate new keys 
```sh
$ ssh-keygen 
```
To start the agent 
```sh
$ ssh-agent /bin/bash
```
Next let's load the new generated keys on the ssh-agent
```sh
$ ssh-add ~/.ssh/id_rsa 
``` 
Check if it was succesfully loaded
```sh
$ ssh-add -l 
``` 
Next copy the content of .ssh/id_rsa.pub and paste into SSH Key field on your git account 

To test it clone the project using
```sh
$ git clone git@bitbucket.org :< accountname>/<reponame>.git
```
### deploy.ssh
Edit the variables to the appropiate paths and settings to match your project configuration 

To deploy you can run it manually using 
```sh
$ sudo ./deploy.sh
```

Or you can configure a web hook to deploy on certain events. When one of those events is triggered, a HTTP POST payload to the webhook's configured URL is sent. For more information about how to set up a web hook check [Git webhooks](https://developer.github.com/webhooks/)

## Test
To test if the project was succesfully deployed login on the container and check the deployment path
```sh
$ docker exec -ti dep_test /bin/bash
```
- -t, --tty Allocate a pseudo-TTY
- -i, --interactive Keep STDIN open even if not attached








