[![tests](https://github.com/ddev/ddev-elasticsearch/actions/workflows/tests.yml/badge.svg?branch=main)](https://github.com/ddev/ddev-elasticsearch/actions/workflows/tests.yml?query=branch%3Amain)
[![last commit](https://img.shields.io/github/last-commit/ddev/ddev-elasticsearch)](https://github.com/ddev/ddev-elasticsearch/commits)
[![release](https://img.shields.io/github/v/release/ddev/ddev-elasticsearch)](https://github.com/ddev/ddev-elasticsearch/releases/latest)

# DDEV Elasticsearch

## Overview

[Elasticsearch](https://www.elastic.co/elasticsearch) is an open source distributed, RESTful search and analytics engine, scalable data store, and vector database capable of addressing a growing number of use cases.

This add-on integrates Elasticsearch into your [DDEV](https://ddev.com/) project.

## Installation

```bash
ddev add-on get ddev/ddev-elasticsearch
ddev restart
```

After installation, make sure to commit the `.ddev` directory to version control.

### Using Elasticsearch 8

```bash
ddev add-on get ddev/ddev-elasticsearch
cp .ddev/elasticsearch/docker-compose.elasticsearch8.yaml .ddev/
ddev restart
```

### Switching between Elasticsearch 7 and 8

All Elasticsearch data is stored in a Docker volume, so if you're switching versions or setups, you may want to start fresh by removing the volume:

```bash
# remove old elasticsearch volume (if this is downgrade)
ddev stop
docker volume rm ddev-$(ddev status -j | docker run -i --rm ddev/ddev-utilities jq -r '.raw.name')_elasticsearch
```

## Usage

To access the Elasticsearch container from within the web container, use the hostname `elasticsearch` and port `9200`. For example, the server URL might be `http://elasticsearch:9200`. Alternatively, you can use the `ddev.site` URLs to access it via HTTP or HTTPS: `http://<projectname>.ddev.site:9200` and `https://<projectname>.ddev.site:9201`. These URLs are also available from the host.

> [!TIP]
> What about Kibana support? Use this [add-on](https://github.com/JanoPL/ddev-kibana).

### Advanced Customization

Avoid modifying the provided `docker-compose.elasticsearch.yaml` file. Instead, create a `docker-compose.elasticsearch_extras.yaml` file for any customizations. For more information on defining additional services with Docker Compose, please refer to the [official DDEV documentation](https://ddev.readthedocs.io/en/stable/users/extend/custom-compose-files/).

### Minor Version Bump

To change the minor version of Elasticsearch:

```bash
ddev dotenv set .ddev/.env.elasticsearch --elasticsearch-docker-image=elasticsearch:7.17.14
ddev restart
```

Make sure to commit the `.ddev/.env.elasticsearch` file to version control.

### Memory Limit

By default, this configuration limits the memory usage of the `elasticsearch` service to 512MB. This should be sufficient for most projects. However, if the service stops unexpectedly, you may need to increase the maximum memory allocation for Docker and/or the `elasticsearch` service. To do so, modify the `ES_JAVA_OPTS` environment variable in the `docker-compose.elasticsearch_extras.yaml` file.

Example for 2GB:

```yaml
services:
  elasticsearch:
    environment:
      - "ES_JAVA_OPTS=-Xms2g -Xmx2g"
```

You can use `ddev logs -s elasticsearch` to investigate the Elasticsearch daemon's activity or to troubleshoot RAM-related crashes.

## Additional Resources

* There are two related answers to the [Stack Overflow question](https://stackoverflow.com/questions/54575785/how-can-i-use-an-elasticsearch-add-on-container-service-with-ddev) on ddev and Elasticsearch.
* @juampynr's Lullabot [article on Drupal 8 and Elasticsearch](https://www.lullabot.com/articles/indexing-content-from-drupal-8-to-elasticsearch) is helpful for Drupal users.

## Credits

**Originally Contributed by [dacostafilipe](https://github.com/dacostafilipe) with contributions by [@Morgy93](https://github.com/Morgy93), [@amitaibu](https://github.com/amitaibu), [@aronnovak](https://github.com/aronnovak) and others**

**Maintained by [@aronnovak](https://github.com/aronnovak)**
