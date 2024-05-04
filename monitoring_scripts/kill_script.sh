

# aim : to kill a script using its PID
# sample usage : "./<this-script-name>.sh <script name to kill>"

SCRIPT_TO_KILL=$1

# Store the first PID found in a variable
PID=$(ps aux | grep $SCRIPT_TO_KILL | grep -v grep | awk '{print $2; exit}')

# Print & kill process
echo "killing PID : $PID"
kill $PID
