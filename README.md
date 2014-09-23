This repo will holds a basic solr config, schema and xslt to use as a starting point for future projects.

It is now dependent on the [discoverygarden GSearch extensions](https://github.com/discoverygarden/dgi_gsearch_extensions)--which includes the Joda time library.

If one wishes to index Drupal content and users, one might process the `conf/data-import-config.xml.erb` into `conf/data-import-config.xml`. It takes three parameters:
* `drupal_dbname`
* `drupal_db_username`
* `drupal_db_password`

The 4.x branch is setup to utilize solr 4ish configurations. These have been successfully tested with solr 4.2.0. 

One major difference between solr 3.x and 4.x is when deploying configs they used to go to /usr/local/fedora/solr now they get deployed to /usr/local/fedora/solr/collection1 instead.