FROM ubuntu:14.04
RUN sh -c 'echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/dotnet-release/ trusty main" > /etc/apt/sources.list.d/dotnetdev.list' \
    apt-key adv --keyserver apt-mo.trafficmanager.net --recv-keys 417A0893 \
    apt-get update -y \
    apt-get install dotnet-dev-1.0.0-preview2-003131 -y \
    bash <(curl -fsSL https://raw.githubusercontent.com/PowerShell/PowerShell/v6.0.0-alpha.10/tools/download.sh) \
    apt-get update \
    apt-get install python-pip \
    apt-get install ruby2.0 \
    apt-get install wget \
    cd /home/ubuntu \
    wget https://aws-codedeploy-us-east-1.s3.amazonaws.com/latest/install \
    chmod +x ./install \
    ./install auto \
    curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - \
    sudo apt-get install -y nodejs
ADD ./scripts /scripts
