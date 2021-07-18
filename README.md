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
# Client Usage
An example for loading configs from pure java api. The following properties needs to be changed:
| property name | property value | notes |
| :-----| ----: | ----: |
| app.id | application id| Creted in apollo web console  |
| apollo.configService | Config server address |`http://apollo-config-service-<env>:8080`  |
| apollo.accesskey.secret | secret for connect to connect to ENV | configured in apollo web console |


```
public class LoadConfig {

    static {
        System.setProperty("app.id", "appid");
        System.setProperty("apollo.configService", "http://apollo-config-service-dev:8080");
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
