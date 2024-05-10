FROM linuxserver/code-server

RUN sudo apt-get update && sudo apt-get dist-upgrade -y && sudo apt-get install -y gnupg software-properties-common \
    curl apt-transport-https ca-certificates lsb-release unzip python3-pip vim screen

### Install tfenv for terraform
RUN git clone https://github.com/tfutils/tfenv.git ~/.tfenv && ln -s ~/.tfenv/bin/* /usr/bin

### Install hugo
RUN apt-get install -y hugo

### Install adb
RUN apt-get install -y adb

### Install helm
RUN curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" \
     | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list && \
    sudo apt-get update && \
    sudo apt-get install helm

### Install kubectl
RUN curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg && \
    sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg && \
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
    sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list && \
    sudo apt-get update && \
    sudo apt-get install -y kubectl

### Remove old Docker
RUN sudo apt-get remove -y docker docker.io containerd runc

### Install new docker
RUN sudo mkdir -p /etc/apt/keyrings && \
 curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN sudo apt-get update && \
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

### Let the default user use docker for DIND
RUN sudo usermod -aG docker abc