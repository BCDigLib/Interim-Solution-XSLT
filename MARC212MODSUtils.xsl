<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:mods="http://www.loc.gov/mods/v3" 
    xmlns:xlink="http://www.w3.org/1999/xlink" 
    xmlns:marc="http://www.loc.gov/MARC21/slim">
    <xsl:variable name="rolelookup" select="document('roleLookup.xml')"/> 
    <xsl:variable name="handlelookup" select="document('handleLookup.xml')"/> 
    <xsl:template name="stripBrackets">
        <xsl:param name="paraData"/>
        <xsl:value-of select="translate($paraData,'[]{}()','')"/>
    </xsl:template>
    
    <!-- Taken from MARC21SlimUtils.xsl removed space and comma params -->
    <xsl:template name="chopPunctuation">
        <xsl:param name="chopString"/>
        <xsl:param name="punctuation"><xsl:text>:,;/.</xsl:text></xsl:param>
        <xsl:variable name="length" select="string-length($chopString)"/>
        <xsl:choose>
            <xsl:when test="$length=0"/>
            <xsl:when test="contains($punctuation, substring($chopString,$length,1))">
                <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString" select="substring($chopString,1,$length - 1)"/>
                    <xsl:with-param name="punctuation" select="$punctuation"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="not($chopString)"/>
            <xsl:otherwise><xsl:value-of select="$chopString"/></xsl:otherwise>
        </xsl:choose>
    </xsl:template> 
    <!-- 
    Create text and code roles
    -->
    <xsl:template name="processRole">
        <xsl:param name="paraRole"/>
        <xsl:element name="mods:role">
            <xsl:element name="mods:roleTerm">
                <xsl:attribute name="type">code</xsl:attribute>
                <xsl:attribute name="authority">marcrelator</xsl:attribute>
                <xsl:value-of select="$paraRole"/>
            </xsl:element>
            <xsl:element name="mods:roleTerm">
                <xsl:attribute name="type">text</xsl:attribute>
                <xsl:attribute name="authority">marcrelator</xsl:attribute>
                <xsl:value-of select="$rolelookup/RoleLookUp/role[@code=$paraRole]/@text"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!-- Taken from MARC21SlimUtils.xsl -->
    <xsl:template name="subfieldSelect">
        <xsl:param name="codes"/>
        <xsl:param name="delimeter"/>
        <xsl:variable name="str">
            <xsl:for-each select="marc:subfield">
                <xsl:if test="contains($codes, @code)">
                    <xsl:value-of select="text()"/><xsl:value-of select="$delimeter"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="substring($str,1,string-length($str)-string-length($delimeter))"/>
    </xsl:template>
    <xsl:template match="marc:subfield[@code='2']" mode="authority">
        <xsl:attribute name="authority">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="marc:subfield[@code='a'] | marc:subfield[@code='b']" mode="namePart">
        <xsl:element name="mods:namePart">
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="marc:subfield" mode="subject">
        <xsl:param name="paraNode"/>
        <xsl:element name="{$paraNode}">
            <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString"><xsl:value-of select="."/></xsl:with-param>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>   
    <xsl:template name="processIsoDate">
        <xsl:param name="paraNode"/>
        <xsl:variable name="varYear">
            <xsl:choose>
                <xsl:when test="contains(.,',')">
                    <xsl:value-of select="normalize-space(substring-after($paraNode,','))"/>
                </xsl:when>
                <xsl:when test="translate(substring($paraNode,1,4),'0123456789','9999999999')= '9999'">
                    <xsl:value-of select="substring($paraNode,1,4)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space(substring-after($paraNode,' '))"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="varMonth">
            <xsl:choose>
                <xsl:when test="contains(.,'Jan')">01</xsl:when>            
                <xsl:when test="contains(.,'February')">02</xsl:when>
                <xsl:when test="contains(.,'March')">03</xsl:when>
                <xsl:when test="contains(.,'April')">04</xsl:when>
                <xsl:when test="contains(.,'May')">05</xsl:when>
                <xsl:when test="contains(.,'June')">06</xsl:when>
                <xsl:when test="contains(.,'July')">07</xsl:when>
                <xsl:when test="contains(.,'August')">08</xsl:when>
                <xsl:when test="contains(.,'September')">09</xsl:when>
                <xsl:when test="contains(.,'Oct')">10</xsl:when>
                <xsl:when test="contains(.,'Nov')">11</xsl:when>
                <xsl:when test="contains(.,'December')">12</xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="varDay">
            <xsl:choose>
                <xsl:when test="contains($paraNode,',')">
                    <xsl:value-of select="normalize-space(substring-after(substring-before($paraNode,','),' '))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring-after(substring-after($paraNode,' '),' ')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="concat($varYear,'-',$varMonth)"/>  
        <xsl:if test="$varDay !=''">
            <xsl:value-of select="concat('-',format-number($varDay,'00'))"/> 
        </xsl:if>
    </xsl:template>
    <xsl:template name="processStartEnd">
        <xsl:param name="paraStart"/>
        <xsl:param name="paraEnd"/>
        <xsl:param name="paraQualifier"/>
        <xsl:element name="mods:dateCreated">
            <xsl:choose>
                <xsl:when test="$paraStart !='' and $paraEnd !=''">
                    <xsl:value-of select="concat($paraStart,'-',$paraEnd)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="translate(.,'?[]().','')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>      
        <xsl:choose>
            <xsl:when test="$paraStart != ''">
                <xsl:element name="mods:dateCreated">
                    <xsl:attribute name="encoding">w3cdtf</xsl:attribute>	
                    <xsl:attribute name="keyDate">yes</xsl:attribute>						
                    <xsl:attribute name="point">start</xsl:attribute>
                    <xsl:if test="$paraQualifier !=''">
                        <xsl:attribute name="qualifier"><xsl:value-of select="$paraQualifier"/></xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="$paraStart"/>  
                </xsl:element>                    
                <xsl:if test="$paraEnd != ''">
                    <xsl:element name="mods:dateCreated">
                        <xsl:attribute name="point">end</xsl:attribute>
                            <xsl:value-of select="$paraEnd"/>
                    </xsl:element> 
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="mods:dateCreated">
                    <xsl:attribute name="encoding">w3cdtf</xsl:attribute>	
                    <xsl:attribute name="keyDate">yes</xsl:attribute>						
                    <xsl:if test="$paraQualifier !=''">
                        <xsl:attribute name="qualifier"><xsl:value-of select="$paraQualifier"/></xsl:attribute>
                    </xsl:if>
                    <xsl:attribute name="point">end</xsl:attribute>
                    <xsl:value-of select="$paraEnd"/>
                </xsl:element>                 
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="processHdl">
        <xsl:param name="paraId"/>
        <xsl:variable name="varHandle">
            <xsl:value-of select="$handlelookup/HandleLookup/idToHandle[@id=$paraId]/@handle"/>
        </xsl:variable>
        <xsl:if test="$varHandle !=''">
            <xsl:element name="mods:identifier">
                <xsl:attribute name="type">hdl</xsl:attribute>
                <xsl:value-of select="concat('http://hdl.handle.net/', $varHandle)"/>
            </xsl:element>
        </xsl:if>
        
    </xsl:template>
</xsl:stylesheet>
