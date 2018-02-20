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

* Mac with **Docker for Mac**

  * https://store.docker.com/editions/community/docker-ce-desktop-mac

* Windows with **Docker for Windows**

  * https://store.docker.com/editions/community/docker-ce-desktop-windows

* Mac/Windows with Docker-Toolbox

  * https://docs.docker.com/toolbox/overview/
  
  On windows, you **must include git** when install docker toolbox.
  
  The installation script creates a new VirtualBox machine named **"vopt"** 
  when you use Docker-Toolbox on Mac/Windows.
  Check the ip address of the **"vopt"** machine using ``docker-machine ls`` before connect the docker container.


Pull (Download)
---------------

You can download the pre-built image from docker hub using `docker pull` command.
```
$ docker pull veranostech/vopt
```


Build
-----

On Linux, Mac with Docker for Mac, or Windows with Docker for Windows, 
the build script just builds a docker image named `vopt`.

On Mac/Windows with Docker-Toolbox, the build script creates a new docker-machine named `vopt` 
and builds a docker image named `veranostech/vopt` on it.

* Linux, Mac with Docker for Mac, or Windows with Docker for Windows
  ```
  $ source build.sh
  ```
  
* Mac with Docker Toolbox
  ```
  $ source build_dockertoolbox_mac.sh
  ```

* Windows with Docker Toolbox (in Docker Quickstart Terminal)
  ```
  $ source build_dockertoolbox_windows.sh
  ```
  

Run
---

* Linux, Mac with Docker for Mac, or Windows with Docker for Windows
  ```
  $ docker run --name vopt --rm -Pit -p 8222:22 veranostech/vopt
  ```

* Mac with Docker Toolbox
  ```
  $ docker-machine start vopt
  $ eval $(docker-machine env vopt)
  $ docker run --name vopt --rm -Pit -p 8222:22 veranostech/vopt
  ```

* Windows with Docker Toolbox (in Docker Quickstart Terminal)
  ```
  $ docker-machine start vopt
  $ eval $(docker-machine env vopt)
  $ docker run --name vopt --rm -Pit -p 8222:22 veranostech/vopt
  ```
