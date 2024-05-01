

# Aim

The aim here is to monitor a server on which one or more services run.
We are specifically monitoring for CPU-load.
There are custom scripts to
- build image (build_image.sh)
- scrape/extract CPU load & send it to statsd (send_load_avg.sh)
- mimic load on server (put_load.sh)

# How to

Once the image is build (using `build_image.sh`) & the container is started , We need to go inside the container .
Once inside the container , run `chmod +x *.sh` to make the custom scripts executable.
Start the "send_load_avg.sh" script : `./send_load_avg.sh &`.
Then finally put load on server using : `./put_load.sh` .
Monitor the metrics in grafana.