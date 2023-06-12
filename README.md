[![tests](https://github.com/ddev/ddev-elasticsearch/actions/workflows/tests.yml/badge.svg)](https://github.com/ddev/ddev-elasticsearch/actions/workflows/tests.yml) ![project is maintained](https://img.shields.io/maintenance/yes/2024.svg)

## Installation

Uses [elasticsearch official image](https://hub.docker.com/_/elasticsearch)

`ddev get ddev/ddev-elasticsearch`

## Configuration

From within the container, the elasticsearch container is reached at hostname: "elasticsearch", port: 9200, so the server URL might be `http://elasticsearch:9200`. You can also use the "ddev.site" http and https urls to access it: `http://<projectname>.ddev.site:9200`, and `https://<projectname>.ddev.site:9201`

## Connection

You can access the Elasticsearch server directly from the host for debugging purposes by visiting `http://<projectname>.ddev.site:9200`. Via https you can access Elasticsearch via `https://<projectname>.ddev.site:9201`

## Memory Limit

This configuration limits memory usage to 512mb. This should be enough for most projects, but if your `elasticsearch` service stops with no obvious reason, increase your docker max memory and/or the service max memory via the ES_JAVA_OPTS variable:

```yaml
- "ES_JAVA_OPTS=-Xms512m -Xmx512m"` environment variable in `docker-compose.elasticsearch.yaml`
```

If you change this variable, make sure to remove the `#ddev-generated` line at the top of the file. 

You can use `ddev logs -s elasticsearch` to investigate what the elasticsearch daemon has been up to, or if you have a RAM-related crash.

## Additional Resources

* There are two related answers to the [Stack Overflow question](https://stackoverflow.com/questions/54575785/how-can-i-use-an-elasticsearch-add-on-container-service-with-ddev) on ddev and Elasticsearch.
* @juampynr's Lullabot [article on Drupal 8 and Elasticsearch](https://www.lullabot.com/articles/indexing-content-from-drupal-8-to-elasticsearch) is helpful for Drupal users.

**Originally Contributed by [dacostafilipe](https://github.com/dacostafilipe) with contributions by [@Morgy93](https://github.com/Morgy93), [@amitaibu](https://github.com/amitaibu), [@aronnovak](https://github.com/aronnovak) and others**

**Maintained by [@aronnovak](https://github.com/aronnovak)**
