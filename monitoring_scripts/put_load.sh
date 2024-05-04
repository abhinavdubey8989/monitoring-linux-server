

# This script helps to mimic increase in CPU load by using "dd" command
# we need to pass the number of seconds for which we need to put the load
# sample use : "./add_load.sh 10" (will put load for 10 seconds)

LOAD_TIME=$1


# defaults to 3033 , ie call API on port 3033
if [ -z "$LOAD_TIME" ] ; then
   echo "null not allowed as load-time"
   exit 1
fi


if [ $LOAD_TIME -lt 1 ]; then
   echo "load-time to be in multiple of 1"
   exit 1
fi


# Increase load on the server using "dd" command for few seconds
echo "adding load for $LOAD_TIME seconds ..."
timeout "${LOAD_TIME}s" dd if=/dev/zero of=/dev/null
