<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns="http://www.loc.gov/MARC21/slim">
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="/">
        <record>
            <datafield tag="856" ind1=" " ind2=" ">
                <subfield code="u">
                    <xsl:value-of select="concat('https://bclsco.bc.edu/catalog/oai:dcollections.bc.edu:',/*/pid)"/>
                </subfield>
            </datafield>
            <datafield tag="856" ind1=" " ind2=" ">
                <subfield code="u">
                    <xsl:value-of select="concat('https://dcollections.bc.edu/webclient/DeliveryManager?pid=',/*/relations/relation[type='manifestation']/pid)"/>
                </subfield>
                <subfield code="x">
                    <xsl:text>THUMBNAIL</xsl:text>
                </subfield>
            </datafield>
            <datafield tag="856" ind1="4" ind2="0">
                <subfield code="u">
                    <xsl:value-of select="concat('https://dcollections.bc.edu/webclient/DeliveryManager?pid=',/*/pid,'&amp;custom_att_2=simple_viewer&amp;local_base=GEN01-BCD01')"/>
                </subfield>
                <subfield code="x">
                    <xsl:text>STREAM</xsl:text>
                </subfield>                    
            </datafield>
        </record>
    </xsl:template>
</xsl:stylesheet>
