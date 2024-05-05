


# aim : scrape avg-CPU-load & send it to statsd , 
#     : breaking it down into various categories: last 1 min , last 5 min , last 15 min
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
METRIC_PREFIX="$HOST_NAME.load_avg"

# sleep b/w 2 iteration of while loop
SLEEP_TIME=$SLEEP_INTERVAL_IN_SEC


# get top command snap-shot
# -b flag is for batch
# -n flag is to specify number of iterations to run top command (here we run only once)
get_top_output(){

    # sample output
    # top_output="top - 17:38:34 up 4 min,  0 users,  load average: 0.01, 0.02, 0.03"

    top_output=$(top -bn 1 | awk '/load average:/')
    echo "$top_output" 
}


# this method will extract load of last 1min , 5min , 15min basis the "minute" argument
get_load_avg(){
    local minute=$1
    local top_output=$2
    local load_avg=0
    local comma_separated_load_avg=$(echo "$top_output" | awk -F'load average:' '{print $2}')


    if [ $minute -eq 1 ]; then
        # load-avg last 1 min
        load_avg=$(echo "$comma_separated_load_avg" | awk -F',' '{print $1}' | sed 's/[,']//g)
    elif [ $minute -eq 5 ]; then
        # load-avg last 5 min
        load_avg=$(echo "$comma_separated_load_avg" | awk -F',' '{print $2}' | sed 's/[,']//g)
    else
        # load-avg last 15 min
        load_avg=$(echo "$comma_separated_load_avg" | awk -F',' '{print $3}' | tr -d "',")
    fi

    echo "$load_avg"
}


send_metrics_to_statsd(){
    local counter=$1
    local metric_suffix=$2
    local final_metric="$METRIC_PREFIX.$metric_suffix"

    # print to console
    # echo "$final_metric = $counter"

    # send metric command
    echo "$final_metric:$counter|c" | nc -w 1 -u $STATSD_HOST $STATSD_PORT
}

main(){

    # send metric forever
    while true; do

        local top_output=$(get_top_output)

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
