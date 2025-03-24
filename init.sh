#!/usr/bin/env sh

/usr/sbin/tailscaled --state=/var/lib/tailscale/tailscaled.state >> /dev/stdout &
/usr/bin/tailscale up --accept-routes=true --accept-dns=true >> /dev/stdout &

/root/go/bin/derper -a 0.0.0.0:12345 -stun-port 12346 -c /var/lib/derper/derper.key --verify-clients
