#!/bin/bash

# XDEBUG
if [ "$PHP_DEBUG" == 1 ]
then
  # settings for xdebug 3.0.x
  echo "xdebug.idekey = PHPSTORM" >> "$PHP_INI_DIR"/conf.d/20-xdebug.ini && \
  echo "xdebug.mode = debug" >> "$PHP_INI_DIR"/conf.d/20-xdebug.ini && \
  echo "xdebug.client_host=172.17.0.1" >> "$PHP_INI_DIR"/conf.d/20-xdebug.ini && \
  echo "xdebug.client_port=9003" >> "$PHP_INI_DIR"/conf.d/20-xdebug.ini && \
#  echo "xdebug.start_with_request = yes" >> "$PHP_INI_DIR"/conf.d/20-xdebug.ini  # this will enable xdebug all the time - will be slow!!!

  # if XDEBUG_HOST is manually set
  HOST="$XDEBUG_HOST"

  # else if check if is Docker for Mac
  if [ -z "$HOST" ]; then
      HOST=`getent hosts docker.for.mac.localhost | awk '{ print $1 }'`
  fi

  # else get host ip
  if [ -z "$HOST" ]; then
      HOST=`/sbin/ip route|awk '/default/ { print $3 }'`
  fi

  # xdebug config
  if [ -f "$PHP_INI_DIR"/conf.d/20-xdebug.ini ]
  then
      sed -i "s/xdebug\.remote_host \=.*/xdebug\.remote_host\=$HOST/g" "$PHP_INI_DIR"/conf.d/20-xdebug.ini
  fi
else
  rm -rf "$PHP_INI_DIR"/conf.d/docker-php-ext-xdebug.ini
fi

# BLACKFIRE
if [ "$BLACKFIRE_ENABLED" == 1 ]
then
  printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8307\n" > "$PHP_INI_DIR"/conf.d/blackfire.ini
else
  rm -rf "$PHP_INI_DIR"/conf.d/blackfire.ini
fi

exec "$@"
