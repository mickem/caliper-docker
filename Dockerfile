FROM    centos:centos6

RUN     rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
RUN     yum install -y textutils tar unzip util-linux git
RUN     yum install -y npm

ENV CALIPER_DOWNLOAD_URL https://github.com/mickem/Caliper/archive/v0.3.2.tar.gz
ENV CALIPER_DOWNLOAD_SHA1 2a17634ba30e4e33f3dd6469154b85689488c004
ENV CALIPER_VERSION 0.3.2
ENV MINI_BREAKPAD_SERVER_PORT 8080

RUN curl -sSL "$CALIPER_DOWNLOAD_URL" -o caliper.tar.gz \
    && sha1sum *caliper.tar.gz
RUN curl -sSL "$CALIPER_DOWNLOAD_URL" -o caliper.tar.gz
RUN echo "CALIPER_DOWNLOAD_SHA1 was: `sha1sum *caliper.tar.gz`"
RUN echo "$CALIPER_DOWNLOAD_SHA1 *caliper.tar.gz" | sha1sum -c - \
    && tar -xvzf caliper.tar.gz -C /usr/local \
    && ln -s /usr/local/Caliper-$CALIPER_VERSION /usr/local/caliper \
    && rm caliper.tar.gz

RUN ls -al /usr/local
RUN cd /usr/local/caliper && npm install
RUN cd /usr/local/caliper && ./node_modules/.bin/grunt

EXPOSE  8080
CMD ["/usr/local/caliper/bin/mini-breakpad-server"]