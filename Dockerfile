FROM ubuntu:jammy as build
ENV TZ=Europe/Amsterdam
WORKDIR /build

ARG DEBCONF_NOWARNINGS="yes"
ARG DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y upgrade && \
    apt-get --no-install-recommends -y install \
    git g++ make pkg-config libtool ca-certificates \
    libyaml-perl libtemplate-perl libregexp-grammars-perl libssl-dev zlib1g-dev \
    liblmdb-dev libflatbuffers-dev libsecp256k1-dev \
    libzstd-dev

COPY . .
RUN git submodule update --init
RUN make setup-golpe
RUN make -j4

FROM ubuntu:jammy as runner
WORKDIR /app

RUN apt-get update && apt-get -y upgrade && \
    apt-get --no-install-recommends -y install \
    liblmdb0 libflatbuffers1 libsecp256k1-0 libb2-1 libzstd1 wget python3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
ARG DATE_ARG=""
ARG BUILD_ARG=0
ARG VERSION_ARG="0.9.3"
ENV VERSION=$VERSION_ARG

LABEL org.opencontainers.image.created=${DATE_ARG}
LABEL org.opencontainers.image.revision=${BUILD_ARG}
LABEL org.opencontainers.image.version=${VERSION_ARG}
LABEL org.opencontainers.image.source=https://github.com/dockur/strfry/
LABEL org.opencontainers.image.url=https://hub.docker.com/r/dockurr/strfry/

HEALTHCHECK --interval=60s --retries=2 --timeout=10s CMD wget -nv -t1 --spider 'http://localhost:7777/' || exit 1

ENV STREAMS ""

COPY strfry.sh /app/strfry.sh
COPY strfry.conf /etc/strfry.conf.default
COPY write-policy.py /app/write-policy.py

RUN chmod +x /app/strfry.sh
RUN chmod +x /app/write-policy.py

COPY --from=build /build/strfry strfry
CMD ["/app/strfry.sh"]
