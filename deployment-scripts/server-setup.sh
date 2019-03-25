#!/usr/bin/env bash

# System Setup

# Update the sources and system
sudo apt update && sudo apt -y upgrade

# Install common packages
sudo apt install -y \
        curl \
        wget \
        unzip \
        zip \
        git

# For Python 3
sudo apt install python3 python3-pip

# For Python 2
sudo apt install python python-pip

# Install client library for MySQL
sudo apt install libmysqlclient-dev

# Install postgres library
sudo apt install libpq-dev 

# Install redis server
sudo apt install redis-serve

# Install MySQL server
sudo apt install mysql-server

# Install supervisor
sudo apt install supervisor

# Install Node.js
curl -sL https://deb.nodesource.com/setup_6.x | sudo bash - && \
    sudo apt install -y nodejs

# Clean unnecesary files from apt-get
sudo apt autoremove -y && sudo apt clean && sudo rm -rf /var/lib/apt/lists/*


# Project Setup

# Change the owner of `/var/www/` directory
sudo chown -R www-data:www-data /var/www/

# Start new bash
sudo -Hu www-data bash

# Change directory to home directory of `www-data` user
cd /var/www/

# Generate ssh key (key will be used to give readonly permission on repo)
ssh-keygen -t rsa -b 4096 -C "<replace_with_server_name>"

# Clone the repository
git clone <repository_url>

cd <project_directory>

# Install virtualenv package
pip3 install virtualenv

python3 -m virtualenv venv

source venv/bin/activate

# Run this if gunicorn is not specified in requirements file
pip install gunicorn


# Create directory for logs
mkdir <logs_dir> # eg. /var/www/logs

# Further Setps:
# 	- Create gunicorn start script (see sample `gunicorn_django.sample.sh` or `gunicorn_flask.sample.sh`).
#	- Create celery start script if (see sample `celery_runner.sample.sh`).
#	- Create supervisor configuration for gunicorn start script and celery start script (see sample supervisor_sampleapp.conf).
#	- Create nginx site configuration (see sample `nginx_site_config.sample.conf`)


# Restarting a project running with gunicorn
$ sudo supervisorctl status sample_project
$ sudo supervisorctl restart sample_project