
# aim : start all monitoring scripts
# sample use : "./<this-script-name>.sh 1" to start all
#            : "./<this-script-name>.sh 1 target.sh" to start only "target.sh" script
#            : "./<this-script-name>.sh 0" to stop all
#            : "./<this-script-name>.sh 0 target.sh" to stop only "target.sh" script

# starts all scripts in bk-ground



START_STOP_FLAG=$1
START_STOP_SPECIFIC_SCRIPT_NAME=$2

# if we call this method multiple times , then it will start multiple scipts of same type in bkgroud
# this will lead to metrics/counters getting added up 
start_all(){

    echo "starting all scripts !!!"
    nohup bash monitor_cpu_usage.sh &
    nohup bash monitor_load_avg.sh &
    nohup bash monitor_memory_usage.sh &
    nohup bash monitor_network_traffic.sh &
    nohup bash monitor_tcp.sh &
    echo "started !!!! "
    echo ""
}

# stop all scripts
stop_all(){
    echo "stopping all scripts !!!"
    pkill -f monitor_load_avg.sh
    pkill -f monitor_memory_usage.sh
    pkill -f monitor_network_traffic.sh
    pkill -f monitor_tcp.sh
    pkill -f monitor_cpu_usage.sh
    echo "stopped !!!! "
    echo
}

# start a specific script
start_specific(){
    local name=$1
    echo "starting [$name] !!!"
    nohup bash "$name" &
    echo "started !!!! "
    echo ""
}


# stop a specific script
stop_specific(){
    local name=$1
    echo "stopping [$name] !!!"
    pkill -f "$name"
    echo "stopped !!!! "
    echo ""
}


if [ $1 -eq 1 ]; then
    if [ -z "$START_STOP_SPECIFIC_SCRIPT_NAME" ]; then
        start_all
    else
        start_specific $START_STOP_SPECIFIC_SCRIPT_NAME
    fi
elif [ $1 -eq 0 ]; then
    if [ -z "$START_STOP_SPECIFIC_SCRIPT_NAME" ]; then
        stop_all
    else
        stop_specific $START_STOP_SPECIFIC_SCRIPT_NAME
    fi
else 
    echo "Incorrect input !!"
fi