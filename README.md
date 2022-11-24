
# Deploying app using terraform and GCP  
## A Brief on project
Building app using docker and push it to GCR repo on my project on GCP oand deploy it on private kubernetes cluster controlled by private vm, all infrastructure have provisioned using terraform (IaC).
## Project structure 

## Building the app 
### I built the app using docker by creating the following Dockerfile
- I built th app on alpine:python image to ignore installing python then installed the requirements and made sure that all envronment varibale are declared and expsed to the new image

![Screenshot from 2022-11-24 20-19-06](https://user-images.githubusercontent.com/112195672/203847534-c8c560ea-4c4b-4f64-84b8-b230e97ca013.png)


- After building the image using dockerfile and push it to GCR

![Screenshot from 2022-11-18 21-20-51](https://user-images.githubusercontent.com/112195672/203847392-12bc76c6-5a7d-42f9-bd2e-ea28f9e41063.png)

## provisioning the infrastructue 
- I started with setting GCP as my provider 


### Network
- I created a VPC with routing mode ragional as all my infrastructure will impelmented in the same region


- Subnet with CIDR range ["10.0.1.0/24"] in my VPC and name it management subnet 


- Subnet with CIDR range ["10.0.2.0/24"] in my VPC and name it restricted subnet 


- Then created the firewalll to accept only ssh connection on port 22 with a target to tag to assign it to my private subnet only and not the cluster

- Then the router to assign it to the Nat gatway for the vpc

- And the Nat gatway to allow only managment subnet including my private instance to get its packages and updates 

### Service accounts
### I created a two service account one for my instance and one for the GKE cluster as the following
- The one attached to my instance have Role of container admin to have permissions to access my cluster 
- The one for my cluster have the Role of storage viwer to have permission to pull the images from my GCR repo
## Computing instance and GKE
### private VM
- Creating an instance in my managment subnet having tag [ssh] to allow the traffic on port 22 using my firewall and assign the service account to access the GKE
### GKE 
- I created the GKE with in same region zone in my VPC and defining the default created node pool to false to create my own pool but but the intial node count by 1 to create the master node in it 
- ip allocation policy is where i define my pods and services IPs ranges are and this is what i have defined eariler in my restricted subnet as secondry IPs ranges
- configuring the private endpoints and nodes as true as make my cluster private and have no access from outside the subnet and assigning the master_ipv4_cidr_block with range of IPs does not overlap any IPs range of the cluster network to assign a private IP to ILB and my master node to be able to communicate with the worker nodes 
- configure a master authorized network which is my managment subnet CIDR range to open the communication between the private VM and the master node to control the cluster from it 
- creating my worker node pool with name node pool in the same zone where is my cluster and assign the service account which allow give permission Role storage.Voewer to allow the nodes to pull images on GCR or Artifact repos and setting the scoop to be on all  platform

## provision the infrastructure
- Now i can provision this infrastructure using terraform command `terraform apply`
## setting up the VM 

### ssh to the private VM 
- Now i need to ssh the private VM to setup my configuration to my cluster and script the deployment and service yaml files to deploy my app and expose it 
- So first i made sure that the user i use is authorized to access my project and resources 
- next i ssh my private VM
- after ensure that kubectl and gcloud is installed
- i configured my cluster using `gcloud container cluster get-credetintials` 

![Screenshot from 2022-11-18 21-21-30](https://user-images.githubusercontent.com/112195672/203848840-202183f6-a594-4967-9e6e-6165945af2ec.png)


- Now i can write my deployment and service yaml file to deploy them, 

![Screenshot from 2022-11-24 20-29-43](https://user-images.githubusercontent.com/112195672/203849141-74c979da-5a05-4d8a-914f-2b87ea0c2180.png)


so did i 
- Now deploy them using `kubectl apply`
## THE END 
### now ckecking that everything is working as it should be 
- my pods are working correctly 
- my service having its external IP and its selector is set to my pods tag 
- and its endpoint are my pods private IPs on port 8000
- testing the LB external IP with port 8000 on my browser 
![Screenshot from 2022-11-18 21-20-03](https://user-images.githubusercontent.com/112195672/203848668-04b32c2b-0454-4490-aee0-bd55b146e897.png)

![Screenshot from 2022-11-18 21-19-51](https://user-images.githubusercontent.com/112195672/203848677-175e7dba-945f-40d2-bd23-a891d6b8cbd9.png)



