# Unbound Image with Statistics

This is a simple [Unbound DNS][unbound] container recipe that exposes Unbound statistics via a lightweight web service.

Although Unbound from NLnet Labs can offer detailed statistics, it only provides this data internally as plain text output. This container image build is designed for easy integration with monitoring tools without the need for third-party plugins.

> It is based on [Alpine Linux Unbound (_alpinelinux/unbound_)][alpineunbound].

> ⚠️ This image build assumes that the environment has been secured by other means.

<BR>

## 🧩 Components

- [📦 `unbound.conf`][unboundconf]

This is a **sample Unbound configuration** file with the `unbound-control` command already enabled. This file is intended for quick setup and can be overwritten by binding a new file to the `/etc/unbound/unbound.conf` path.

⚠️ **It is highly recommended to update this configuration file for your own environment.**

> **Configuration parameters are described in the [NLnet Labs documentation][netlabs].**

- [📦 `lighttpd.conf`][lighttpdconf]

This is the main [Lighttpd configuration][lightconf] file used to start the Web service on port `8080`. It exposes the `/stats` resource in plain text.

> **It is recommended to secure this Web access with your prefered tool.**

- [📦 `stats.cgi`][statscgi]

This small CGI script outputs Unbound statistics when the `unbound-control stats` command is run on a web request to the `/stats` resource.

- [📦 `entrypoint.sh`][entrypointsh]

The entrypoint script from the original Alpine Linux Unbound image was modified to start both the Unbound and Lighttpd services.

- [📦 `Dockerfile`][Dockerfile]

This is the main Dockerfile that builds the new image. It installs Lighttpd, copies the configuration files, sets permissions and overrides the entrypoint script.

<BR>

## 🚀 Startup

> **This is mostly agnostic to the container management tool. If your are using Docker, change `podman` to `docker`.**

**1.** Clone this repository with `git`.

```bash
git clone https://github.com/diasdmhub/unbound-stats.git
```

**2.** Build the new image.

```bash
podman build -f Dockerfile -t unbound-stats
```

**3.** Start the container.

> **A low port bind may require administrative permissions or a capability set.**

```bash
podman run -d --name unbound -p 53:53/udp -p 53:53/tcp -p 8080:8080 localhost/unbound-stats
```

<BR>

## 🔍 Verify

After starting the container, Unbound should serve its statistics from a local HTTP endpoint, such as `http://localhost:8080/stats`. These statistics should be accessible from any Web browser or via commands such as cURL.

```bash
curl http://localhost:8080/stats
```

> _Replace `localhost` with your system's IP or domain name._

[unbound]: https://www.nlnetlabs.nl/projects/unbound/about/
[alpineunbound]: https://hub.docker.com/r/alpinelinux/unbound
[netlabs]: https://unbound.docs.nlnetlabs.nl/en/latest/manpages/unbound.conf.html
[lightconf]: https://redmine.lighttpd.net/projects/lighttpd/wiki
[unboundconf]: ./unbound.conf
[lighttpdconf]: ./lighttpd.conf
[statscgi]: ./stats.cgi
[entrypoint.sh]: ./entrypoint.sh
[Dockerfile]: ./Dockerfile