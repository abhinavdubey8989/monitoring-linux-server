



# aim : to print PID of all monitoring scripts
# sample usage : "./<this-script-name>.sh"


# Store the first PID found in a variable
CPU_USAGE=$(ps aux | grep "monitor_cpu_usage.sh" | awk '{print $2; exit}')
LOAD_AVG=$(ps aux | grep "monitor_load_avg.sh" | awk '{print $2; exit}')
MEM_USAGE=$(ps aux | grep "monitor_memory_usage.sh" | awk '{print $2; exit}')
NETWORK_ACTIVITY=$(ps aux | grep "monitor_network_traffic.sh" | awk '{print $2; exit}')
TCP_COUNT=$(ps aux | grep "monitor_tcp.sh" | awk '{print $2; exit}')


# Print PID for each
echo "monitor_cpu_usage.sh PID : $CPU_USAGE"
echo "monitor_load_avg.sh PID : $LOAD_AVG"
echo "monitor_memory_usage.sh PID : $MEM_USAGE"
echo "monitor_network_traffic.sh PID : $NETWORK_ACTIVITY"
echo "monitor_tcp.sh PID : $TCP_COUNT"
