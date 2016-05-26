# Interim-Solution-XSLT
Transformation files used for DigiTool -> Blacklight.

MARC21 to MODS

    MARC2MODS3_6_for_Blacklight.xsl
    MARC212MODSUtils.xsl
    
    These files are used by the DigiTool OAI provider to transform legacy MARC records to MODS
    
    Lookup files used by stylesheet:
        roleLookup.xml
        handleLookup.xml - Used to add hdl in MODS record. 

MODS to MODS
    
    MODS-digitool_MODS3-OAI_XSLT1-0.xsl
    
    Used to normalize DigiTool MODS to Digital Commonwealth standard
    
        Lookup files used by stylesheet:
        languageLookup.xml
        roleLookup.xml
        genreLookup.xml
    
MODS to SOLR

    oaiMODS2solr.xsl

    Used to transform OAI harvested MODS records from DigiTool to SOLR xml.
    
