FROM ubuntu:16.04
MAINTAINER "Joel Kim" joel.kim@veranostech.com

# Replace sh with bash
RUN cd /bin && rm sh && ln -s bash sh

# Ubuntu repository in Korea
ENV REPO http://kr.archive.ubuntu.com/ubuntu/
# ENV REPO http://ftp.neowiz.com/ubuntu/
# in China,
# ENV REPO http://mirrors.aliyun.com/ubuntu/

RUN \
echo "deb $REPO xenial main"                                          | tee    /etc/apt/sources.list && \
echo "deb $REPO xenial-updates main"                                  | tee -a /etc/apt/sources.list && \
echo "deb $REPO xenial universe"                                      | tee -a /etc/apt/sources.list && \
echo "deb $REPO xenial-updates universe"                              | tee -a /etc/apt/sources.list && \
echo "deb $REPO xenial multiverse"                                    | tee -a /etc/apt/sources.list && \
echo "deb $REPO xenial-updates multiverse"                            | tee -a /etc/apt/sources.list && \
echo "deb $REPO xenial-backports main restricted universe multiverse" | tee -a /etc/apt/sources.list && \
echo "deb $REPO xenial-security main"                                 | tee -a /etc/apt/sources.list && \
echo "deb $REPO xenial-security universe"                             | tee -a /etc/apt/sources.list && \
echo "deb $REPO xenial-security multiverse"                           | tee -a /etc/apt/sources.list && \
echo

# Set environment
RUN \
rm -rf /var/lib/apt/lists/* && \
rm -rf /var/lib/apt/lists/partial/* && \
DEBIAN_FRONTEND=noninteractive apt-get update -y -q && \
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -q && \
DEBIAN_FRONTEND=noninteractive apt-get install -y -q locales && \
locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_COLLATE C
ENV TERM xterm
ENV HOME /root
ENV TZ Asia/Seoul

# Config for unicode input/output
RUN \
echo "set input-meta on" >> ~/.inputrc && \
echo "set output-meta on" >> ~/.inputrc && \
echo "set convert-meta off" >> ~/.inputrc && \
echo

# Console colors
RUN echo "export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:'" | tee -a /root/.bashrc

################################################################################
# Basic Softwares
################################################################################

# Ubuntu packages
RUN \
DEBIAN_FRONTEND=noninteractive apt-get install -y -q \
apt-file sudo man ed vim emacs24 curl wget zip unzip bzip2 git mercurial subversion htop tmux screen ncdu dos2unix gettext rsyslog net-tools \
gdebi-core make cmake build-essential gfortran libtool autoconf automake pkg-config \
software-properties-common supervisor \
libboost-all-dev libclang1 libclang-dev swig libcurl4-gnutls-dev libspatialindex-dev libgeos-dev libgdal-dev libspatialindex-dev \
libgoogle-glog-dev libprotobuf-dev protobuf-compiler libgflags-dev libgtest-dev libiomp-dev libleveldb-dev liblmdb-dev \
uuid-dev libjpeg-dev libpq-dev libpgm-dev libpng-dev libpng12-dev libpng++-dev libopencv-dev libtiff5-dev libevent-dev \
openssh-server apparmor libapparmor1 libssh2-1-dev openssl libssl-dev \
nginx memcached postgresql postgresql-contrib \
default-jre default-jdk \
coinor-clp coinor-libclp-dev coinor-cbc coinor-libcbc-dev coinor-libcoinmp-dev coinor-libcbc-dev coinor-libcgl-dev coinor-csdp coinor-libdylp-dev coinor-libflopc++-dev coinor-libipopt-dev coinor-libosi-dev coinor-libsymphony-dev coinor-libvol-dev coinor-libcoinutils-dev \
&& DEBIAN_FRONTEND=noninteractive apt-get autoremove \
&& DEBIAN_FRONTEND=noninteractive apt-get clean

################################################################################
# GLPK
################################################################################
RUN /
wget ftp://ftp.gnu.org/gnu/glpk/glpk-4.62.tar.gz && \
tar -xzvf glpk-4.62.tar.gz && \
cd glpk-4.62 && \
./configure && \
make && \
make install

ENV GLPK_LIB_DIR /usr/local/lib
ENV GLPK_INC_DIR=/usr/local/include
ENV BUILD_GLPK 1

################################################################################
# SSH service
################################################################################

RUN \
mkdir -p /var/run/sshd  && \
sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
ENV NOTVISIBLE "in users profile"
RUN \
sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
echo "export VISIBLE=now" >> /etc/profile && \
echo -e  'y\n' | /usr/bin/ssh-keygen -q -t rsa -f /etc/ssh/ssh_host_rsa_key -C '' -N ''  && \
echo -e  'y\n' | /usr/bin/ssh-keygen -q -t rsa -f /etc/ssh/ssh_host_dsa_key -C '' -N ''

EXPOSE 22

################################################################################
# User Account
################################################################################

# Create user
ENV USER_ID user
ENV USER_PASS userpass
ENV USER_UID 1999
ENV USER_GID 1999
ENV HTTPS_COMMENT #

RUN \
groupadd --system -r $USER_ID -g $USER_GID && \
adduser --system --uid=$USER_UID --gid=$USER_GID --home /home/$USER_ID --shell /bin/bash $USER_ID && \
echo $USER_ID:$USER_PASS | chpasswd && \
cp /etc/skel/.bashrc /home/$USER_ID/.bashrc && source /home/$USER_ID/.bashrc && \
cp /etc/skel/.profile /home/$USER_ID/.profile && source /home/$USER_ID/.profile && \
chown $USER_ID:$USER_ID /home/$USER_ID/.*  && \
adduser $USER_ID sudo

# login profile
COPY .bash_profile /home/$USER_ID/
RUN chown $USER_ID:$USER_ID /home/$USER_ID/.*

USER $USER_ID
RUN \
echo "export PATH=$PATH:/home/$USER_ID/anaconda3/bin" | tee -a /home/$USER_ID/.bashrc  && \
echo "export LANG='en_US.UTF-8'" | tee -a /home/$USER_ID/.bashrc  && \
echo "export LANGUAGE='en_US.UTF-8'" | tee -a /home/$USER_ID/.bashrc  && \
echo "export LC_ALL='en_US.UTF-8'" | tee -a /home/$USER_ID/.bashrc  && \
echo "export TZ='Asia/Seoul'" | tee -a /home/$USER_ID/.bashrc  && \
echo "export TERM='xterm'" | tee -a /home/$USER_ID/.bashrc  && \
echo "set input-meta on" >> /home/$USER_ID/.inputrc && \
echo "set output-meta on" >> /home/$USER_ID/.inputrc && \
echo "set convert-meta off" >> /home/$USER_ID/.inputrc && \
echo "export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:'" | tee -a /home/$USER_ID/.bashrc


################################################################################
# Python
################################################################################

# add path to root account
USER root
ENV PATH /home/$USER_ID/anaconda3/bin:$PATH

# Change user to $USER_ID
USER $USER_ID
WORKDIR /home/$USER_ID
ENV HOME /home/$USER_ID
ENV PATH /home/$USER_ID/anaconda3/bin:$PATH

# Anaconda3 4.4.0
ENV ANACONDA Anaconda3-4.4.0-Linux-x86_64.sh
RUN \
mkdir -p ~/download && cd ~/download && \
wget http://repo.continuum.io/archive/$ANACONDA && \
/bin/bash ~/download/$ANACONDA -b && \
conda update conda

################################################################################
# Python Packages (vopt.conda environment)
################################################################################

RUN \
cd /home/$USER_ID/ && \
wget https://raw.githubusercontent.com/VeranosTech/vopt.conda/master/create_env_linux_1.sh && \
wget https://raw.githubusercontent.com/VeranosTech/vopt.conda/master/create_env_linux_2.sh && \
bash create_env_linux_1.sh && \
bash create_env_linux_2.sh

################################################################################
# PostgreSql
################################################################################

USER root
ADD "./.postgres_db_setup.sql" "/home/$USER_ID/"

EXPOSE 5432

################################################################################
# Redis
################################################################################

USER root
RUN \
mkdir -p ~/temp && \
cd ~/temp && \
wget http://download.redis.io/redis-stable.tar.gz && \
tar xvzf redis-stable.tar.gz && \
cd redis-stable && \
make && \
make install && \
mkdir -p /etc/redis && \
mkdir -p /var/redis && \
mkdir -p /var/redis/6379 && \
cp utils/redis_init_script /etc/init.d/redis_6379 && \
rm -rf ~/temp
COPY ./6379-docker.conf /etc/redis/6379.conf

EXPOSE 6379

################################################################################
# MongoDb
################################################################################

USER root
RUN \
mkdir -p /data/db && \
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 && \
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list && \
DEBIAN_FRONTEND=noninteractive apt-get update -y -q && \
DEBIAN_FRONTEND=noninteractive apt-get install -y -q mongodb-org

EXPOSE 27017 28017


################################################################################
# Node.js
################################################################################

USER root
RUN \
curl -sL https://deb.nodesource.com/setup_6.x -o nodesource_setup.sh && \
/bin/bash nodesource_setup.sh && \
DEBIAN_FRONTEND=noninteractive apt-get install -y -q nodejs && \
rm -rf nodesource_setup.sh && \
npm install npm@latest -g


################################################################################
# Supervisor Settings
################################################################################

USER root
COPY supervisord.conf /etc/supervisor/supervisord.conf
RUN \
sed -i "s/USER_ID/$USER_ID/g" /etc/supervisor/supervisord.conf  && \
mkdir -p /var/log/supervisor  && \
chown $USER_ID:$USER_ID /var/log/supervisor


################################################################################
# Run
################################################################################

ADD "./.docker-entrypoint.sh" "/home/$USER_ID/"

# fix ownership
USER root

RUN \
chown syslog:syslog /etc/rsyslog.conf && \
chown $USER_ID:$USER_ID /home/$USER_ID/.*  && \
chown $USER_ID:$USER_ID /home/$USER_ID/*  && \
echo

ENTRYPOINT ["/bin/bash", ".docker-entrypoint.sh"]
