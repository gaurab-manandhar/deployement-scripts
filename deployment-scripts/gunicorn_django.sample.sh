#!/usr/bin/env bash

NAME="mdps"                                        # name of the application
DJANGODIR=/home/server/project/mdps                        # django project directory
SOCKFILE=/home/server/project/mdps/venv/run/gunicorn.sock  # we will communicte using this unix socket
USER=server                                                # the user to run as
GROUP=server                                               # the group to run as
NUM_WORKERS=1                                                # how many worker processes should Gunicorn spaw
DJANGO_SETTINGS_MODULE=mdps.settings             # which settings file should Django use
DJANGO_WSGI_MODULE=mdps.wsgi                     # WSGI module name
TIMEOUT=300                                                  # execution timeout (in second)

echo "Starting $NAME as `whoami`"


# Activate the virtual environment
cd $DJANGODIR
source /home/server/project/mdps/venv/bin/activate
export DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE
export PYTHONPATH=$DJANGODIR:$PYTHONPATH


# Create the run directory if it doesn't exist
RUNDIR=$(dirname $SOCKFILE)
test -d $RUNDIR || mkdir -p $RUNDIR


# Start Django Unicorn
# Programs meant to be run under supervisor should not daemonize themselves (do not use --daemon)
exec gunicorn ${DJANGO_WSGI_MODULE}:application \
  --name $NAME \
  --timeout $TIMEOUT \
  --workers $NUM_WORKERS \
  --user=$USER --group=$GROUP \
  --bind=unix:$SOCKFILE \
  --log-level=debug \
  --log-file=-