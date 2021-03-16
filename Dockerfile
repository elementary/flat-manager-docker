FROM alpine:edge AS builder

WORKDIR /root

RUN apk add cargo rust
RUN apk add postgresql-dev

RUN cargo --quiet install --git https://github.com/flatpak/flat-manager.git --tag=0.3.7 --root=/root

RUN cd /root/.cargo/git/checkouts/flat-manager*/* && \
    install -m 644 -D -t /root/etc example-config.json

FROM alpine:edge

RUN apk add libpq
RUN apk add flatpak

COPY --from=builder /root/bin/ /usr/bin
COPY --from=builder /root/etc /etc/flat-manager

ADD entrypoint.sh /usr/bin
RUN chown root:root /usr/bin/entrypoint.sh && chmod 755 /usr/bin/entrypoint.sh

RUN mkdir -p /var/run/postgresql

ENV HOME /var/run/flat-manager
ENV REPO_CONFIG $HOME/config.json
ENV RUST_LOG info

RUN addgroup flatmanager &&\
    adduser -D -G flatmanager -h $HOME -s /sbin/nologin flatmanager

USER flatmanager
EXPOSE 8080

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["flat-manager"]
