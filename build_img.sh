


# this script is used to build the docker image for a linux server
# sample usage : "./build_image.sh"

IMG_NAME=my_ubuntu_server

docker build -t $IMG_NAME .