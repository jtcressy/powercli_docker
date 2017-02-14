FROM ubuntu:16.04
# install packages to use new repositories
RUN apt-get update && \
    apt-get -y install apt-transport-https curl

###install powershell
RUN curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | tee /etc/apt/sources.list.d/microsoft.list \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && apt-get update \
    && apt-get install powershell \
    && apt-get clean
    
### Install .NET Core
RUN apt-get update \
    && apt-get install apt-transport-https curl -y \
    && sh -c 'echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/dotnet-release/ xenial main" > /etc/apt/sources.list.d/dotnetdev.list' \
    && apt-get update \
    && apt-key adv --keyserver apt-mo.trafficmanager.net --recv-keys 417A0893 \
    && apt-get update \
    && apt-get install dotnet-dev-1.0.0-preview2-003121 -y \
    && mkdir /powershell \
    && apt-get clean

# install dependencies
RUN apt-get -y install ca-certificates libunwind8 unzip wget libcurl4-openssl-dev htop vim nano docker.io g++ gcc make gdb gdbserver
RUN apt-get -y install -f
# CD to temp directory, download & install PowerCLI modules
RUN mkdir -p ~/.local/share/powershell/Modules && \
    cd /tmp && wget https://download3.vmware.com/software/vmw-tools/powerclicore/PowerCLI_Core.zip && \
    unzip PowerCLI_Core.zip && unzip 'PowerCLI.*.zip' -d ~/.local/share/powershell/Modules

# scripts folder to hold powershell scripts 
ADD ./scripts /projects/scripts
# Cleanup
RUN rm -r /tmp/PowerCLI*
RUN apt-get clean
RUN export PATH=$PATH:/projects/scripts
VOLUME /projects
WORKDIR /projects
ENTRYPOINT ["/bin/bash"]
EXPOSE 8088
CMD tail -f /dev/null