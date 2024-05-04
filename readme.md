

# Aim

The aim here is to monitor a server on which one or more services run.
We are specifically monitoring for CPU-load , TCP , network in/out etc.
There are custom scripts to
- build image (build_image.sh)
- scrape/extract server metrics & send it to statsd (send_load_avg.sh)
- mimic load on server (put_load.sh)

# How to

Once the image is build (using `build_image.sh`) & the container is started (using `./start_or_stop.sh 1`) , We need to go inside the container .
Once inside the container , run : 
- `cd monitoring_scripts`
- `./start_all_monitoring.sh`