#!/usr/bin/env bash

NAME="<project_name>"                                  # name of the application
PROJECT_DIR=/var/www/<project_dir_name>                # flask project directory
APP_DIR=$PROJECT_DIR/application                       # flask application directory
SOCK_FILE=$PROJECT_DIR/env/run/gunicorn.sock           # we will communicte using this unix socket
USER=www-data                                          # the user to run as
GROUP=www-data                                         # the group to run as
NUM_WORKERS=1                                          # how many worker processes should Gunicorn spaw
APP_RUN_MODULE=<run_module_name>                       # application run module name
APP_CALLABLE=<callable_name>                           # callable object name
TIMEOUT=300                                            # execution timeout (in second)

echo "Starting $NAME as `whoami`"


# Activate the virtual environment
source $PROJECT_DIR/env/bin/activate
export PYTHONPATH=$APP_DIR:$PYTHONPATH


# Create the run directory if it doesn't exist
RUNDIR=$(dirname $SOCK_FILE)
test -d $RUNDIR || mkdir -p $RUNDIR


# Start Flask Unicorn
# Programs meant to be run under supervisor should not daemonize themselves (do not use --daemon)
exec gunicorn ${APP_RUN_MODULE}:${APP_CALLABLE} \
  --name $NAME \
  --timeout $TIMEOUT \
  --workers $NUM_WORKERS \
  --user=$USER --group=$GROUP \
  --bind=unix:$SOCK_FILE \
  --log-level=debug \
  --log-file=-