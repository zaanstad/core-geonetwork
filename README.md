# Features


* Immediate search access to local and distributed geospatial catalogues
* Up- and downloading of data, graphics, documents, pdf files and any other content type
* An interactive Web Map Viewer to combine Web Map Services from distributed servers around the world
* Online editing of metadata with a powerful template system
* Scheduled harvesting and synchronization of metadata between distributed catalogs
* Support for OGC-CSW 2.0.2 ISO Profile, OAI-PMH, Z39.50 protocols
* Fine-grained access control with group and user management
* Multi-lingual user interface

# Zaandam Geonetwork instance

This instance of geonetwork is based on the 2.10.x branch of geonetwork, some customisations have been implemented, like:
- changing of the logo's and plot template
- some customised translations
- customised background layers/projection in the map
- settings are managed via a build profile

# Install

- dependencies: java jdk, maven (3+), ant
- checkout the 2.10 branch, including submodules
- mvn clean install -Penv-prod,gn-zaandam -DskipTests (build war)
- cd /web - mvn jetty:run -Penv-dev,gn-zaandam -DskipTests (run war for local development)
- cd /installer - ant (build windows installer) 