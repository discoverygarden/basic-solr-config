This repo will holds a basic solr config, schema and xslt to use as a starting point for future projects.

It is now dependent on the [discoverygarden GSearch extensions](https://github.com/discoverygarden/dgi_gsearch_extensions)--which includes the Joda time library.

If one wishes to index Drupal content and users, one might process the `conf/data-import-config.xml.erb` into `conf/data-import-config.xml`. It takes three parameters:
* `drupal_dbname`
* `drupal_db_username`
* `drupal_db_password`

## General Installation

See [the wiki page](https://github.com/discoverygarden/basic-solr-config/wiki/Install-Solr-and-GSearch) for installation details.

## Custom Parameters

In [our gsearch fork](https://github.com/discoverygarden/gsearch) as of [version 2.9.0](https://github.com/discoverygarden/gsearch/releases/tag/v2.9.0), we allow for an addition `custom_parameters.properties` file to be placed beside the `foxmlToSolr.xslt` file (or whatever the "top-level" XSLT is named, when deployed).

|Parameter|Default|Description|
|---|---|---|
|`index_ancestors`|`false`|Boolean flag: `true` to produce an `ancestors_ms` field (as used by the [islandora_collection_search](https://github.com/discoverygarden/islandora_collection_search) module); otherwise, `false` avoid generating. Also, note: When migrating objects between collections, it would be necessary to update all descendents to ensure their list of ancestors reflect the current state... We do this in the islandora_collection_search module when migrating, instead of reindexing all the descendents whenever indexing an object (updating a collection label would be fairly expensive if we blindly reindexed).|
|`index_ancestors_models`|`false`|Boolean flag: `true` to produce an `ancestors_models_ms` field (as used by the [islandora_child_filter](https://github.com/discoverygarden/islandora_child_filter) module; otherwise, `false` avoid generating. NOTE: A triplestore with Sparql 1.1 is required for the query to work.|
|`maintain_dataset_latest_version_flag`|`false`|Boolean flag: `true` to produce a `mmv_is_latest_b` field, as used by the [islandora_research_data module](https://github.com/discoverygarden/islandora_research_data); however, we are not given the opportunity to promote another version should the latest be purged (similarly described in [the `README.md` for `islandora_research_data`](https://github.com/discoverygarden/islandora_research_data#only-show-most-recent-version-objects-in-solr-vs-purging-the-latest-version)). NOTE: Due to how this is calculated, it requires an RI which supports Sparql 1.1 (such as Blazegraph).|
