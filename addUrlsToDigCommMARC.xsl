<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.loc.gov/mods/v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:jhove="http://hul.harvard.edu/ois/xml/ns/jhove" xmlns:mods="http://www.loc.gov/mods/v3">
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="/">
       <record>
        <mods:location>
            <mods:physicalLocation>
                <xsl:text>Boston College</xsl:text>
            </mods:physicalLocation>            
            <mods:url usage='primary display' access='object in context'>
                <xsl:value-of select="concat(/*/urls/url[@type='resource_discovery'],'&amp;local_base=GEN01-BCD01')"/>
            </mods:url>                    
            <mods:url access='preview'>
                <xsl:value-of select="/*/relations/relation[type='manifestation'][usage_type='THUMBNAIL']/urls/url[@type='stream']"/>
            </mods:url>
        </mods:location>
        <mods:identifier type="uri">
           <xsl:value-of select="concat(/*/urls/url[@type='stream_manifestation'],'&amp;local_base=GEN01-BCD01')"/>
        </mods:identifier>  
       </record>
    </xsl:template>
</xsl:stylesheet>
