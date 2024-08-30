# build nginx website using docker images one for dev and one for prod environment and deploy to k8 with 


## Task Description

deploy nginx website on local k8 for 2 diffrent enviornment 

## Steps 

- **Step 1**: create in kubernetes 2 name space
- **Step 2**: create piple that build and push image to dev environment
- **step 3**: create piple that build and push image to prod environment   
- **step 4**: deploy our image on kubernetes
- **step 5**: deploy prod image to prod name space kubernetes:**   




### Prerequisites

- kubernetes cluster  

### Steps

1. **create github repo with folder like this method:**

        1.1 create folder name images/custom-nginx and inside this folder put your Dockerfile
        1.2 inside this folder create new folder and give name app and put there our html file 
        1.3 create folders kubernetes/local-cluster/dev for dev deployment
        1.4 create folders kubernetes/local-cluster/prod for prod deployment



2. **create piple that build and push image to dev environment:**

now lets create pipline that build and push dev image and the trigger is only when change occur in this path "images/custom-nginx" and the pipline will run on any branch in push 
```bash
name: build and push nginx website 
on:
 push:
  
  paths:
      - 'images/custom-nginx**'

jobs:
  docker_build_push:
    runs-on: [self-hosted,Linux,X64] # we run it on our runner 
    steps:
      - name: Check out the repository
        uses: actions/checkout@v3
       
      - name: docker login 
        run: docker login -u ${{secrets.DOCKER_USER}} -p ${{secrets.DOCKER_PASSWORD}}
      
      - name: build docker  and push to docker hub 
        run: |
          
          cd images/custom-nginx
          docker build -t danielbachar/nginx_website:latest_dev_image . 
          ocker push danielbachar/nginx_website:latest_dev_image
```
          

3. **create piple that build and push image to prod environment:**
now lets create pipline that build and push prod image and the trigger is only when change occur in this path "images/custom-nginx" and the pipline will run only on main branch in push  
```bash
`name: build and push to docker hub for prod

on:
 push:
  branches: ["main"]
  
  paths:
      - 'images/custom-nginx**'

jobs:
  docker_build_push_image:
    runs-on: [self-hosted,Linux,X64]
    steps:
      - name: Check out the repository
        uses: actions/checkout@v3
       
      - name: docker login 
        run: docker login -u ${{secrets.DOCKER_USER}} -p ${{secrets.DOCKER_PASSWORD}}
      
      - name: build image and push to docker hub 
        run: |
          
          cd images/custom-nginx
          docker build -t danielbachar/nginx_website:latest_prod image .
          
          docker push danielbachar/nginx_website:latest_prod image
```

4. **deploy dev image to dev name space kubernetes:**  

lets deploy our dev image to dev namespace in push on any brach  

first create kubernetes 2 name space one for dev and one for prod 

lets run the next command in our kubernetes cluster

```bash
kubectl create ns dev

kubectl create ns prod
```
lets check that 2 name space is created 
type 
```bash
kubectl get ns 
```
![get name space](https://github.com/danielbachar11/phtoes/blob/main/kan13/get%20ns.png) ####PHOTO

deploy our deployment with pipline on push to any branch only when chaged occur in this path 

'kubernetes/local-cluster/dev**' 

```bash
name: deploy nginx  to dev namespace 

on:
  push:
   paths:
      - 'kubernetes/local-cluster/dev**'
    
jobs:
  checkout:
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
         kubectl apply -f kubernetes/local-cluster/dev
```
now to see our pod lets run
```bash
kubectl -n dev get pod          
```
![get pod](https://github.com/danielbachar11/phtoes/blob/main/kan13/get%20pod%20dev.png) ####PHOTO


5. **deploy prod image to prod name space kubernetes:**  

lets deploy our prod image to prod name space on push only in main branch 
```bash
name: deploy nginx to prod namespace 

on:
  push:
    branches: ["main"]

    paths:
      - 'kubernetes/local-cluster/prod**'
    
jobs:
  checkout:
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
         kubectl apply -f kubernetes/local-cluster/prod
```
now to see our pod lets run
```bash
kubectl -n prod get pod          
```
![get pod](https://github.com/danielbachar11/phtoes/blob/main/kan13/get%20pod%20prod.png) ####PHOTO

now lets do port-forward to see our website let run next command
```bash

kubectl port-forward -n prod prod-deployment-6f8f9c68f5-9mz2j 8083:80

```
now go to web browser and type localhost:8083

now we can see our website 

![port-forwarding](https://github.com/danielbachar11/phtoes/blob/main/kan13/portforward-website.png)



