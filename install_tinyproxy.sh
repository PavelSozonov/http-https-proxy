#!/usr/bin/env bash

# install_tinyproxy.sh
# This script automates the installation and configuration of Tinyproxy on Ubuntu.

set -e

echo "Updating package list..."
sudo apt update

echo "Installing Tinyproxy..."
sudo apt install tinyproxy -y

echo "Copying configuration file..."
sudo cp tinyproxy.conf /etc/tinyproxy/tinyproxy.conf

echo "Securing configuration file..."
sudo chmod 600 /etc/tinyproxy/tinyproxy.conf

echo "Allowing Tinyproxy port in the firewall..."
sudo ufw allow 8888/tcp
sudo ufw reload

echo "Enabling Tinyproxy service..."
sudo systemctl enable tinyproxy

echo "Starting Tinyproxy service..."
sudo systemctl start tinyproxy
