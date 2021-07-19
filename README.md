# General info

This is a helm chart for installing a whole stack for Ctrip Apollo Services in k8s.

See https://github.com/ctripcorp/apollo for details for apollo configuration center.

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

The following services will be created:


| pod name | usage | notes |
| :-----| ----: | ----: |
| apollo-configdb | My SQL Server | root password is `7zdXc72yzpNMzIVL9Z9N` |
| apollo-portal | Portal service |  |
| apollo-config-dev | config service for env `DEV` |  |
| apollo-config-sit | config service for env `SIT` |  |
| apollo-config-uat | config service for env `UAT` |  |
| apollo-config-pord | config service for env `PROD` |  |
| apollo-admin-dev | admin service for env `DEV` |  |
| apollo-admin-sit | admin service for env `SIT` |  |
| apollo-admin-uat | admin service for env `UAT` |  |
| apollo-admin-prod | admin service for env `PROD` |  |

*TO update root password*, add the following parametes, like
```
helm install apollo . -n apollo --set configdb.rootPassword=aaabbbcccddd
```

# Apollo Web Console

- If you want to expose the Web Console outside kubernetes, please set the service type as `LoadBalancer` for `apollo-portal` service.
- If you do not want to expose the Web Console, just run the commond to create a port forward:
```
kubectl port-forward  --address 0.0.0.0 svc/apollo-portal 8070:8070 -n apollo
```
Then you can access it by `http://<ip address>:8080`

Please login by `apollo` / `admin`
and change the default password `admin` after you logged in.

Then create the needed `Project`, create `Access Key` and configuration entries.

# To deploy with customerized ENVs
```
helm install apollo . -n apollo --set envs[0]=dev --set envs[1]=test --set envs[2]=sandbox
```
# To deploy with customerized PVC type
The PVC is used to store data for MySQL DB. By default the AWS/EKS PVC storage class type `gp2` is used.
If you need another type, overwrite the `configdb.pvc` value:
```
helm install apollo . -n apollo --set configdb.pvc=<your storage class type>
```

# Client Usage
An example for loading configs from pure java api. The following properties needs to be changed:
| property name | property value | notes |
| :-----| ----: | ----: |
| app.id | application id| Creted in apollo web console  |
| apollo.configService | Config server address |`http://apollo-config-service-<env>.<apollo namespace>.svc.cluster.local:8080` By default, the `apollo namespace` is `apollo`  |
| apollo.accesskey.secret | secret for connect to connect to ENV | configured in apollo web console |

Note: This app is to be delployed under same kubernetes cluster!

```
public class LoadConfig {

    static {
        System.setProperty("app.id", "appid");
        System.setProperty("apollo.configService", "http://apollo-config-service-dev.apollo.svc.cluster.local:8080");
        System.setProperty("apollo.accesskey.secret", "<your secret>");
    }

    public static void main(String[] argu) throws InterruptedException {

        System.out.println(System.getProperty("app.id"));
        System.out.println(System.getProperty("apollo.config-service"));

        Config config = ConfigService.getConfig("application"); //config instance is singleton for each namespace and is never null
        String someKey = "timeout";
        String someDefaultValue = "50s";
        Set<String> value = config.getPropertyNames();
        System.out.println(value);
        System.out.println(config.getProperty(someKey, "na"));

        config.addChangeListener( event -> {
            Set<String> keys = event.changedKeys();
            String ns = event.getNamespace();
            System.out.println("Changed " + ns + keys);
            for (String key : keys) {
                System.out.println(key + " " + event.getChange(key));
            }
        });

        Thread.sleep(1000000);
    }
}
```
