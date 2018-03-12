This repo will holds a basic solr config, schema and xslt to use as a starting point for future projects.

It is now dependent on the [discoverygarden GSearch extensions](https://github.com/discoverygarden/dgi_gsearch_extensions)--which includes the Joda time library.

If one wishes to index Drupal content and users, one might process the `conf/data-import-config.xml.erb` into `conf/data-import-config.xml`. It takes three parameters:
* `drupal_dbname`
* `drupal_db_username`
* `drupal_db_password`

The 4.10.x branch is setup to utilize solr 4.10ish configurations. These have been successfully tested with solr 4.10.3.

One major difference between solr 3.x and 4.x is when deploying configs they used to go to /usr/local/fedora/solr now they get deployed to /usr/local/fedora/solr/collection1 instead.

You also have to copy the jars from solr/example/lib/ext/* to $CATALINA_HOME/webapps/solr/WEB-INF/lib/ for more information see https://wiki.apache.org/solr/SolrLogging#Using_the_example_logging_setup_in_containers_other_than_Jetty

Requires Gsearch 2.8+

## General Installation

See [the wiki page](https://github.com/discoverygarden/basic-solr-config/wiki/Install-Solr-and-GSearch) for installation details.

## Custom Parameters

In [our gsearch fork](https://github.com/discoverygarden/gsearch) as of [version 2.9.0](https://github.com/discoverygarden/gsearch/releases/tag/v2.9.0), we allow for an addition `custom_parameters.properties` file to be placed beside the `foxmlToSolr.xslt` file (or whatever the "top-level" XSLT is named, when deployed).

|Parameter|Default|Description|
|---|---|---|
|`index_ancestors`|`false`|Boolean flag: `true` to produce an `ancestors_ms` field (as used by the [islandora_collection_search](https://github.com/discoverygarden/islandora_collection_search) module); otherwise, `false` avoid generating. Also, note: When migrating objects between collections, it would be necessary to update all descendents to ensure their list of ancestors reflect the current state... We do this in the islandora_collection_search module when migrating, instead of reindexing all the descendents whenever indexing an object (updating a collection label would be fairly expensive if we blindly reindexed).|
