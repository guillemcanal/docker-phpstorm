FROM debian:bullseye-slim

LABEL maintainer "Guillem Canal <guillem.canal1@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive \
	HOME=/home/user \
	LC_ALL=en_US.UTF-8 \
	DEBIAN_FRONTEND=noninteractive

RUN set -ex \
	&& apt-get update && apt-get install -y --no-install-recommends \
	# Utils
	procps \
	curl \
	ca-certificates \
	gosu \
	git tig \
	gnupg2 gpg-agent \
	bash zsh \
	sudo \
	locales \
	openssh-client \
	make \
	jq \
	# X11 dependencies
	dbus-x11 \
	libasound2 \
	libatk1.0-0 \
	libcairo2 \
	libcups2 \
	libexpat1 \
	libfontconfig1 \
	libfreetype6 \
	libgtk2.0-0 \
	libpango-1.0-0 \
	libx11-xcb1 \
	libxcomposite1 \
	libxcursor1 \
	libxdamage1 \
	libxext6 \
	libxfixes3 \
	libxi6 \
	libxrandr2 \
	libxrender1 \
	libxss1 \
	libxtst6 \
	software-properties-common \
	x11-xserver-utils \
	# To investigate
	libnss3 \
	# Set locale
	&& echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
	&& locale-gen en_US.UTF-8 \
	&& dpkg-reconfigure locales \
	&& /usr/sbin/update-locale LANG=en_US.UTF-8 \
	# Docker cli & docker-compose (for docker in docker purposes)
	&& curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
	&& add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian buster stable" \
	&& apt-get update && apt-get install --no-install-recommends -y docker-ce-cli docker-compose \
	# Create default user
	&& useradd --create-home --home-dir $HOME --shell /bin/zsh user \
	&& chown -R user:user $HOME \
	&& echo "user ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/user \
	# Docker group
	&& groupadd -g 999 docker \
	&& usermod -aG docker user \
	# Custom stuff
	&& ln -sf /bin/zsh /bin/sh

COPY rootfs /

# Install PHPStorm
RUN mkdir -p /opt \
	&& cd /opt \
	&& export PHPSTORM_VERSION=$(phpstorm-latest-version) \
	&& curl -OL https://download.jetbrains.com/webide/PhpStorm-${PHPSTORM_VERSION}.tar.gz \
	&& tar -xf PhpStorm-${PHPSTORM_VERSION}.tar.gz \
	&& rm PhpStorm-${PHPSTORM_VERSION}.tar.gz \
	&& mv PhpStorm-* PhpStorm \
	&& ln -s /opt/PhpStorm/bin/phpstorm.sh /usr/local/bin/phpstorm

RUN apt-get install -y chromium

ENTRYPOINT ["docker-entrypoint"]

CMD ["phpstorm"]
