#!/bin/bash

SERVICE_NAME="tapd-service"
SERVICE_PATH="tapd --network=mainnet \
                  --debuglevel=debug \
                  --lnd.host=localhost:10009 \
                  --lnd.macaroonpath=/root/.lnd/data/chain/bitcoin/mainnet/admin.macaroon \
                  --lnd.tlspath=/root/.lnd/tls.cert \
                  --tapddir=/root/.taproot-assets \
                  --rpclisten=127.0.0.1:10029 \
                  --restlisten=127.0.0.1:8089"
PID_FILE="/root/$SERVICE_NAME.pid"
LOG_FILE="/root/$SERVICE_NAME.log"

start_service() {
    if [ -f "$PID_FILE" ]; then
        echo "$SERVICE_NAME is already running."
    else
        echo "Starting $SERVICE_NAME..."
        $SERVICE_PATH >> "$LOG_FILE" 2>&1 &
        echo $! > "$PID_FILE"
        echo "$SERVICE_NAME is now running with PID $!"
    fi
}

stop_service() {
    if [ -f "$PID_FILE" ]; then
        echo "Stopping $SERVICE_NAME..."
        PID=$(cat "$PID_FILE")
        kill "$PID"
        rm "$PID_FILE"
        echo "$SERVICE_NAME has been stopped."
    else
        echo "$SERVICE_NAME is not running."
    fi
}

restart_service() {
    stop_service
    start_service
}

case "$1" in
    start)
        start_service
        ;;
    stop)
        stop_service
        ;;
    restart)
        restart_service
        ;;
    *)
        echo "Usage: $0 {start|stop|restart}"
        exit 1
        ;;
esac

exit 0
