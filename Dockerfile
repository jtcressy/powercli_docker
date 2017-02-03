FROM ubuntu:16.04
# install packages to use new repositories
RUN apt-get update && \
    apt-get -y install apt-transport-https curl
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash -
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | tee /etc/apt/sources.list.d/microsoft.list
RUN apt-get update
# install dependencies
RUN apt-get -y install ca-certificates libunwind8 unzip wget libcurl4-openssl-dev htop vim nano nodejs powershell
RUN apt-get -y install -f
# CD to temp directory, download & install PowerCLI modules
RUN mkdir -p ~/.local/share/powershell/Modules && \
    cd /tmp && wget https://download3.vmware.com/software/vmw-tools/powerclicore/PowerCLI_Core.zip && \
    unzip PowerCLI_Core.zip && unzip 'PowerCLI.*.zip' -d ~/.local/share/powershell/Modules

# install web-terminal and nodejs
RUN npm install web-terminal -g
# scripts folder to hold powershell scripts 
ADD ./scripts /scripts
# Cleanup
RUN rm -r /temp/PowerCLI*
RUN apt-get clean
# configurable env var to change default shell on web interface
ENV WEB_SHELL=bash 
RUN export PATH=$PATH:/scripts
EXPOSE 8088
CMD ["/usr/bin/web-terminal", "--port", "8088", "&"]