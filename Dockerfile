# Base image
FROM alpinelinux/unbound

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

# Override the base image entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
