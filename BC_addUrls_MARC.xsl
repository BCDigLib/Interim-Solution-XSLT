<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns="http://www.loc.gov/MARC21/slim">
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="/">
        <record>
            <xsl:for-each select="/*/urls/url[@type='resource_discovery']">
                <datafield tag="856" ind1=" " ind2=" ">
                    <subfield code="u">
                        <xsl:value-of select="concat(., '&amp;local_base=GEN01-')"/>
                        <xsl:value-of select="//control/admin_unit"/>
                    </subfield>
                </datafield>
            </xsl:for-each>
            <xsl:for-each select="/*/relations/relation[usage_type='THUMBNAIL']/urls/url[@type='stream']">
                <datafield tag="856" ind1=" " ind2=" ">
                    <subfield code="u">
                        <xsl:value-of select="."/>
                    </subfield>
                    <subfield code="x">
                        <xsl:text>THUMBNAIL</xsl:text>
                    </subfield>
                </datafield>
            </xsl:for-each>   
            <xsl:for-each select="/*/urls/url[@type='stream_manifestation']">
                <datafield tag="856" ind1="4" ind2="0">
                    <subfield code="u">
                        <xsl:value-of select="concat(., '&amp;local_base=GEN01-')"/>
                        <xsl:value-of select="//control/admin_unit"/>
                    </subfield>
                    <subfield code="x">
                        <xsl:text>STREAM</xsl:text>
                    </subfield>                    
                </datafield>
            </xsl:for-each>            
        </record>
    </xsl:template>
</xsl:stylesheet>
