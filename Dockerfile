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
DEBIAN_FRONTEND=noninteractive apt-get install -y -q --no-install-recommends apt-utils && \
DEBIAN_FRONTEND=noninteractive apt-get install -y -q locales sudo wget && \
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
# Ubuntu Packages and Libraries
################################################################################

RUN \
cd /home/$USER_ID/ && \
wget https://raw.githubusercontent.com/VeranosTech/vopt.conda/master/install_lib_ubuntu.sh && \
wget https://raw.githubusercontent.com/VeranosTech/vopt.conda/master/install_lib_optimizer.sh && \
/bin/bash install_lib_ubuntu.sh && \
/bin/bash install_lib_optimizer.sh && \
echo ""

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
ARG USER_ID=user
ENV USER_ID $USER_ID
ARG USER_PASS=userpass
ENV USER_PASS $USER_PASS
ARG USER_UID=1999
ENV USER_UID $USER_UID
ARG USER_GID=1999
ENV USER_GID $USER_GID
ARG HTTPS_COMMENT=#
ENV HTTPS_COMMENT $HTTPS_COMMENT

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
# Redis
################################################################################

USER root
COPY ./6379-docker.conf /etc/redis/6379.conf
ENV REDIS_PORT=6379
ENV REDIS_CONFIG_FILE=/etc/redis/6379.conf
ENV REDIS_LOG_FILE=/var/log/redis_6379.log
ENV REDIS_DATA_DIR=/var/lib/redis/6379
ENV REDIS_EXECUTABLE='command -v redis-server'
RUN \
mkdir -p /etc/redis && \
mkdir -p /var/log/redis && \
touch /var/log/redis_6379.log && \
mkdir -p /var/lib/redis/6379 && \
mkdir -p ~/temp && \
cd ~/temp && \
wget http://download.redis.io/redis-stable.tar.gz && \
tar xvzf redis-stable.tar.gz && \
cd redis-stable && \
make && \
make install && \
./utils/install_server.sh && \
rm -rf ~/temp

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
npm install -g npm@latest && \
npm install -g --unsafe-perm ijavascript && \
echo ""

################################################################################
# Python
################################################################################

# Anaconda config
ENV ANACONDA_PATH /home/$USER_ID/anaconda3
ENV ANACONDA_INSTALLER Anaconda3-5.0.1-Linux-x86_64.sh

# add path to root account
ENV PATH $ANACONDA_PATH/bin:$PATH

# Change user to $USER_ID
USER $USER_ID
WORKDIR /home/$USER_ID
ENV HOME /home/$USER_ID
ENV PATH $ANACONDA_PATH/bin:$PATH
RUN \
echo "export PATH=$PATH:$ANACONDA_PATH/bin" | tee -a /home/$USER_ID/.bashrc

# Anaconda install
RUN \
mkdir -p ~/download && cd ~/download && \
wget http://repo.continuum.io/archive/$ANACONDA_INSTALLER && \
/bin/bash ~/download/$ANACONDA_INSTALLER -b && \
conda update conda && \
conda update anaconda && \
conda update --all

################################################################################
# Python Packages
################################################################################

RUN \
cd /home/$USER_ID/ && \
wget https://raw.githubusercontent.com/VeranosTech/vopt.conda/master/create_env.sh && \
wget https://raw.githubusercontent.com/VeranosTech/vopt.conda/master/py3_ortools-6.4.4495-cp35-cp35m-manylinux1_x86_64.whl && \
wget https://raw.githubusercontent.com/VeranosTech/vopt.conda/master/install_pkg.sh && \
bash create_env.sh && \
bash install_pkg.sh && \
echo ""

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
chown -R $USER_ID:$USER_ID /home/$USER_ID/.ipython  && \
echo ""

# Add Tini. Tini operates as a process subreaper for jupyter. This prevents kernel crashes.
ADD https://github.com/krallin/tini/releases/download/v0.16.1/tini /usr/bin/tini
RUN chmod a+x /usr/bin/tini

ENTRYPOINT ["/usr/bin/tini", "--", "/bin/bash", ".docker-entrypoint.sh"]
