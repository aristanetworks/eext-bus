# Interactive workflow for eext
This repo hosts the code for supporting an interactive worfklow for [eext](https://aid/13327).

There are two variants for this workflow:
1. eext docker container on existing EOS homebus.
2. eext homebus.

Both of them share most of the parts of the workflow. The choice you have to make is whether you want to work in your EOS home bus itself, or would you rather prefer having a separate homebus for your eext work.
Once you enter the environment with the eext tool/binary, both workflows converge.
Pls refer to the [eext User Guide](https://aid/13327) on how your work with the eext tool. This page just helps you setup the environment that has the eext tool avaiable.

## eext docker container on existing EOS homebus
Using [Barney Docker Registry](https://aid/11103), we export a docker image for the eext homebus development environment.
Your EOS homebus and supports running docker containers. You can run an eext development container in either environment.
You can setup access to your Central Home Directory (CHD) in this container.
The docker image is:
`barney-docker.infra.corp.arista.io/code.arista.io/eos/tools/eext-bus:aajith-eext-devworkflow`.

You can setup a few shell aliases in your `.bashrc` to make it easier to create a new docker container or to shell into an existing container.
```
EEXTC_NAME="${USER}-eext"
EEXTC_ARGS="--name ${EEXTC_NAME} -d --cap-add CAP_SYS_ADMIN -v /home/${USER}:/home/${USER} -e LOCAL_USER=${USER} -e LOCAL_UID=$(id -u $USER) -e LOCAL_GID=$(id -g $USER)"
function eext_image_name() {
   set -x
   local eextbus_sha
   eextbus_sha=$(git ls-remote https://github.com/aristanetworks/eext-bus refs/heads/aajith-eext-devworkflow | cut -f 1)
   echo "barney-docker.infra.corp.arista.io/code.arista.io/eos/tools/eext-bus:${eextbus_sha}"
   set +x
}
function eextc() {
   set -x
   docker pull "$(eext_image_name)"
   docker run ${EEXTC_ARGS} $(eext_image_name)
   set +x
}
alias eexte="docker exec -it ${EEXTC_NAME} sudo su - ${USER}"
```

You can now use the `eextc` alias to create a container. Just running this will not enter the container.
You can run `eexte` to open a shell in the new container, here the eext tool is available along with your CHD.
You can keep running `eexte` to open new shells in the same container.
```
~ @aajith-home-njj5v# eextc
++ eext_image_name
++ set -x
++ local eextbus_sha
+++ git ls-remote https://github.com/aristanetworks/eext-bus refs/heads/aajith-eext-devworkflow
+++ cut -f 1
++ eextbus_sha=7084fa3e2f488264f1406ed72e4f4986073b024e
++ echo barney-docker.infra.corp.arista.io/code.arista.io/eos/tools/eext-bus:7084fa3e2f488264f1406ed72e4f4986073b024e
++ set +x
+ docker pull barney-docker.infra.corp.arista.io/code.arista.io/eos/tools/eext-bus:7084fa3e2f488264f1406ed72e4f4986073b024e
b79495462cd4: Already exists
6762c4b26f94: Already exists
140ebc0869fa: Already exists
f4178e408212: Pull complete
2128458a71f4: Pull complete
0e4c93f02cb3: Pull complete
b5145326fd57: Pull complete
62a4b9a2069d: Pull complete
Digest: sha256:9d5a0b4b5a48a32e66b28cf5a3e72c3bde4ea9d3a30ca4db86c93987f85aaec7
Status: Downloaded newer image for barney-docker.infra.corp.arista.io/code.arista.io/eos/tools/eext-bus:aajith-eext-devworkflow
2f424ebc511ea6a3e151a58f5f13933bab10121db3740b021aa8bbc106d09fcd
```
Be warned that the pull can take a few minutes if the image is not in the Barney snapshot cache.
```
~ @aajith-home-njj5v# eexte
[aajith@cd83fcd655da ~] which eext
/usr/bin/eext
```
If you want to update the eext image, remove the old container and run eextc again.
```
~ @aajith-home-njj5v# docker rm -f ${EEXTC_NAME}
~ @aajith-home-njj5v# eextc
```
## eext homebus
<span style="color:red"><b>NOT YET SUPPORTED</b></span>

Similar to how the EOS homebus has the `a4c` binary installed, the eext homebus has the `eext` binary installed.
You can create an eext homebus in a similar way to how you create your EOS homebus, by using the [Aboard](https://aboard.infra.corp.arista.io/bus/create) form.
1. Set `BUS Image` as `code.arista.io/eos/tools/eext-bus:homebus#aajith-eext-devworkflow`.
2. Set both `BUS Nickname` and `BUS Topic` as `eext-home`.

You can log into the eext homebus similar to how you would log into an EOS homebus.
You'll have root access in the homebus, and you can `dnf install` any tools you want.
Eg: `dnf install -y vim-enhanced sudo`.
```
~ @aajith-eext-homehome-njj5v# which eext
/usr/bin/eext
```

