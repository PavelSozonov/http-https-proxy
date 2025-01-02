# Tinyproxy + Stunnel + Let’s Encrypt on Ubuntu

This repository provides a simple configuration to set up a secure HTTPS proxy using:

- [Tinyproxy](https://tinyproxy.github.io/) as the HTTP proxy server
- [Stunnel](https://www.stunnel.org/) to provide TLS encryption for Tinyproxy
- [Certbot](https://certbot.eff.org/) (from [Let’s Encrypt](https://letsencrypt.org/)) to obtain SSL certificates automatically

## Prerequisites

- A public Ubuntu server with ports 80 and 443 open.
- A valid domain name pointing to the server’s IP (required for Let’s Encrypt).

## Quick Start

1. **Create your `.env` file** from the included template:
   ```bash
   cp .env.template .env
   ```
   - Edit `.env` to set:
     - `TINYPROXY_PORT` (defaults to 8888)
     - `TINYPROXY_ALLOWED_IPS` (comma-separated)
     - `TINYPROXY_AUTH_LOGIN` and `TINYPROXY_AUTH_PASSWORD` for Basic Auth
     - `CERTBOT_DOMAIN` and `CERTBOT_EMAIL`
     - `SSL_CERT_PATH` and `SSL_KEY_PATH` (where Certbot places the certificates)

2. **Run the configuration script**:
   ```bash
   chmod +x configure.sh
   ./configure.sh
   ```
   This script will:
   - Install `tinyproxy`, `stunnel4`, and `certbot`
   - Generate `/etc/tinyproxy/tinyproxy.conf` and `/etc/stunnel/tinyproxy.conf` using your environment variables
   - Request an SSL certificate from Let’s Encrypt using the standalone method
   - Enable and start both `tinyproxy` and `stunnel4`

3. **Verify** everything is working:
   - Check if you can reach the secure proxy:
     - Via `https://your-domain:443` (Stunnel is listening on port 443)
     - Tinyproxy is behind Stunnel on `127.0.0.1:8888`, so you only connect via SSL from outside.
   - Check logs:
     ```bash
     sudo journalctl -u tinyproxy
     sudo journalctl -u stunnel4
     ```

4. **Adjust firewall rules** (if needed) to ensure inbound traffic on ports `80` (for Let’s Encrypt) and `443` (for stunnel) are allowed.

## Notes

- Certificates are stored by default in `/etc/letsencrypt/live/<domain>/`.
- If renewal is needed, you can rely on the auto-renew cron job from `certbot` or run:
  ```bash
  sudo certbot renew
  ```
- If you need to further lock down your Stunnel config, you can disable older TLS protocols or ciphers.
