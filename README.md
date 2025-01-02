# Tinyproxy Setup on Ubuntu

This repository provides instructions and configuration files to set up [Tinyproxy](https://tinyproxy.github.io/) as an HTTP/HTTPS proxy on an Ubuntu server.

## Overview

Tinyproxy is a lightweight, open-source proxy daemon that is easy to configure and well-suited for small and embedded deployments.

## Features

- Handles HTTP connections (with optional HTTPS tunneling via CONNECT).
- Simple configuration to allow or deny specific IP ranges.
- Basic authentication support.

## Prerequisites

- **Ubuntu** (tested on Ubuntu 20.04/22.04)
- **sudo** privileges on the server.

## Files

1. **README.md**
   The primary documentation file. Explains all the steps to install and configure Tinyproxy on Ubuntu, along with any additional information.

2. **tinyproxy.conf**
   The Tinyproxy configuration file. Contains all the relevant settings, including the port, allowed IP addresses, and BasicAuth credentials.

3. **install_tinyproxy.sh**
   A simple script that automates the installation, configuration, and firewall setup.

---

For complete instructions, refer to the sections in this README.

Set `BasicAuth <login> <password>` and add allowed IP in config.
