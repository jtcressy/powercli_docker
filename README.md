# ubuntu-node-pscore
A docker container running vSphere PowerCLI core and Powershell, with a web terminal powered by nodejs

Command:
``docker run -dit -p 8088:8088 jtcressy/ubuntu-node-pscore bash``
Optional env vars:
``-e WEB_SHELL=bash`` Change your web shell to something else (e.g. powershell)
