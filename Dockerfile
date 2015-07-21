FROM advancedtelematic/erlang:R16B03
ENV REFRESHED_AT 2015-07-16

RUN apt-get update; \
    apt-get dist-upgrade -y; \
    apt-get install -y git bluetooth libbluetooth-dev

RUN git clone https://github.com/PDXostc/rvi_core /rvi; \
    cd /rvi; \
    git checkout release-0.4.0

WORKDIR /rvi

RUN make; \
    mkdir components/rvi; \
    cp -r ebin components/rvi

COPY scripts/setup_rvi_node.sh /rvi/scripts/setup_rvi_node.sh
COPY rvi_sample.config /rvi/dev.config
COPY run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 8801 8807
CMD ["/run.sh"]
