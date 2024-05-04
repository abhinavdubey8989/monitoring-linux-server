


# aim : scrape the detail/count of TCP connections & send it to statsd , 
#     : breaking it down into various categories: esatblished & wait
# sample usage : "./<this-script-name>.sh &"
#              : "&" sign at the end will run this script in background
# this script is to be run as a cron 
# however due to systemd restrictions in docker containers , we are running it as infinite for loop


# statsd config
STATSD_HOST=host.docker.internal
STATSD_PORT=8125

# metric prefix
METRIC_PREFIX=server_1.tcp

# sleep b/w 2 iteration of while loop
SLEEP_TIME=7


# this method will extract n/w in & n/w out
get_tcp(){

    local type=$1
    local cpu_util=0
    tcp=0


    if [ $type = "established" ]; then
        tcp_count=$(netstat -nat | grep 'ESTABLISHED' | wc -l)
    elif [ $type = "wait" ]; then
        tcp_count=$(netstat -nat | grep 'WAIT' | wc -l)
    fi

    echo "$tcp"
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

        # get cpu_util_percen for various categories
        local count_tcp_estd_connections=$(get_tcp "established")
        local count_tcp_wait_connections=$(get_tcp "wait")
        
        # testing
        # get_tcp "established"
        # get_tcp "wait"
        
        # send metric
        send_metrics_to_statsd $count_tcp_estd_connections "established"
        send_metrics_to_statsd $count_tcp_wait_connections "wait"
       
        # sleep
        sleep $SLEEP_TIME

    done
}


# call main method
main
