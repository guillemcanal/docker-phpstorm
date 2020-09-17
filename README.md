# Build the Docker image

```
make build
```

# Use the image

On a WSL2 Distro with an X11 server running on Windows (X410 or vcxsrv) with public access.

```
export DISPLAY="$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0"

docker run --init -d --rm --name phpstorm \
  -e DISPLAY \
  -e USER_NAME=$USER \
  -e USER_UID=$(id -u) \
  -e USER_GID=$(id -g) \
  -v $HOME:$HOME \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  $USER/phpstorm
```
