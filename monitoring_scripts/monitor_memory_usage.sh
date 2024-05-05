


# aim : scrape the detail of memory usage & send it to statsd , 
#     : breaking it down into various categories: total , used , buff/cache
# sample usage : "./<this-script-name>.sh &"
#              : "&" sign at the end will run this script in background
# this script is to be run as a cron 
# however due to systemd restrictions in docker containers , we are running it as infinite for loop


# Source the environment file
source env_file.env

# statsd config
STATSD_HOST=$STATSD_HOST
STATSD_PORT=$STATSD_PORT

# metric prefix
METRIC_PREFIX="$HOST_NAME.memory"

# sleep b/w 2 iteration of while loop
SLEEP_TIME=$SLEEP_INTERVAL_IN_SEC


# get top command snap-shot
# -b flag is for batch
# -n flag is to specify number of iterations to run top command (here we run only once)
get_top_output(){

    # sample o/p format
    # top_output="MiB Mem :   7849.1 total,   4606.9 free,   1050.4 used,   2191.7 buff/cache"

    # extract the relevant line from top command which begins with %CPU
    top_output=$(top -bn 1 | awk '/MiB Mem/')
    echo "$top_output" 
}


# this method will extract get_cpu_memory_usage for various categories
get_cpu_memory_usage(){

    local type=$1
    local top_output=$2
    local cpu_util=0

    if [ $type = "total" ]; then
        cpu_util=$(echo "$top_output" | awk -F'total,' '{print $1}' | awk -F'[ ,]' '/:/{print $(NF-1)}')
    elif [ $type = "used" ]; then
        cpu_util=$(echo "$top_output" | awk -F'used,' '{print $1}' | awk -F'[ ,]' '/,/{print $(NF-1)}')
    elif [ $type = "buff" ]; then
        cpu_util=$(echo "$top_output" | awk -F'buff,' '{print $1}' | awk -F'[ ,]' '/,/{print $(NF-1)}')
    fi

    echo "$cpu_util"
}


send_metrics_to_statsd(){
    local counter=$1
    local metric_suffix=$2
    local final_metric="$METRIC_PREFIX.$metric_suffix"

    # print on console
    # echo "$final_metric = $counter"

    # send metric command to statsd
    echo "$final_metric:$counter|c" | nc -w 1 -u $STATSD_HOST $STATSD_PORT


}

main(){

    # send metric forever
    while true; do

        local top_output=$(get_top_output)

        # get cpu_util_percen for various categories
        local cpu_mem_total=$(get_cpu_memory_usage "total" "'$top_output'")
        local cpu_mem_used=$(get_cpu_memory_usage "used" "'$top_output'")
        local cpu_mem_buff=$(get_cpu_memory_usage "buff" "'$top_output'")
        
        # testing
        # get_cpu_memory_usage "user" "'$top_output'"
        # get_cpu_memory_usage "system" "'$top_output'"
        # get_cpu_memory_usage "idle" "'$top_output'"
        
        # send metric
        send_metrics_to_statsd $cpu_mem_total "total"
        send_metrics_to_statsd $cpu_mem_used "used"
        send_metrics_to_statsd $cpu_mem_buff "buff"
       
        # sleep
        sleep $SLEEP_TIME

    done
}


# call main method
main
