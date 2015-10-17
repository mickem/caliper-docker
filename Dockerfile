FROM    centos:centos6

RUN     rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
RUN     yum install -y textutils tar unzip util-linux git
RUN     yum install -y npm

ENV CALIPER_DOWNLOAD_URL https://github.com/rrohrer/Caliper/archive/v0.2.0.tar.gz
ENV CALIPER_DOWNLOAD_SHA1 3b169195c89507a3696e9d0e584d0aaf246adc29
ENV CALIPER_VERSION 0.2.0
ENV MINI_BREAKPAD_SERVER_PORT 8080

RUN curl -sSL "$CALIPER_DOWNLOAD_URL" -o caliper.tar.gz \
	&& echo "$CALIPER_DOWNLOAD_SHA1 *caliper.tar.gz" | sha1sum -c - \
	&& tar -xvzf caliper.tar.gz -C /usr/local \
	&& ln -s /usr/local/Caliper-$CALIPER_VERSION /usr/local/caliper \
	&& rm caliper.tar.gz
RUN cd /usr/local/caliper && npm install
RUN cd /usr/local/caliper && ./node_modules/.bin/grunt

EXPOSE  8080
CMD ["/usr/local/caliper/bin/mini-breakpad-server"]