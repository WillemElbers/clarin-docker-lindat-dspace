# Docker Lindat DSpace

This project provides a dockerfile which can be used to get a [lindat dspace repository](https://github.com/ufal/lindat-dspace) up and running quickly.

# Getting started

## Building the docker image

A makefile is provided for automated builds. Running:

```
make
```
will produce a `docker.clarin.eu/lindat-dspace:1.0.0` docker image.

## Running the docker container

The following docker command will run the docker container and bind port `8080` on the host to the container.

```
docker run -ti --name lindat-dspace --rm -p 8080:8080 docker.clarin.eu/lindat-dspace:1.0.0
```

Assuming you are running a native docker daemon you can now access the repository by visiting `http://localhost:8080/repository/xmlui/`. If you are running the docker daemon in a VM, such as boot2docker, you have to access the service via the boot2docker ip address.

The tomcat manager is also available at `http://localhost:8080/manager/html` Use the following credentials: `tomcat:tomcat`.

# Services

The following service are running inside the docker container:

| Service     | Port | Description            |
| ----------- | ---- | ---------------------- |
| supervisord |      | Process control system |
| postgresql  | 5432 |                        |
| tomcat      | 8080 | Tomcat HTTP connector  |
