FROM jenkins:latest

USER root
RUN echo "deb http://apt.dockerproject.org/repo debian-jessie main" \
	 > /etc/apt/sources.list.d/docker.list \
	 && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
	    --recv-keys 58118E89F3A912897C070ADBF76221572C52609D \
	 && apt-get update \
	 && apt-get install -y apt-transport-https \
	 && apt-get install -y sudo \
	 && apt-get install -y docker-engine \
	 && rm -rf /var/lib/apt/lists/*
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

RUN sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" \
	 -o /usr/local/bin/docker-compose \
	 && chmod +x /usr/local/bin/docker-compose

USER jenkins
RUN /usr/local/bin/install-plugins.sh scm-api \
    && /usr/local/bin/install-plugins.sh git-client \
    && /usr/local/bin/install-plugins.sh git \
    && /usr/local/bin/install-plugins.sh greenballs
