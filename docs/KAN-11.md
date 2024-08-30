# deploy nginx on local k8 kind on runner that sit on my local machin 


## Task Description

install github action runner on local machine and deploy deployment on local kubernetes kind

## Steps 

- **Step 1**: install kind 
- **Step 2**:create kubernetes cluster 
- **step 3**:Install runner
- **step 4**:create secret with kubernetes context
- **step 5**:run our pipline for deploy nginx container on kubernetes 


### Prerequisites

- docker installed on your machine  

### Steps

1. **install kind**
```bash
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.23.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind    
```


2. **create kubernetes cluster:**
for create kubernetes cluster enter to next commands
```bash
    kind create cluster 
```
 

3. **Install runner :**

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
4. **create secret with kubernetes context:**  
now we need to create github action secret that contain our context 
we need navigate to our context usually is located in home/.kube folder 
first cat the contant of kubeconfig by next command  
 ```bash
 cat config
  ```
and copy the contant of this file than go to github type settings and choose secret and variables and choose action and create new secret 

5. **run our pipline for deploy nginx container on kubernetes :**

name: deploy to kubernetes using kind



on: push

jobs:
  docker-login:
    runs-on: [self-hosted,Linux,X64]
    steps:
      - name: Check out the repository
        uses: actions/checkout@v3
       
      - name: Create .kube directory
        run: mkdir -p ~/.kube 
      
      - name: Set up kubeconfig
        env:
          KUBECONFIG: ${{ secrets.KUBECONFIG }}  # Use a kubeconfig stored in GitHub Secrets
        run: |
          echo "$KUBECONFIG" > ~/.kube/config
      - name: use context 
        run: |
         kubectl config use-context kind-daniel  
      
      - name: run kubectll
        run: |

         kubectl apply -f https://k8s.io/examples/controllers/nginx-deployment.yaml
        
         kubectl get pod
        
![get pod](https://github.com/danielbachar11/python2/blob/main/.photos/get_pod.png)        



