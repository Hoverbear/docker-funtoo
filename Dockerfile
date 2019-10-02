FROM ubuntu:latest as fetcher
RUN apt update && apt install --yes curl xz-utils && apt clean
RUN mkdir /funtoo
WORKDIR /funtoo
RUN curl -L https://build.funtoo.org/funtoo-current/x86-64bit/generic_64/stage3-latest.tar.xz | tar xpJ

FROM scratch
COPY --from=fetcher /funtoo/ /
RUN ego sync

# Set some system level knobs to run better in a container.
RUN rm -rf /etc/fstab
ENV DONT_MOUNT_BOOT "true"
RUN epro flavor minimal

# NOTE: This will hang for what seems like a long time after an apparent error, but rest assured things are fine.
RUN emerge --unmerge debian-sources-lts
RUN emerge --deep --newuse --noreplace --quiet --verbose @world
ENTRYPOINT ["/bin/bash"]