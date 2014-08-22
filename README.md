# What will you find here ?

This repository is used to build the boot2docker iso used by vagrant and
prepare it to be used with fig and shared folders. It includes the Virtualbox
Guest Additions so we can create a lightweight dev environment with fig &
boot2docker on OSX.

Objectives are:
- We use boot2docker as vanilla as possible (using official Docker index or building it from boot2docker official github repo)
- We want to share folders with virtualbox shared folder in vagrant. This is not the best method but usefull anyway.
- We want to include the Virtual Guest Additions so we can easily share folders from the host system.
- We want the basebox build process to be as ligthweight as possible.

# Building the basebox

Simply run:
```
bash make.sh
```

This will create a boot2docker-vagrant.iso which can be used by boot2docker.

Running
```
VBoxManage sharedfolder add boot2docker-vm -name home -hostpath /Users
```
after `boot2docker init` and before `boot2docker up` will allow you to seamlessly
use fig on your OSX machine.

Attention: be aware of the security implications of sharing your /Users dir with
the boot2docker VM. Follow this discussion for more information: https://github.com/boot2docker/boot2docker-cli/issues/202

## Credits

This repository is a combination of work by [Mitchell Hashimoto](https://github.com/mitchellh/boot2docker-vagrant-box), [dduportal](https://github.com/dduportal/boot2docker-vagrant-box) and [Matthias Kadenbach](https://gist.github.com/mattes/2d0ffd027cb16571895c), so all credits go to them!