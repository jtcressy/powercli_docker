FROM ubuntu:16.04
RUN apt-get update
RUN apt-get install ca-certificates curl libunwind8 libicu52 unzip wget libcurl4-openssl-dev curl wget
RUN wget https://github.com/PowerShell/PowerShell/releases/download/v6.0.0-alpha.11/powershell_6.0.0-alpha.11-1ubuntu1.14.04.1_amd64.deb
RUN dpkg -i powershell_6.0.0-alpha.11-1ubuntu1.14.04.1_amd64.deb
RUN apt-get install -f
RUN mkdir -p ~/.local/share/powershell/Modules
RUN wget https://download3.vmware.com/software/vmw-tools/powerclicore/PowerCLI_Core.zip
RUN unzip PowerCLI_Core.zip && unzip 'PowerCLI.*.zip' -d ~/.local/share/powershell/Modules
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash -
RUN apt-get install -y nodejs vim nano
RUN npm install web-terminal -g
ADD ./scripts /scripts
#configurable env var to change default shell on web interface
ENV WEB_SHELL=bash 
RUN export PATH=$PATH:/scripts
EXPOSE 8088

CMD ["web-terminal --port 8088 &"]