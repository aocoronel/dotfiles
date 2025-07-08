#!/usr/bin/env bash

EMAIL=$(pass personal/filen.io | sed -n 's/^email=//p')
PASSWORD=$(pass personal/filen.io | head -n 1)
OTP=$(pass otp personal/filen.io)
W_USER=user
W_PASSWORD=secret

podman run -d -p 9090:80 filen/cli:latest \
  --email "$EMAIL" \
  --password "$PASSWORD" \
  --two-factor-code "$OTP" \
  webdav \
  --w-user "$W_USER" \
  --w-password "$W_PASSWORD"
