#!/bin/bash

#build a Docker image

echo "Marking with this for easy tagging:  rplocalbuild."

echo "Name for the image?"
read NAME
echo "Tag for the image?"
read TAG

#sudo docker build -t nachochip/$NAME:$TAG .
sudo docker build -t rplocalbuild/$NAME:$TAG .
