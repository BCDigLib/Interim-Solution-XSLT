# Interim-Solution-XSLT
We use the DigiTool OAI provider to disseminate content to Primo, Digital
Commonwealth, and Blacklight ((Boston College Special Collections Online)[https://bclsco.bc.edu]). This repository includes the transforms required
for these workflows.

## DigiTool Repository Replication
DigiTool generates its OAI feed based on the 'Repository Replication' job, which
is defined in a configuration file located on the DigiTool server. Our custom
config file is stored [on Bitbucket](https://git.bc.edu:7993/projects/DIGLIB/repos/digitoolconfigfiles/browse)
for version control (BC login required).

### Rebuilding the DigiTool Feed
The DigiTool OAI feed refreshes every morning. However, any changes to an XSLT
will require rebuilding the feed from scratch. The DigiTool OAI feed comprises
several 'replications', each of which can be rebuilt individually:

1. Go to the DigiTool web admin interface
2. Select 'Management', then log in as the root user
3. Select the REP00 admin unit
4. Select 'Maintenance'
5. Under 'Maintenance job selection', select 'Repository Replication,' then click
'Next'
6. Click the 'Admin Unit' dropdown and select 'BCD01'
7. Click the 'Replication Name' dropdown and select the replication you'd like to
reload
8. Check the box that reads 'Create Replication From Scratch'
9. Click 'Next', then click 'Confirm' to run the job

Visit the [Bitbucket repo](https://git.bc.edu:7993/projects/DIGLIB/repos/digitoolconfigfiles/browse)
for more information on currently active DigiTool replications and how to modify
them (BC login required)

### MARC21 to MODS Transform
These files are used by the DigiTool OAI provider to transform legacy MARC
records to MODS:
- MARC2MODS3_6_for_Blacklight.xsl
- MARC212MODSUtils.xsl (called in MARC2MODS3_6_for_Blacklight.xsl)
- addUrlsToDigComm.xsl (adds handles, links to DigiTool viewer, and
  <mods:location> element required by Digital Commonwealth)

Lookup files used by stylesheet:
- roleLookup.xml
- handleLookup.xml - Used to add hdl in MODS record.

### MODS to MODS Transform
These files are used by the DigiTool OAI provider to
normalize DigiTool MODS to Digital Commonwealth standard:
- MODS-digitool_MODS3-OAI_XSLT1-0.xsl
- addUrlsToDigComm.xsl (adds handles, links to DigiTool viewer, and
  <mods:location> element required by Digital Commonwealth)

Lookup files used by stylesheet:
- languageLookup.xml
- roleLookup.xml
- genreLookup.xml

## BCLSCO Solr Transform
oaiMODS2solr.xsl: Used to transform OAI harvested MODS records from DigiTool
to Solr XML. These files are then posted to BCLSCO. See [BCLSCO Solr Utilities](https://git.bc.edu:7993/projects/DIGLIB/repos/bclsco-solr-utilities/browse)
for more information (BC login required).
