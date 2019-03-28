#!/usr/bin/env bash

NAME=mdps_celery                         # name of the application
PROJECT_DIR=/var/www/mdps               # project directory
APP_DIR=/var/www/mdps                           # can be project dir
APP_MODULE=mdps                         # application module name

echo "Starting $NAME as `whoami`"


# Activate the virtual environment
source $PROJECT_DIR/env/bin/activate
export PYTHONPATH=$APP_DIR:$PYTHONPATH

cd $APP_DIR

# Start Celery
exec celery -A ${APP_MODULE} worker -B
