# Spring Boot REST API

This is a simple Spring Boot REST API application.

## Prerequisites

- Java 22 (JDK)
- Maven
- Docker

## Building the Project

To build the project, run the following command:

```sh
mvn clean package

## create image from Docker file 
docker build -t spring-boot-rest-api:latest .

## tag image so you can push it to DOCKER HUB
docker tag spring-boot-rest-api  bitsinbyte/spring-boot-rest-api:latest

### Create deployment.

Create Deployment.yml

kubectl create deployment spring-boot-rest-api \
  --image=bitsinbyte/spring-boot-rest-api:latest \
  --replicas=2

=====================================================
Create Services

Create Service as ClusterIp
kubectl expose deployment/spring-boot-rest-api --type=ClusterIp --port=8080

## Access it from a temp pod
kubectl run test-client --rm -it --image=busybox -- /bin/sh

wget -qO- http://spring-boot-rest-api:8080/hello



Create Service as NodePort
kubectl expose deployment/spring-boot-rest-api --type=ClusterIp --port=8080

## To check if type is NodePort

curl -v http://<target-EC2-private-IP>:31307
Note: IP must be of worker node where pods are running.


##Need to configure Cloud control manager
https://devopscube.com/aws-cloud-controller-manager/

It is required to integrate ELB for kubernetes


##Create Service as Loadbalancer :

apiVersion: v1
kind: Service
metadata:
  name: spring-boot-rest-api
  labels:
    app: spring-boot-rest-api
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
    service.beta.kubernetes.io/aws-load-balancer-healthcheck-path: "/hello"
    service.beta.kubernetes.io/aws-load-balancer-healthcheck-port: "8080"
spec:
  externalTrafficPolicy: Cluster
  type: LoadBalancer
  selector:
    app: spring-boot-rest-api
  ports:
  - protocol: TCP
    port: 8080
    targetPort: 8080


## To check if type is NodePort

curl -v http://<target-EC2-private-IP>:31307
Note: IP must be of worker node where pods are running.

## To Check if type is Loadbalancer
kubectl get svc 

http:// <nlb dns>:8080/hello

## If you don't get o/p  remove controlplane node from target group.

