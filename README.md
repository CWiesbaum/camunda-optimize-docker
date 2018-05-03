# camunda-optimize-docker
Repository providing a Dockerfile for building a Docker image containing [Camunda Optimize](https://docs.camunda.org/optimize/latest/).

## [camunda services GmbH](https://camunda.com) about Camunda Optimize
Camunda Optimize is an extension to Camunda BPM for enterprise customers. It provides continuous monitoring and insights about your deployed business processes. This Big Data solution helps process owners to make informed decisions in order to optimize their processes.

## Download Camunda Optimize
Camunda Optimize can be downloaded from the enterprise download page. Enterprise Edition credentials are required.

https://docs.camunda.org/enterprise/download/#camunda-optimize

The Dockerfile assumes Camunda Optimize Full Distribution is provided.

# Usage
Within this section general usage is described

## To Note
* Camunda Optimize Full Distribution is required
* ElasticSearch config provided starts ElasticSearch in single-node mode (skip [Bootstrap Checks](https://www.elastic.co/guide/en/elasticsearch/reference/current/bootstrap-checks.html))
* start-optimize.sh script got amended such that ElasticSearch and Optimize hosts can be managed through environment variables (ELASTIC\_HOST, OPTIMIZE\_HOST)

## Build Docker Image
The following steps are required to build this docker image
1. Checkout repository
1. Download [Camunda Optimize Full Distribution](https://docs.camunda.org/enterprise/download/#camunda-optimize) (ZIP-Archive) to repository folder
1. Rename full distribution to _camunda-optimize.zip_
1. Build docker image: `docker build .`

## Run Docker Container
### Preconditions
* Docker build executed
* Docker image got tagged as `camunda-optimize`
* Existing _environment-config.yml_ was created (connect to Camunda BPM Platform)

Might help: [Camunda Optimize Configuration](https://docs.camunda.org/optimize/technical-guide/configuration/)

Example configuration (environment-config.yml; **See engines.camunda-bpm.name and engines.camunda-bpm.rest**):

```yaml
container:
  # NOTE: changing this property also requires adjustments in the startup script
  # start-optimize.sh on Linux or start-optimize.bat on Windows.
  host: 0.0.0.0
  # NOTE: changing this property also requires adjustments in the startup script
  # start-optimize.sh on Linux or start-optimize.bat on Windows.
  ports:
    http: 8090

engines:
  'camunda-bpm':
    name: default
    rest: http://some-host:8080/engine-rest
    authentication:
      accessGroup: ''
      enabled: false
      password: ''
      user: ''
    enabled: true

es:
  # NOTE: changing these properties also might need adjustments in the startup script
  # start-optimize.sh on Linux or start-optimize.bat on Windows if you don't have
  # configured your own elasticsearch instance.
  host: localhost
  port: 9300
  index: optimize
```

### Run All-In-One Container
* Camunda Optimize (Container)
* ElasticSearch (Container)
* Camunda BPM Platform (External)

```shell
docker run --name camunda-optimize --mount type=bind,source='/some/path/to/config/folder',target=/opt/camunda-optimize/environment -p 8090:8090 -p 8091:8091 camunda-optimize
```

### Run Camunda Optimize Only Container
* Camunda Optimize (Container)
* ElasticSearch (External)
* Camunda BPM Platform (External)

For this configuration the keys _es.host_ and _es.port_ have to set appropriately within the config file above.

```shell
docker run --name camunda-optimize --mount type=bind,source='/some/path/to/config/folder',target=/opt/camunda-optimize/environment -e ARGS=standalone -p 8090:8090 -p 8091:8091 camunda-optimize
```

### Change ElasticSearch and Optimize Host
Within [Camunda's documentation](https://docs.camunda.org/optimize/develop/technical-guide/installation/#optimize-container-configuration) it is noted that some config hostname changes might require changing _start-optimize.sh_ script as well. In order to overcome this task an amended skript is added to the Docker image, which can be amended using environment variables.

If one has to amend the script, the following environment variables can be used to do so:
* ELASTIC_HOST - ElasticSearch Host
* OPTIMIZE_HOST - Camunda Optimize Host

Of course values have to match those configured within _environment-config.yml_.

```shell
docker run --name camunda-optimize --mount type=bind,source='/some/path/to/config/folder',target=/opt/camunda-optimize/environment -e ELASTIC_HOST=some-host -e OPTIMIZE_HOST=some-other-host -p 8090:8090 -p 8091:8091 camunda-optimize
```