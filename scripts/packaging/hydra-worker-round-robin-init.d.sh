#!/bin/bash

# Hydra Worker Round-Robin - Startup script for Hydra Worker Round-Robin

# chkconfig: 35 99 15
# description: Sort instances by round-robin algorithmm
# processname: hydra-worker-round-robin
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# config: 
# pidfile: /var/run/hydra-worker-round-robin.pid

DISTRO_INFO=$(cat /proc/version)

if [[ $(echo $DISTRO_INFO | grep 'Debian\|Ubuntu') == "" ]]; then
	. /etc/rc.d/init.d/functions
fi

APP_NAME=hydra-worker-round-robin
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=/usr/local/hydra/hydra-worker-round-robin
DAEMON_ARGS="-config /etc/hydra/hydra-worker-round-robin.conf"
RUNDIR=/usr/local/hydra
PID_DIR=/var/run
PID_NAME=$APP_NAME.pid
PID_FILE=$PID_DIR/$PID_NAME
LOCK_FILE=/var/lock/subsys/${APP_NAME}

case "$1" in
start)
  if [ -f $PID_FILE ]
  then
    echo Already running with PID `cat $PID_FILE`
  else
    if [[ $(echo $DISTRO_INFO | grep 'Debian\|Ubuntu') != "" ]]; then
      if start-stop-daemon --start --pidfile $PID_FILE --chdir $RUNDIR --background --make-pidfile --exec $DAEMON -- $DAEMON_ARGS
      then
        echo ok
      else
        echo start failed
      fi
    else
      if [ ! -d /var/log/${APP_NAME} ]; then
        sudo mkdir /var/log/${APP_NAME}
      fi
      sudo chown -R $USER:$GROUP /var/log/${APP_NAME}
      cd $RUNDIR
      $DAEMON $DAEMON_ARGS &>/dev/null &
      RETVAL=$?
      if [ $RETVAL -eq 0 ]
      then
        echo [OK]
        PID=$!
        touch $LOCK_FILE
        echo $PID > $PID_FILE
      else
        echo [ERROR]
      fi
    fi
  fi
  ;;
stop)
  if [ -f $PID_FILE ]
  then
    kill -9 `cat $PID_FILE`
    rm -f $PID_FILE
  else
    echo $PID_FILE not found
  fi
  ;;
restart)
  ${0} stop
  ${0} start
  ;;
*)
  echo "Usage: /etc/init.d/$NAME {start|stop|restart}"
  exit 1
  ;;
esac

exit 0
