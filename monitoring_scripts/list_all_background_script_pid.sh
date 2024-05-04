



# Store the first PID found in a variable
CPU_USAGE=$(ps aux | grep "monitor_cpu_usage.sh" | grep -v grep | awk '{print $2; exit}')
LOAD_AVG=$(ps aux | grep "monitor_load_avg.sh" | grep -v grep | awk '{print $2; exit}')
MEM_USAGE=$(ps aux | grep "monitor_memory_usage.sh" | grep -v grep | awk '{print $2; exit}')
NETWORK_ACTIVITY=$(ps aux | grep "monitor_network_traffic.sh" | grep -v grep | awk '{print $2; exit}')

# Print PID
echo "CPU_USAGE script PID : $CPU_USAGE"
echo "LOAD_AVG script PID : $LOAD_AVG"
echo "MEM_USAGE script PID : $MEM_USAGE"
echo "NETWORK_ACTIVITY script PID : $NETWORK_ACTIVITY"
