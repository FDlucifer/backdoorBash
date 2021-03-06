#! /bin/bash

cd "$(dirname "$0")"
BASE_DIR="$(pwd)"
CONTINUE=true

# Load common configuration
. ./config.sh
. ./lib.sh

# Override config
LOG=${LOG_SERVER}
LOG_ERROR=${LOG_SERVER_ERROR}

# Manage different POSIX system's signals
on_exit ()
{
	if [ $1 -eq 0 ]; then
		log "$0 ending with success (status code: $1)"
	else
		log "$0 ending with some error (status code: $1)"
	fi
}

trap 'on_exit $?' EXIT

on_interrupt ()
{
	# Just stop endless loop
	CONTINUE=false
}

trap on_interrupt INT TERM

while $CONTINUE; do
	log "Start server on port $HOST:$PORT"
	# TODO: Create socket on random port (port's range used in config)
	$NC -nl $HOST -p $PORT -e ./manage-server-request.sh
	log "Server halted on port $HOST:$PORT"
done

exit 0