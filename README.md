# ubuntu-node-pscore
A docker container running vSphere PowerCLI core and Powershell, with a web terminal powered by nodejs

Command:
``docker run -it jtcressy/ubuntu-node-pscore bash``

Docker.io is installed in this container, connect to your docker daemon by:

1. Mounting this volume: ``-v /var/run/docker.sock:/var/run/docker.sock``
2. Connecting via API: ``# docker -H tcp://<host>:<port> [--tls]``
3. Using an env variable to define the default daemon URL: ``-e DOCKER_OPTS="-H tcp://<host>:<port>"``
    - Use appropriate tls options if necessary
