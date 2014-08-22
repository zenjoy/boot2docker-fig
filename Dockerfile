FROM boot2docker/boot2docker
MAINTAINER damien.duportal@gmail.com

RUN rm -f boot2docker.iso

######## VirtualBox Guest Additions building
# You can change the target version here
ENV VBOX_VERSION 4.3.12

RUN apt-get install -y p7zip-full

RUN mkdir -p /vboxguest && \
    cd /vboxguest && \
    curl -L -o vboxguest.iso http://download.virtualbox.org/virtualbox/${VBOX_VERSION}/VBoxGuestAdditions_${VBOX_VERSION}.iso && \
    7z x vboxguest.iso -ir'!VBoxLinuxAdditions.run' && \
    sh VBoxLinuxAdditions.run --noexec --target . && \
    mkdir x86 && cd x86 && tar xvjf ../VBoxGuestAdditions-x86.tar.bz2 && cd .. && \
    mkdir amd64 && cd amd64 && tar xvjf ../VBoxGuestAdditions-amd64.tar.bz2 && cd .. && \
    cd amd64/src/vboxguest-${VBOX_VERSION} && KERN_DIR=/linux-kernel/ make && cd ../../.. && \
    cp amd64/src/vboxguest-${VBOX_VERSION}/*.ko $ROOTFS/lib/modules/$KERNEL_VERSION-tinycore64 && \
    mkdir -p $ROOTFS/sbin && cp x86/lib/VBoxGuestAdditions/mount.vboxsf $ROOTFS/sbin/

# Adding freshly built kernel module
RUN depmod -a -b $ROOTFS $KERNEL_VERSION-tinycore64

# Load the module vboxsf and shared folders when b2d is booting.
RUN echo "modprobe vboxsf && mkdir -v -p /Users && sudo mount -v -t vboxsf  -o uid=0,gid=0 home /Users" >> $ROOTFS/opt/bootsync.sh

#### Build the iso from $ROOTFS
RUN /make_iso.sh
CMD ["cat", "boot2docker.iso"]