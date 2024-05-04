


# this script is to be run as a cron 
# however due to systemd restrictions in docker containers , we are running it as infinite for loop
# the aim of this script is to scrape the avg-CPU-load & send it to statsd
# from statsD is send to graphite & visualized in grafana
# sample usage : "./send_load_avg.sh &"
# "&" sign at the end will run this script in background

# statsd config
STATSD_HOST=host.docker.internal
STATSD_PORT=8125

# metric prefix
METRIC_PREFIX=server_1.load_avg

# sleep b/w 2 iteration of while loop
SLEEP_TIME=5


# get top command snap-shot
# -b flag is for batch
# -n flag is to specify number of iterations to run top command (here we run only once)
get_top_output(){
    top_output=$(top -bn 1)
    echo "$top_output" 
}


# this method will extract load of last 1min , 5min , 15min basis the "minute" argument
get_load_avg(){
    local minute=$1
    local top_output=$2
    local load_avg=0

    if [ $minute -eq 1 ]; then
        # load-avg last 1 min
        load_avg=$(echo "$top_output" | awk '/load average:/ {print $10}' | sed 's/[,']//g)
        echo "$load_avg"

    elif [ $minute -eq 5 ]; then
        # load-avg last 5 min
        load_avg=$(echo "$top_output" | awk '/load average:/ {print $11}' | sed 's/[,']//g)
        echo "$load_avg"

    else
        # load-avg last 15 min
        load_avg=$(echo "$top_output" | awk '/load average:/ {print $12}' | sed 's/[,'\'']//g')
        echo "$load_avg"
    fi
}


send_metrics_to_statsd(){
    local counter=$1
    local metric_suffix=$2
    local final_metric="$METRIC_PREFIX.$metric_suffix"

    # send metric command
    echo "$final_metric:$counter|c" | nc -w 1 -u $STATSD_HOST $STATSD_PORT
}

main(){

    # send metric forever
    while true; do

        local top_output=$(get_top_output)
        local load_avg_str=$(echo "$top_output" | awk '/load average:/')

        # get load avg for last 1min , 5min , 15min
        local load_avg_1_min=$(get_load_avg 1 "'$top_output'")
        local load_avg_5_min=$(get_load_avg 5 "'$top_output'")
        local load_avg_15_min=$(get_load_avg 15 "'$top_output'")

        # send metric
        send_metrics_to_statsd $load_avg_1_min "one"
        send_metrics_to_statsd $load_avg_5_min "five"
        send_metrics_to_statsd $load_avg_15_min "fifteen"

        # sleep
        sleep $SLEEP_TIME
    done
}


# call main method
main
