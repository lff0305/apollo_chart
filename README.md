This is a helm chart for installing apollo services in k8s.

Requirement:
- helm3
- A persistent storage (By default, AWS EKS / gp2 is used)

Usage:

Clone the repo and run commnad 
```
kubectl create ns apollo
helm install apollo . -n apollo
```

