# Build Stage
FROM --platform=linux/amd64 ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y cmake

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y autoconf

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y libjpeg-dev

## Add source code to the build stage.
ADD . /jpegoptim
WORKDIR /jpegoptim

## TODO: ADD YOUR BUILD INSTRUCTIONS HERE.
RUN ./configure
RUN make

#Package Stage
FROM --platform=linux/amd64 ubuntu:20.04

## TODO: Change <Path in Builder Stage>
COPY --from=builder /jpegoptim/jpegoptim /
COPY --from=builder /usr/lib/x86_64-linux-gnu/libjpeg.so /usr/lib/x86_64-linux-gnu/libjpeg.so
COPY --from=builder /usr/lib/x86_64-linux-gnu/libjpeg.so.8 /usr/lib/x86_64-linux-gnu/libjpeg.so.8
