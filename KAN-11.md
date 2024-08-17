# My Awesome Project

## Task Description

install github action runner on local machine and deploy deployment on local kubernetes kind

## Steps (to complete the task)

- **Step 1**: install kind  ...
- **Step 2**:create kubernetes cluster ...
- **Step 3**: install helm..

## Installation

To get started with My Awesome Project, you’ll need to install the necessary dependencies. Follow these steps to set it up on your local machine:

### Prerequisites

- docker installed on your machine  

### Steps

1. **install kind**


[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.23.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind    


2. **create kubernetes cluster:**
for create kubernetes cluster enter to next commands
    ```bash
    kind create cluster 
    ```
 

3. **install helm:**
```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

4. **Install runner :**

lets enter to our repo and type on actions 
in lest side type runners and choose self-hosted runners and type new runner and type new self-hsted runner 
now lets use linux runner and use next code to run it 

   ```bash
    curl -o actions-runner-linux-x64-2.319.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.319.1/actions-runner-linux-x64-2.319.1.tar.gz
    echo "3f6efb7488a183e291fc2c62876e14c9ee732864173734facc85a1bfb1744464  actions-runner-linux-x64-2.319.1.tar.gz" | shasum -a 256 -c
    tar xzf ./actions-runner-linux-x64-2.319.1.tar.gz
    ./config.sh --url https://github.com/danielbachar11/mock_devops_tasks --token 
    (put our token here)
     ```
5. **create secret with kubernetes context:**  
now we need to create github action secret that contain our context 
we need navigate to our context usely is located in .kube folder 
first cat the contant of kubeconfig by next command  
 ```bash
 cat config
  ```
and copy the contant of this file than go to github type settings and choose secret and variables and choose action and create new secret as a picture 
![here](https://github.com/danielbachar11/python2/blob/main/SECRET.png)

6. **run our pipline for deploy nginx container on kubernetes :**

name: deploy to kubernetes using kind

on: pull_request

jobs:
  docker-login:
    runs-on: [self-hosted, linux, x64] # we run our pipline on this runner with this labels
    steps:
    - name: Check out repository code
      uses: actions/checkout@v4
    - name: install kubectl 
      run: |
         curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
         curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
         echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check  
   
    - name: create context from secret # here we use echo to our 
      run: |
        echo "${{ secrets.KUBECONFIG }}" > ~/.kube/config
    - name: use context 
      run: kubectl config use-context kind-daniel
     
         
   
    - name: run kubectll
      run: |
        kubectl get pod
        kubectl apply -f https://k8s.io/examples/controllers/nginx-deployment.yaml
        kubectl get deploy
        kubectl get pod



