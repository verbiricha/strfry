# Built by Akito
# npub1wprtv89px7z2ut04vvquscpmyfuzvcxttwy2csvla5lvwyj807qqz5aqle

FROM alpine:3.18.3 AS build

ENV TZ=Europe/Amsterdam

WORKDIR /build

COPY . .

RUN \
  apk --no-cache add \
    linux-headers \
    git \
    g++ \
    make \
    pkgconfig \
    libtool \
    ca-certificates \
    perl-yaml \
    perl-template-toolkit \
    perl-app-cpanminus \
    libressl-dev \
    zlib-dev \
    lmdb-dev \
    flatbuffers-dev \
    libsecp256k1-dev \
    zstd-dev \
  && rm -rf /var/cache/apk/* \
  && cpanm Regexp::Grammars \
  && git submodule update --init \
  && make setup-golpe \
  && make -j4

FROM alpine:3.18.3

WORKDIR /app

RUN \
  apk --no-cache add \
    lmdb \
    flatbuffers \
    libsecp256k1 \
    libb2 \
    zstd \
    libressl \
    wget \
    python3
  && rm -rf /var/cache/apk/*

ARG DATE_ARG=""
ARG BUILD_ARG=0
ARG VERSION_ARG="0.9.5"
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

EXPOSE 7777

CMD ["/app/strfry.sh"]
