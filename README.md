# Docker Example

If you use the `run-gcc` script to invoke the docker image, it
will start in the same directory that the caller is in and be running
with the uid and gid of the caller.

## Rename the docker image

Edit `Makefile` and change the name of the docker image (the `DOCKER_IMAGE variable`). Make the same change to the `run-gcc` file (variable `IMAGE_NAME`)

## Building the docker image

Edit `Dockerfile` to build your docker image. You can use `make build` to 
build the docker image.

## Push the docker image (optional)

If desired, you can push the docker image to the docker repository using `make push`

## Rename run-gcc

The name of the `run-gcc`` is arbitrary. Rename it to something meaningful.

## Run the docker image

If you use `run-gcc` with no arguments, then the docker image will start a bash shell in the same directory inside the docker image that the `run-gcc` command was invoked from.

If you use `run-gcc` followed by additional arguments, then the additional arguments will be run in the same directory inside the docker container that the `run-gcc` command was invoked from.

## Directories mounted in the docker container

If you're outside a git tree, then the current directory will be mouned (under the same path). This can cause problems if you run the docker image from a system directory, like /usr or /etc.

If you're inside a git repository then the root of the git tree will be mounted (under the same path). If the git repository is a git worktree then the directory containing the repository files will also be mounted.

Running `run-gcc` with no arguments from inside your home directory will attempt to run your `.bashrc` and `.bash_profile` which is often undesirable.

## Serial port access

The user created inside the docker container is added to the `dialout`
group, and `/dev/bus/usb` is mounted from the host into the docker and
all `/dev/ttyUSB*` and `/dev/ttyACM*` devices are also shared to docker,
so this means that programs running inside the docker container can access
the serial ports.
