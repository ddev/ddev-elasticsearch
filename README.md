[![tests](https://github.com/ddev/ddev-elasticsearch/actions/workflows/tests.yml/badge.svg)](https://github.com/ddev/ddev-elasticsearch/actions/workflows/tests.yml) ![project is maintained](https://img.shields.io/maintenance/yes/2025.svg)

## Installation

Uses [elasticsearch official image](https://hub.docker.com/_/elasticsearch)

`ddev get ddev/ddev-elasticsearch`

### Using Elasticsearch 8

Post `ddev get`, run `cp .ddev/elasticsearch/docker-compose.elasticsearch8.yaml .ddev/` to enable Elasticsearch 8.

## Connection

To access the Elasticsearch container from within the web container, use the hostname `elasticsearch` and port `9200`. For example, the server URL might be `http://elasticsearch:9200`. Alternatively, you can use the `ddev.site` URLs to access it via HTTP or HTTPS: `http://<projectname>.ddev.site:9200` and `https://<projectname>.ddev.site:9201`. These URLs are also available from the host.

## Configuration

Avoid modifying the provided `docker-compose.elasticsearch.yaml` file. Instead, create a `docker-compose.elasticsearch_extras.yaml` file for any customizations. For more information on defining additional services with Docker Compose, please refer to the [official DDEV documentation](https://ddev.readthedocs.io/en/stable/users/extend/custom-compose-files/).

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

**Originally Contributed by [dacostafilipe](https://github.com/dacostafilipe) with contributions by [@Morgy93](https://github.com/Morgy93), [@amitaibu](https://github.com/amitaibu), [@aronnovak](https://github.com/aronnovak) and others**

**Maintained by [@aronnovak](https://github.com/aronnovak)**
