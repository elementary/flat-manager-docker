FROM alpine:edge AS builder

WORKDIR /root

RUN apk add cargo rust
RUN apk add postgresql-dev

RUN cargo --quiet install --git https://github.com/flatpak/flat-manager.git --tag=0.3.7 --root=/root

RUN cd /root/.cargo/git/checkouts/flat-manager*/* && \
    install -m 644 -D -t /root/etc example-config.json

FROM alpine:edge

ARG S3FS_VERSION=v1.89

RUN apk --update add fuse alpine-sdk automake autoconf libxml2-dev fuse-dev curl-dev git bash;
RUN git clone https://github.com/s3fs-fuse/s3fs-fuse.git; \
 cd s3fs-fuse; \
 git checkout tags/${S3FS_VERSION}; \
 ./autogen.sh; \
 ./configure --prefix=/usr; \
 make; \
 make install; \
 rm -rf /var/cache/apk/*;

RUN apk --update add flatpak libpq

COPY --from=builder /root/bin/ /usr/bin
COPY --from=builder /root/etc /etc/flat-manager

ADD entrypoint.sh /usr/bin
RUN chown root:root /usr/bin/entrypoint.sh && chmod 755 /usr/bin/entrypoint.sh

RUN mkdir -p /var/run/postgresql

ENV HOME /var/run/flat-manager
ENV REPO_CONFIG $HOME/config.json
ENV STARTUP_SCRIPT $HOME/startup.sh
ENV RUST_LOG info

RUN addgroup flatmanager &&\
    adduser -D -G flatmanager -h $HOME -s /sbin/nologin flatmanager

USER flatmanager
EXPOSE 8080

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["flat-manager"]
