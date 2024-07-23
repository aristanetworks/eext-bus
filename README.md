# Interactive workflow for eext
This repo hosts the code for supporting an interactive worfklow for [eext](https://aid/13327).

Pls refer to the [eext User Guide](https://aid/13327) on how your work with the eext tool. This page just helps you setup the environment that has the eext tool avaiable.

## eext docker container on existing EOS homebus
Using [Barney Docker Registry](https://aid/11103), we export a docker image for the eext development environment.
Your EOS homebus supports running docker containers. You can run an eext docker container in your EOS homebus (outside a4c container).
The docker image is:
`barney-docker.infra.corp.arista.io/code.arista.io/eos/tools/eext-bus`.

### Shell configuration
Setup some shell functions/aliases to make the creation of eext containers and opening new shells within the eext container easy.
These also set up access to your Central Home Directory (CHD) inside the eext container.

Please add the following to your shell configuration (Eg: .bashrc file):
```
EEXTC_NAME="${USER}-eext"
EEXTC_ARGS="--name ${EEXTC_NAME} -d --cap-add CAP_SYS_ADMIN -v /home/${USER}:/home/${USER} -e LOCAL_USER=${USER} -e LOCAL_UID=$(id -u $USER) -e LOCAL_GID=$(id -g $USER)"
function eext_image_name() {
   set -x
   local eextbus_sha
   eextbus_sha=$(git ls-remote https://github.com/aristanetworks/eext-bus refs/heads/main | cut -f 1)
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
### Usage
You can now use the `eextc` alias to create a container. Just running this will not enter the container.
You can run `eexte` to open a shell in the new container, or to further create more shell sessions.

#### Example usage
##### Creating the container
```
~ @aajith-home-njj5v# eextc
++ eext_image_name
++ set -x
++ local eextbus_sha
+++ git ls-remote https://github.com/aristanetworks/eext-bus refs/heads/main
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
Status: Downloaded newer image for barney-docker.infra.corp.arista.io/code.arista.io/eos/tools/eext-bus:main
2f424ebc511ea6a3e151a58f5f13933bab10121db3740b021aa8bbc106d09fcd
```
Be warned that the pull can take a few minutes if the image is not in the Barney snapshot cache.
##### Setting up a shell inside the container
```
~ @aajith-home-njj5v# eexte
[aajith@cd83fcd655da ~] which eext
/usr/bin/eext
```

#### Updating to the latest eext container image.
If you want to update the eext image, remove the old container and run eextc again.
```
~ @aajith-home-njj5v# docker rm -f ${EEXTC_NAME}
~ @aajith-home-njj5v# eextc
```

