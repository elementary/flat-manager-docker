FROM python:rc-alpine

WORKDIR /root

RUN apk add --update --no-cache build-base flatpak ostree py3-gobject3
RUN pip3 install --upgrade --no-cache aiohttp ostree tenacity

RUN wget https://raw.githubusercontent.com/flatpak/flat-manager/0.3.7/flat-manager-client; \
  mv flat-manager-client /usr/bin; \
  chown root:root /usr/bin/flat-manager-client; \
  chmod 644 /usr/bin/flat-manager-client; \
  chmod +x /usr/bin/flat-manager-client;

RUN addgroup flatmanager &&\
    adduser -D -G flatmanager -h $HOME -s /sbin/nologin flatmanager

USER flatmanager

ENTRYPOINT ["/usr/local/bin/python3", "/usr/bin/flat-manager-client"]
