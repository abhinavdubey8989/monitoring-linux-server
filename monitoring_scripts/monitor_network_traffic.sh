


# aim : scrape the detail of n/w activity & send it to statsd , 
#     : breaking it down into various categories: network-in & network-out
# sample usage : "./<this-script-name>.sh &"
#              : "&" sign at the end will run this script in background
# this script is to be run as a cron 
# however due to systemd restrictions in docker containers , we are running it as infinite for loop



# statsd config
STATSD_HOST=host.docker.internal
STATSD_PORT=8125

# metric prefix
METRIC_PREFIX=server_1.network

# n/w interface we want to monitor
NETWORK_INTERFACE=eth0

# sleep b/w 2 iteration of while loop
SLEEP_TIME=7



# this method will extract n/w in & n/w out
get_network(){

    local type=$1
    local cpu_util=0
    network=0


    if [ $type = "rx" ]; then
        # RX packets 6419  bytes 1378881 (1.3 MB)
        local rx_bytes=$(ifconfig $NETWORK_INTERFACE | awk '/RX packets/' | awk '{print $5}')
        network=$rx_bytes
    elif [ $type = "out" ]; then
        # TX packets 6419  bytes 1378881 (1.3 MB)
        local tx_bytes=$(ifconfig $NETWORK_INTERFACE | awk '/TX packets/' | awk '{print $5}')
        network=$tx_bytes    
    fi

    echo "$network"
}


send_metrics_to_statsd(){
    local counter=$1
    local metric_suffix=$2
    local final_metric="$METRIC_PREFIX.$NETWORK_INTERFACE.$metric_suffix"

    # print on console
    # echo "$final_metric = $counter"

    # send metric command to statsd
    echo "$final_metric:$counter|c" | nc -w 1 -u $STATSD_HOST $STATSD_PORT


}

main(){

    # send metric forever
    while true; do

        # get cpu_util_percen for various categories
        local network_in=$(get_network "rx")
        local network_out=$(get_network "tx")
        
        # testing
        # get_network "rx"
        # get_network "tx"
        
        # send metric
        send_metrics_to_statsd $network_in "rx_bytes (n/w in)"
        send_metrics_to_statsd $network_out "tx_bytes (n/w out)"
       
        # sleep
        sleep $SLEEP_TIME

    done
}


# call main method
main
