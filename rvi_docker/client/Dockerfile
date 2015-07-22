FROM advancedtelematic/erlang:R16B03
ENV REFRESHED_AT 2015-07-22

RUN apt-get update; \
    apt-get dist-upgrade -y; \
    apt-get install -y git bluetooth libbluetooth-dev

RUN git clone https://github.com/advancedtelematic/rvi_core /rvi; \
    cd /rvi; \
    git checkout fix/sample-local-nodes

WORKDIR /rvi

RUN make; \
    mkdir components/rvi; \
    cp -r ebin components/rvi

ADD run.sh run.sh
RUN chmod +x run.sh

EXPOSE 8901 8907 8908
CMD ["/rvi/run.sh"]

ADD rvi_client.config rvi_client.config
