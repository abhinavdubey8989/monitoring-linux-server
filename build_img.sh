

# aim : build the docker image for a linux server
# sample use : "./<this-script-name>.sh "


IMG_NAME=my_ubuntu_server

docker build -t $IMG_NAME .