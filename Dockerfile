FROM rust:alpine AS builder
WORKDIR /root
RUN apk add --no-cache musl-dev postgresql-dev
RUN cargo install --git https://github.com/flatpak/flat-manager.git --root /root

FROM alpine:edge
RUN apk add --no-cache flatpak
RUN mkdir -p /etc/flat-manager
COPY --from=builder /root/bin/flat-manager /usr/bin/flat-manager
COPY ./config.json $HOME/config.json
ENV HOME /var/run/flat-manager
ENV REPO_CONFIG $HOME/config.json
ENV RUST_LOG info
RUN addgroup flatmanager &&\
  adduser -D -G flatmanager -h $HOME -s /sbin/nologin flatmanager
USER flatmanager
CMD ["flat-manager"]