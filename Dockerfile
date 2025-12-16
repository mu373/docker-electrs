# Based on
# https://github.com/getumbrel/docker-electrs/blob/master/Dockerfile
# https://github.com/iangregsondev/electrs-docker/blob/main/Dockerfile

FROM rust:1.85-slim-bookworm AS builder

ARG VERSION

WORKDIR /build

RUN apt-get update
RUN apt-get install -y git build-essential libclang-dev libsnappy-dev
RUN apt-get install -y librocksdb-dev

RUN git clone --branch $VERSION https://github.com/romanz/electrs .

# cargo under QEMU building for ARM can consumes 10s of GBs of RAM...
# Solution: https://users.rust-lang.org/t/cargo-uses-too-much-memory-being-run-in-qemu/76531/2
ENV CARGO_NET_GIT_FETCH_WITH_CLI=true

RUN cargo build --release --bin electrs

FROM debian:bookworm-slim

RUN adduser --disabled-password --uid 1000 --home /data --gecos "" electrs
USER electrs
WORKDIR /data

COPY --from=builder /build/target/release/electrs /bin/electrs

# Electrum RPC
EXPOSE 50001

# Prometheus monitoring
# EXPOSE 4224

STOPSIGNAL SIGINT

ENTRYPOINT ["electrs"]
