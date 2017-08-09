Docker Image for vopt
=====================

Docker image for vopt Optimization

You can download this image from https://hub.docker.com/r/veranostech/vopt/


Prerequisite
------------

* Linux

  Install docker. for example on ubuntu
  
  ```
  $ sudo apt install docker
  ```
  
* Mac/Windows

  Install **docker-toolbox**. 
  **NOT** docker-for-windows or docker-for-mac.
  
  * https://www.docker.com/products/docker-toolbox
  
  On windows, you **must include git** when install docker toolbox.




Pull (Download)
---------------

You can download the pre-built image from docker hub using `docker pull` command.


1. Create a separated docker machine named `vopt`
	```
	$ docker-machine create -d virtualbox vopt
	```

2. Start the docker-machine `vopt`
	```
	$ docker-machine start vopt
	$ eval $(docker-machine env vopt)
	```

3. Download docker image
	```
	$ docker pull veranostech/vopt
	```


Build
-----

On Linux, the build script just builds a docker image named `vopt`.

On Mac/Windows, the build script creates a new docker-machine named `vopt` 
and builds a docker image named `veranostech/vopt` on it.

* Linux
	```
	$ source build_linux.sh
	```
	
* Mac
	```
	$ source build_mac.sh
	```

* Windows (in Git-Bash or CygWin)
	```
	$ source build_windows.sh
	```
	

Run
---

* Linux
	```
	$ docker run -Pit --name vopt veranostech/vopt
	```
	
* Mac
	```
	$ docker-machine start vopt
	$ eval $(docker-machine env vopt)
	$ docker run -Pit --name vopt veranostech/vopt
	```

* Windows (in Docker Quickstart Terminal)
	```
	$ docker-machine start vopt
	$ eval $(docker-machine env vopt)
	$ docker run -Pit --name vopt veranostech/vopt
	```
