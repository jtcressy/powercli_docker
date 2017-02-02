FROM ubuntu:16.04
RUN apt-get update
RUN apt-get -y install ca-certificates curl libunwind8 unzip wget libcurl4-openssl-dev

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | tee /etc/apt/sources.list.d/microsoft.list
RUN apt-get update
RUN apt-get -y install powershell

RUN apt-get -y install -f
RUN mkdir -p ~/.local/share/powershell/Modules
RUN wget https://download3.vmware.com/software/vmw-tools/powerclicore/PowerCLI_Core.zip
RUN unzip PowerCLI_Core.zip && unzip 'PowerCLI.*.zip' -d ~/.local/share/powershell/Modules
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash -
RUN apt-get install -y nodejs vim nano
RUN npm install web-terminal -g
RUN apt-get -y install vagrant htop vim
RUN vagrant plugin install vagrant-vsphere
ADD ./scripts /scripts
#configurable env var to change default shell on web interface
ENV WEB_SHELL=bash 
RUN export PATH=$PATH:/scripts
EXPOSE 8088

CMD ["web-terminal --port 8088 &"]