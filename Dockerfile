FROM buildpack-deps:jessie

ENV DEBIAN_FRONTEND=noninteractive

RUN echo "deb http://httpredir.debian.org/debian jessie contrib" >> /etc/apt/sources.list && \
    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections && \
    apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y unoconv wget ttf-mscorefonts-installer && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    adduser --gecos "" --disabled-password protonet

RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.1.3/dumb-init_1.1.3_amd64 && \
    chmod +x /usr/local/bin/dumb-init    

EXPOSE 2002

USER protonet
# Unoconv creates a whole bunch of configuration on the first launch
# and then exits with "Existing LibreOffice listener found, nothing to do."
# on the first run, hence we have to do this here once so we can reliably
# start it later on...
RUN /usr/bin/unoconv --listener -vvvvv --port=2002 --server=0.0.0.0
CMD ["dumb-init", "/usr/bin/unoconv", "--listener", "-vvvvv", "--port=2002", "--server=0.0.0.0"]