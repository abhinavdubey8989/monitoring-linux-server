


# this script is to be run as a cron 
# however due to systemd restrictions in docker containers , we are running it as infinite for loop
# the aim of this script is to scrape the detail of CPU usage, 
# breaking it down into various categories: user processes, system processes, nice tasks, idle time, wait time, hardware interrupts (HI), software interrupts (SI), and steal time (ST)
# from statsD is send to graphite & visualized in grafana
# sample usage : "./monitor_cpu_usage.sh &"
# "&" sign at the end will run this script in background

# statsd config
STATSD_HOST=host.docker.internal
STATSD_PORT=8125

# metric prefix
METRIC_PREFIX=server_1.cpu_util

# sleep b/w 2 iteration of while loop
SLEEP_TIME=5


# get top command snap-shot
# -b flag is for batch
# -n flag is to specify number of iterations to run top command (here we run only once)
get_top_output(){

    # sample o/p format
    # top_output="%Cpu(s): 100 us,100 sy,  3.3 ni,99.9 id,  5.5 wa,  6.6 hi,  7.7 si,  8.8 st"

    # extract the relevant line from top command which begins with %CPU
    top_output=$(top -bn 1 | awk '/%Cpu/')
    echo "$top_output" 
}


# this method will extract get_cpu_util_percent for various categories
# since the number of digits may vary (cpu util for idle can be 99.9 or 100) , we are using the below awk format
get_cpu_util_percent(){

    local type=$1
    local top_output=$2
    local cpu_util=0

    if [ $type = "user" ]; then
        cpu_util=$(echo "$top_output" | awk -F'us,' '{print $1}' | awk -F'[ ,]' '/:/{print $(NF-1)}')
    elif [ $type = "system" ]; then
        cpu_util=$(echo "$top_output" | awk -F'sy,' '{print $1}' | awk -F'[ ,]' '/us/{print $(NF-1)}')
    elif [ $type = "idle" ]; then
        cpu_util=$(echo "$top_output" | awk -F'id,' '{print $1}' | awk -F'[ ,]' '/ni/{print $(NF-1)}')
    elif [ $type = "iowait" ]; then
        cpu_util=$(echo "$top_output" | awk -F'wa,' '{print $1}' | awk -F'[ ,]' '/id/{print $(NF-1)}')
    elif [ $type = "steal" ]; then
        cpu_util=$(echo "$top_output" | awk -F'st,' '{print $1}' | awk -F'[ ,]' '/si/{print $(NF-1)}')
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
        local cpu_util_percent_user=$(get_cpu_util_percent "user" "'$top_output'")
        local cpu_util_percent_system=$(get_cpu_util_percent "system" "'$top_output'")
        local cpu_util_percent_idle=$(get_cpu_util_percent "idle" "'$top_output'")
        local cpu_util_percent_iowait=$(get_cpu_util_percent "iowait" "'$top_output'")
        local cpu_util_percent_steal=$(get_cpu_util_percent "steal" "'$top_output'")

        # testing
        # get_cpu_util_percent "user" "'$top_output'"
        # get_cpu_util_percent "system" "'$top_output'"
        # get_cpu_util_percent "idle" "'$top_output'"
        # get_cpu_util_percent "iowait" "'$top_output'"
        # get_cpu_util_percent "steal" "'$top_output'"

        # send metric
        send_metrics_to_statsd $cpu_util_percent_user "user"
        send_metrics_to_statsd $cpu_util_percent_system "system"
        send_metrics_to_statsd $cpu_util_percent_idle "idle"
        send_metrics_to_statsd $cpu_util_percent_iowait "iowait"
        send_metrics_to_statsd $cpu_util_percent_steal "steal"

        # sleep
        sleep $SLEEP_TIME

    done
}


# call main method
main
