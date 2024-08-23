#!/bin/sh

_term() {
    echo "Caught SIGTERM signal. Logging out and cleaning up."
    trap - TERM
    kill -TERM $TAILSCALE_DAEMON_PID
    wait $TAILSCALE_DAEMON_PID
}

trap _term TERM

/app/tailscaled -state=mem: -statedir=/var/lib/tailscale -socket=/var/run/tailscale/tailscaled.sock -tun userspace-networking -socks5-server localhost:1055 &
TAILSCALE_DAEMON_PID=$!
/app/tailscale up --ssh --authkey=${TAILSCALE_AUTHKEY} --hostname=${PYRITE_APP_NAME}-${PYRITE_SERVICE_NAME}

wait
