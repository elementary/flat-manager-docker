FROM alpine:edge AS builder

WORKDIR /root

RUN apk --update add cargo fuse fuse-dev postgresql-dev rust;

RUN cargo --quiet install --git https://github.com/flatpak/flat-manager.git --tag=0.3.7 --root=/root
RUN cargo --quiet install --git https://github.com/kahing/catfs.git --tag=v0.8.0 --root=/root

RUN cd /root/.cargo/git/checkouts/flat-manager*/* && \
    install -m 644 -D -t /root/etc example-config.json

FROM alpine:edge

RUN apk --update add bash fuse fuse-dev flatpak libpq;

RUN wget https://github.com/kahing/goofys/releases/download/v0.24.0/goofys; \
  mv goofys /usr/bin; \
  chown root:root /usr/bin/goofys; \
  chmod 644 /usr/bin/goofys; \
  chmod +x /usr/bin/goofys;

COPY --from=builder /root/bin /usr/bin
COPY --from=builder /root/etc /etc/flat-manager

ADD entrypoint.sh /usr/bin
RUN chown root:root /usr/bin/entrypoint.sh && chmod 755 /usr/bin/entrypoint.sh

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
