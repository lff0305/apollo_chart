# General info

This is a helm chart for installing apollo services in k8s.

Requirement:
- helm3
- A persistent storage (By default, AWS EKS / gp2 is used)

# Usage

Clone the repo and run commnad 
```
kubectl create ns apollo                  /// It is recommonded a new namespace is created
helm install apollo . -n apollo
```

By default, the following ENVs will be created for apollo:
- dev
- sit
- uat
- prod

The following services will be created


| pod name | usage | notes |
| :-----| ----: | ----: |
| apollo-configdb | My SQL Server | Check env for `MYSQL_ROOT_PASSWORD` for root password |
| apollo-portal | Portal service |  |
| apollo-config-dev | config service for env `DEV` |  |
| apollo-config-sit | config service for env `SIT` |  |
| apollo-config-uat | config service for env `UAT` |  |
| apollo-config-pord | config service for env `PROD` |  |
| apollo-admin-dev | admin service for env `DEV` |  |
| apollo-admin-sit | admin service for env `SIT` |  |
| apollo-admin-uat | admin service for env `UAT` |  |
| apollo-admin-prod | admin service for env `PROD` |  |

# To deploy with customerized ENVs
```
helm install apollo . -n apollo --set envs[0]=dev --set envs[1]=test --set envs[2]=sandbox
```
