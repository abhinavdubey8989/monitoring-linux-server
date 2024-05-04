
# aim : start all monitoring scripts
# sample use : "./<this-script-name>.sh "
# starts all scripts in bk-ground


./monitor_cpu_usage.sh &
./monitor_load_avg.sh &
./monitor_memory_usage.sh &
./monitor_network_traffic.sh &
./monitor_tcp.sh &