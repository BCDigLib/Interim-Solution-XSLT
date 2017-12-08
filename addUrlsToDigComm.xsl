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
          <xsl:value-of select="concat('https://bclsco.bc.edu/catalog/oai:dcollections.bc.edu:',/*/pid)"/>
        </mods:url>                    
        <mods:url access='preview'>
          <xsl:value-of select="concat('https://dcollections.bc.edu/webclient/DeliveryManager?pid=',/*/relations/relation[type='manifestation']/pid)"/>
        </mods:url>
        <mods:url access='raw object'>
          <xsl:value-of select="concat('https://dcollections.bc.edu/webclient/DeliveryManager?pid=',/*/pid,'&amp;custom_att_2=simple_viewer&amp;local_base=GEN01-BCD01')"/>
        </mods:url>
      </mods:location>
      <mods:identifier type="hdl">
        <xsl:text>https://hdl.handle.net/2345</xsl:text>
        <xsl:variable name="varHandle">
          <xsl:value-of select="substring-before(substring-after(//mds/md[name='preservation']/value, '2345'),'o')"/>
        </xsl:variable>
        <xsl:value-of select="substring($varHandle,1,string-length($varHandle)-2)"/>
      </mods:identifier>
    </record>
  </xsl:template>
</xsl:stylesheet>
