#!/bin/bash


#variables
CGROUP_NAME="container"
HOSTNAME="demo"
CPU_SHARES="512"
MEMORY_LIMIT="100M"

LOWER_DIR="./container"
UPPER_DIR="./upper"
WORK_DIR="./work"
MERGED_DIR="./merged"


#directories creation
if [ ! -d "$LOWER_DIR" ]; then
    mkdir -p "$LOWER_DIR"/{bin,proc,sys,etc,tmp}
    BUSYBOX_PATH=$(which busybox)
    if [ -z "$BUSYBOX_PATH" ]; then
        echo "Please install busybox first"
        exit 1
    fi

    cp "$BUSYBOX_PATH" "$LOWER_DIR/bin/"
    ln -s busybox "$LOWER_DIR/bin/sh"

else
    echo "Filesystem already exists"
fi

mkdir -p "$UPPER_DIR" "$WORK_DIR" "$MERGED_DIR"

#overlayfs creation
mount -t overlay overlay -o \
    lowerdir=$LOWER_DIR,upperdir=$UPPER_DIR,workdir=$WORK_DIR \
    $MERGED_DIR
echo "Mount point at $MERGED_DIR"

#cgroups config
mkdir -p "/sys/fs/cgroup/$CGROUP_NAME/PID-$$"
echo "+memory" > "/sys/fs/cgroup/$CGROUP_NAME/cgroup.subtree_control"
echo "$MEMORY_LIMIT" > "/sys/fs/cgroup/$CGROUP_NAME/memory.max"
echo $$ > "/sys/fs/cgroup/$CGROUP_NAME/PID-$$/cgroup.procs"

#namespaces and chroot
unshare --pid --mount --uts --ipc --net --fork --mount-proc \
    /bin/bash -c " \
    hostnamectl set-hostname $HOSTNAME; \
    chroot $MERGED_DIR /bin/sh"

echo "Container exited"

exit 0