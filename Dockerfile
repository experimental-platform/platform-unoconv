FROM quay.io/experimentalplatform/ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y unoconv wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    adduser --gecos "" --disabled-password protonet

# ===========================================================
# Install dumb-init for proper signal-processing
# ===========================================================
RUN update-ca-certificates && \
    wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.1.1/dumb-init_1.1.1_amd64 && \
    chmod +x /usr/local/bin/dumb-init

EXPOSE 2002

USER protonet
# Unoconv creates a whole bunch of configuration on the first launch
# and then exits with "Existing LibreOffice listener found, nothing to do."
# on the first run, hence we have to do this here once so we can reliably
# start it later on...
RUN /usr/bin/unoconv --listener -vvvvv --port=2002 --server=0.0.0.0
CMD ["dumb-init", "/usr/bin/unoconv", "--listener", "-vvvvv", "--port=2002", "--server=0.0.0.0"]