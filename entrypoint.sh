#!/bin/sh

# Original Alpine Linux Unbound entrypoint
for i in server control; do
    if [ ! -f /etc/unbound/unbound_$i.key ] ||
        [ ! -f /etc/unbound/unbound_$i.pem ]; then
            unbound-control-setup && break
    fi
done

unbound-anchor -a /etc/unbound/root.key
chown -R unbound:unbound /etc/unbound

# Start Lighttpd to handle /stats CGI
lighttpd -D -f /etc/lighttpd/lighttpd.conf &

# Start Unbound in foreground (PID 1)
exec unbound -dp
