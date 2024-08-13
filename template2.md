# My Awesome Project

## Task Description

install github action runner on local kubernetes kind

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
 ![alt text](image.png)   

3. **Install Python dependencies:**

    ```bash
    pip install -r requirements.txt
    ```

4. **Install Node.js dependencies:**

    ```bash
    npm install
    ```
    ![Alt text](/docs/pictures/sample2.png)

