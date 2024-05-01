

# this script will stop the components in if START_OR_STOP_FLAG=0

# this script will start the components , if START_OR_STOP_FLAG=1 , in attach/detach mode basis ATTACH_MODE_FLAG
# if ATTACH_MODE_FLAG is null or "d" => detach mode
# if ATTACH_MODE_FLAG is "a" => attach mode
# rest any value of ATTACH_MODE_FLAG is invalid
# sample usage : "./start_or_stop.sh 0" to stop container
# sample usage : "./start_or_stop.sh 1" to start container 


START_OR_STOP_FLAG=$1
ATTACH_MODE_FLAG=$2

stop() {
    docker-compose down
    docker container prune -f
    echo "stopped $PWD ..."
}


start_attach() {
    echo "attach mode"
    docker-compose up
}


start_detach() {
    echo "detach mode"
    docker-compose up -d
}


if [ -z "$START_OR_STOP_FLAG" ] ; then
    echo "Invalid value of start/stop flag"
    exit 0
elif [ "$START_OR_STOP_FLAG" = "0" ]; then
    stop
    exit 0
elif [ "$START_OR_STOP_FLAG" != "1" ]; then
    echo "Invalid value of start/stop flag"
    exit 0
fi


stop
if [ -z "$ATTACH_MODE_FLAG" ] || [ "$ATTACH_MODE_FLAG" = "d" ]; then
    start_detach
elif [ "$ATTACH_MODE_FLAG" = "a" ]; then
    start_attach
else
    echo "Invalid value of flag"
fi