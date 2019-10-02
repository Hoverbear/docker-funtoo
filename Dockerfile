FROM ubuntu:latest as fetcher
RUN apt update && apt install --yes curl xz-utils && apt clean
RUN mkdir /funtoo
WORKDIR /funtoo
RUN curl -L https://build.funtoo.org/funtoo-current/x86-64bit/generic_64/stage3-latest.tar.xz | tar xpJ

FROM scratch
COPY --from=fetcher /funtoo/ /
ENTRYPOINT ["/bin/bash"]