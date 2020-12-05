# FROM erlang:23.1.3 as builder
FROM erlang@sha256:d7d7659837ecd3d2cec6be6a18d507d1e0a0784331ac2ffdaa4adef7da475c2f as builder

WORKDIR /app/src
ENV REBAR_BASE_DIR /app/_build

# build and cache dependencies as their own layer
COPY rebar.config rebar.lock ./
RUN rebar3 compile

COPY . ./
RUN rebar3 as prod compile

FROM builder as releaser

# create the directory to unpack the release to
RUN mkdir -p /opt/rel

RUN rebar3 as prod tar && \
    tar -zxvf $REBAR_BASE_DIR/prod/rel/*/*.tar.gz -C /opt/rel

FROM debian:buster as runner

WORKDIR /opt/epmdlessless

ENV COOKIE=epmdlessless \
    # write files generated during startup to /tmp
    RELX_OUT_FILE_PATH=/tmp

# openssl needed by the crypto app
RUN apt-get update && apt-get install -y openssl

COPY --from=releaser /opt/rel ./

ENTRYPOINT ["/opt/epmdlessless/bin/epmdlessless"]
CMD ["foreground"]
