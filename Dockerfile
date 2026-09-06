# Base image
FROM alpinelinux/unbound:latest

# Install Lighttpd
RUN apk add --no-cache \
        lighttpd \
    && mkdir -p /var/www/localhost/htdocs /usr/local/cgi-bin \
    && chown -R unbound:unbound /var/www /usr/local/cgi-bin

# Lighttpd config for plain text output
COPY unbound.conf /etc/unbound/
COPY lighttpd.conf /etc/lighttpd/
COPY stats.cgi /usr/local/cgi-bin/stats.cgi
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Set permissions
RUN chmod +x /usr/local/cgi-bin/stats.cgi /usr/local/bin/entrypoint.sh \
    && chown unbound:unbound /usr/local/cgi-bin/stats.cgi

# Exposed ports
EXPOSE 8080/tcp 53/tcp 53/udp

# Verify the /stats endpoint responds with real statistics (lighttpd + CGI + unbound-control chain)
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD wget -q -O- http://127.0.0.1:8080/stats | grep -q '^total\.num\.queries=' || exit 1

# Override the base image entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
