#!/usr/bin/env bash

set -e

# Load environment variables from .env
if [ ! -f .env ]; then
  echo "ERROR: .env file not found. Please copy .env.template to .env and fill in the values."
  exit 1
fi

. ./.env

# Substitute variables into tinyproxy.conf.template
ALLOWED_LINES=""
IFS=',' read -ra ADDR <<< "$TINYPROXY_ALLOWED_IPS"
for ip in "${ADDR[@]}"; do
  ALLOWED_LINES+="Allow $ip"$'\n'
done

TINYPROXY_CONF=$(< tinyproxy.conf.template)
TINYPROXY_CONF="${TINYPROXY_CONF//\{\{TINYPROXY_PORT\}\}/$TINYPROXY_PORT}"
TINYPROXY_CONF="${TINYPROXY_CONF//\{\{TINYPROXY_AUTH_LOGIN\}\}/$TINYPROXY_AUTH_LOGIN}"
TINYPROXY_CONF="${TINYPROXY_CONF//\{\{TINYPROXY_AUTH_PASSWORD\}\}/$TINYPROXY_AUTH_PASSWORD}"
TINYPROXY_CONF="${TINYPROXY_CONF//\{\{TINYPROXY_ALLOWED_IPS_PLACEHOLDER\}\}/$ALLOWED_LINES}"

STUNNEL_CONF=$(< stunnel.conf.template)
STUNNEL_CONF="${STUNNEL_CONF//\{\{TINYPROXY_PORT\}\}/$TINYPROXY_PORT}"
STUNNEL_CONF="${STUNNEL_CONF//\{\{SSL_CERT_PATH\}\}/$SSL_CERT_PATH}"
STUNNEL_CONF="${STUNNEL_CONF//\{\{SSL_KEY_PATH\}\}/$SSL_KEY_PATH}"

sudo apt-get update -y
sudo apt-get install -y tinyproxy stunnel4 certbot

echo "$TINYPROXY_CONF" | sudo tee /etc/tinyproxy/tinyproxy.conf > /dev/null
echo "$STUNNEL_CONF" | sudo tee /etc/stunnel/tinyproxy.conf > /dev/null

# Fix config: without this fix access control will not work
# Default value from config (# FLAGS="-c ${CONFIG}") do not work,
echo 'FLAGS="-c /etc/tinyproxy/tinyproxy.conf"' >> /etc/default/tinyproxy

sudo systemctl enable tinyproxy
sudo systemctl enable stunnel4

sudo certbot certonly --standalone -d "$CERTBOT_DOMAIN" --agree-tos -m "$CERTBOT_EMAIL" --non-interactive --rsa-key-size 4096

sudo systemctl start tinyproxy
sudo systemctl start stunnel4

echo "Setup completed successfully."
