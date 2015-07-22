This Dockerfile helps create an automated build inside a debian:wheezy container.

The purpose behind this is to build ffmpeg inside a debian container.
       Then the next step is to export the compiled binaries into an untouched base debian image
       See my other repository "ffmpeg"
       This results in a ~128MB image to use, vs a ~395MB file.
       FYI:  this image is useable....I just like having a smaller base image to download.

Example command
docker run nachochip/ffmpeg -i INPUT -vcodec copy -acodec copy - > OUTPUT.mp4

This container uses the entrypoint="ffmpeg"

