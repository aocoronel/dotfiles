#!/usr/bin/env bash

EMAIL=$(pass personal/filen | sed -n 's/^email=//p')
PASSWORD=$(pass personal/filen | head -n 1)
W_USER=user
W_PASSWORD=secret

podman run -d -p 8080:80 filen/cli:latest \
  --email "$EMAIL" \
  --password "$PASSWORD" \
  webdav \
  --w-user "$W_USER" \
  --w-password "$W_PASSWORD"
