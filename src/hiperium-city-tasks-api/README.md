# Tasks Service: An Java Quarkus app using Quartz Scheduler for Native Linux executables.

## Running Unit/Integration Tests
Launch the Maven test command:
```bash
mvn test
```
NOTE: If you have experienced issues with the Ryuk container initialization, add the following environment variable to your system:
```bash
export TESTCONTAINERS_RYUK_DISABLED=true
```
Also, to gain some time executing the tests, you can add the following environment variable to your system:
```bash
export TESTCONTAINERS_CHECKS_DISABLE=true
```

## Creating an Aurora Database
Launch the following command:
```bash
copilot storage init -t Aurora
```

## Publishing Tasks Service to Docker Hub
Execute the following command to build the image using the production Quarkus profile:
```bash
docker build -t hiperium/hiperium-city-tasks-api:1.5.0-arm64 .
```
Login to Docker Hub:
```bash
docker login
```
Or:
```bash
docker login -u "username" -p "1234567890" docker.io
```
Then push the image to Docker Hub:
```bash
docker push hiperium/hiperium-city-tasks-api:1.5.0-arm64
```

## Other Copilot ECS Important Commands
Go to the project's root directory and execute the following commands.
List all of your AWS Copilot applications:
```bash
copilot app ls
```
Show information about the environments and services in your application.
```bash
copilot app show
```
Show information about your environments.
```bash
copilot env ls
```
Show information about the service, including endpoints, capacity and related resources.
```bash
copilot svc show
```
List of all the services in an application.
```bash
copilot svc ls
```
Show logs of a deployed service.
```bash
copilot svc logs              \
  --app hiperium-city-tasks   \
  --name api                  \
  --env dev                   \
  --since 30m                 \
  --follow
```
Show service status.
```bash
copilot svc status
```
Executes a command in a running container part of a service.
The following command start an interactive bash session with a task part of the service.
```bash
copilot svc exec -a hiperium-city-tasks -e dev -n api
```
---

To delete and clean up all created resources.
```bash
copilot app delete --name hiperium-city-tasks --yes
```

## Related Quarkus Guides
- Native Executables ([guide](https://quarkus.io/guides/building-native-image))
- Reactive Applications ([guide](https://quarkus.io/guides/getting-started-reactive))
- Quartz ([guide](https://quarkus.io/guides/quartz)): Schedule clustered tasks with Quartz.
- Flyway ([guide](https://quarkus.io/guides/flyway)): Database migration tool.
- Datasource ([guide](https://quarkus.io/guides/datasource)): Configure your datasource for JDBC and/or Reactive.
- Transactions ([guide](https://quarkus.io/guides/transaction)): Manage your transactions with JTA or Narayana.
- OpenID Connect ([guide](https://quarkus.io/guides/security-openid-connect)): Secure your application with OpenID Connect.
- Testing ([guide](https://quarkus.io/guides/getting-started-testing)): Testing reactive applications.
- Health ([guide](https://quarkus.io/guides/microprofile-health)): Expose health checks for your application.
