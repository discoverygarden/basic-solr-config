# Islandora Transforms

## Introduction

Repository of transformation XSLTs for use with GSearch for a variety of different content types and datastreams.

## Requirements

* [Apache Solr](lucene.apache.org/solr/) - tested on 3.6.2-4.10.3
* [Fedora GSearch](https://github.com/fcrepo3/gsearch) - tested on 2.7-2.8
* Intended to be run with the discoverygarden [Basic Solr Config](https://github.com/discoverygarden/basic-solr-config)

## Installation

Once Solr and GSearch are set up, the `foxmlToSolr.xslt` in this folder should be used as GSearch's transformation XSLT.

The includes within the file point to the folder containing these transformations; these may have to be swapped out for the path to each transformation on the server running GSearch.

## Troubleshooting/Issues

If you're having problems or have solved one, contact [discoverygarden](http://support.discoverygarden.ca)

## Maintainers/Sponsors

Current maintainers:

* [discoverygarden](http://www.discoverygarden.ca)

## Development

If you would like to contribute to this module, please check out our helpful
[Documentation for Developers](https://github.com/Islandora/islandora/wiki#wiki-documentation-for-developers)
info, [Developers](http://islandora.ca/developers) section on Islandora.ca and
contact [discoverygarden](http://support.discoverygarden.ca).

## License

[GPLv3](http://www.gnu.org/licenses/gpl-3.0.txt)
