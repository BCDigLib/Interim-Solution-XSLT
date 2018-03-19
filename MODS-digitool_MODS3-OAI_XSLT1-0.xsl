<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0">
    <xsl:variable name="languagelookup" select="document('languageLookup.xml')"/>
    <xsl:variable name="rolelookup" select="document('roleLookup.xml')"/>   
    <xsl:variable name="genrelookup" select="document('genreLookup.xml')"/>    
    <xsl:output method="xml" indent="yes" encoding="UTF-8" />
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="mods:mods">
        <mods:mods version="3.5" xmlns:mods="http://www.loc.gov/mods/v3"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">
            <xsl:apply-templates select="mods:titleInfo"/>
            <xsl:apply-templates select="mods:name"/>
            <xsl:apply-templates select="mods:typeOfResource"/>
            <xsl:call-template name="processGenre"/>
            <xsl:apply-templates select="mods:originInfo"/>
            <xsl:apply-templates select="mods:language"/>
            <xsl:apply-templates select="mods:physicalDescription"/>
            <xsl:apply-templates select="mods:abstract"/>
            <xsl:apply-templates select="mods:tableOfContents"/>
            <xsl:apply-templates select="mods:targetAudience"/>
            <xsl:apply-templates select="mods:note"/>
            <xsl:apply-templates select="mods:subject"/>
            <xsl:apply-templates select="mods:classification"/>
            <!-- Note that all objects held in the Digital Commonwealth repository MUST belong to a collection. For this reason, the DC-BPL
                    guidelines require the use of one <relatedItem> element with @type="host" to describe that relationship -->
            <xsl:choose>
                <xsl:when test="mods:relatedItem[@type='host']/mods:titleInfo/mods:title = 'Bobbie Hanvey Photographic Archives'">
                    <xsl:apply-templates select="mods:relatedItem[@type='host']" mode="passThru"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="localColl">
                        <xsl:choose>
                            <xsl:when test="mods:extension/mods:localCollectionName">
                                <xsl:value-of select="mods:extension/mods:localCollectionName"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="mods:extension/localCollectionName"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="$localColl = 'BC1987012' or 
                            $localColl = 'BC1986032' or 
                            $localColl = 'BC1986019' or 
                            $localColl = 'BC1988027' or 
                            $localColl = 'BC2004133' or 
                            $localColl = 'BC1986019' or
                            $localColl = 'MS1986043' or
                            $localColl = 'MS2004068' or
                            $localColl = 'MS2011027' or
                            $localColl = 'MS1986041' or
                            $localColl = 'MS2012004' or
                            $localColl = 'MS2013043' or
                            $localColl = 'MS1986118' or
                            $localColl = 'MS2012003' or
                            $localColl = 'MS1990031' or
                            $localColl = 'MS2000017' or
                            $localColl = 'MS2009030' or
                            $localColl = 'BC2004121'">                            
                            <xsl:apply-templates select="mods:relatedItem[@type='host']" mode="passThru"/>
                        </xsl:when> 
                        <xsl:when test="$localColl = 'BC2000005'">
                            <xsl:call-template name="makerelatedItem">
                                <xsl:with-param name="paraNonSort"/>
                                <xsl:with-param name="paraTitle">Boston College faculty and staff photographs</xsl:with-param>
                            </xsl:call-template>
                        </xsl:when>                        
                        <xsl:when test="mods:extension/localCollectionName = 'Evening College'">
                            <xsl:call-template name="makerelatedItem">
                                <xsl:with-param name="paraNonSort"/>
                                <xsl:with-param name="paraTitle">Boston College Evening College photographs (early years)</xsl:with-param>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="mods:extension/localCollectionName = 'Commencement Photographs 1877--1969'">
                            <xsl:call-template name="makerelatedItem">
                                <xsl:with-param name="paraNonSort"/>
                                <xsl:with-param name="paraTitle">Boston College Commencement photographs</xsl:with-param>
                            </xsl:call-template>                            
                        </xsl:when>
                        <xsl:when test="mods:extension/localCollectionName = 'Robsham Theater productions'">
                            <xsl:call-template name="makerelatedItem">
                                <xsl:with-param name="paraNonSort"/>
                                <xsl:with-param name="paraTitle">Boston College theater productions</xsl:with-param>
                            </xsl:call-template>                            
                        </xsl:when>
                        <xsl:when test="mods:extension/localCollectionName = 'Jesuit faculty'">
                            <xsl:call-template name="makerelatedItem">
                                <xsl:with-param name="paraNonSort"/>
                                <xsl:with-param name="paraTitle">Boston College faculty and staff photographs</xsl:with-param>
                            </xsl:call-template>                            
                        </xsl:when>
                        <xsl:when test="mods:extension/localCollectionName = 'Students/General' or 
                        mods:extension/localCollectionName = 'Individual and Multiple Photos of Campus Life' or	
                        mods:extension/localCollectionName = 'Class of 1963 - Misc. Senior Week Photos' or
                        mods:extension/localCollectionName = 'BC Class of 1956 Photographs - Candids' or
                        mods:extension/localCollectionName = 'Various photos of campus life' or
                        mods:extension/localCollectionName = 'Campus life' or
                        mods:extension/localCollectionName = 'Class of 1915' or
                        mods:extension/localCollectionName = 'Class of 1917' or
                        mods:extension/localCollectionName = 'Class of 1920' or
                        mods:extension/localCollectionName = 'Class of 1934' or
                        mods:extension/localCollectionName = 'Class of 1953' or
                        mods:extension/localCollectionName = 'Class of 1925'">
                            <xsl:call-template name="makerelatedItem">
                                <xsl:with-param name="paraNonSort"/>
                                <xsl:with-param name="paraTitle">Boston College students and campus life photographs</xsl:with-param>
                            </xsl:call-template>  
                        </xsl:when>     
                        <xsl:when test="mods:extension/localCollectionName = 'Athletics: Hockey' or 
                            mods:extension/localCollectionName = 'Athletics: Baseball' or	
                            mods:extension/localCollectionName = 'Athletics: Football' or
                            mods:extension/localCollectionName = 'Football Fenway BC vs. Holy Cross 1916' or
                            mods:extension/localCollectionName = 'Athletics: Basketball'">
                            <xsl:call-template name="makerelatedItem">
                                <xsl:with-param name="paraNonSort"/>
                                <xsl:with-param name="paraTitle">Boston College athletic photographs</xsl:with-param>
                            </xsl:call-template>  
                        </xsl:when>                        
                        <xsl:when test="mods:extension/localCollectionName = 'Bapst/Burns Libraries Photos' or 
                        mods:extension/localCollectionName = 'Buildings/Main Campus'">
                            <xsl:call-template name="makerelatedItem">
                                <xsl:with-param name="paraNonSort"/>
                                <xsl:with-param name="paraTitle">Boston College building and campus images</xsl:with-param>
                            </xsl:call-template>                             
                        </xsl:when>
                        <xsl:when test="mods:extension/localCollectionName = 'Events on Campus/BC' or
                        mods:extension/localCollectionName = 'Events on Campus'">
                            <xsl:call-template name="makerelatedItem">
                                <xsl:with-param name="paraNonSort"/>
                                <xsl:with-param name="paraTitle">Boston College special guests and events photographs</xsl:with-param>
                            </xsl:call-template>                             
                        </xsl:when>
                        <xsl:when test="mods:extension/localCollectionName = 'MS1992012'">
                            <mods:relatedItem type="host">
                                <mods:titleInfo>
                                    <mods:title>William Butler Yeats notebooks and manuscripts</mods:title>
                                </mods:titleInfo>
                                <mods:originInfo>
                                    <mods:dateCreated>1880-1920</mods:dateCreated>
                                    <mods:dateCreated point="start" keyDate="yes" encoding="w3cdtf">1880</mods:dateCreated>
                                    <mods:dateCreated point="end" encoding="w3cdtf">1920</mods:dateCreated>
                                </mods:originInfo>
                                <mods:identifier type="accession number">MS.1992.012</mods:identifier>
                                <mods:location>
                                    <mods:url displayLabel="William Butler Yeats notebooks and manuscripts">http://hdl.handle.net/2345/2805</mods:url>
                                </mods:location>
                            </mods:relatedItem>                             
                        </xsl:when>
                        <xsl:when test="mods:extension/localCollectionName = 'Brooker'">
                            <mods:relatedItem type="host">
                                <mods:titleInfo>
                                    <mods:nonSort>The </mods:nonSort>
                                    <mods:title>Robert E. Brooker III Collection of American Legal and Land Use Documents, 1716-1930</mods:title>
                                </mods:titleInfo>
                                <mods:originInfo>
                                    <mods:dateCreated>1716-1930</mods:dateCreated>
                                    <mods:dateCreated point="start" keyDate="yes" encoding="w3cdtf">1716</mods:dateCreated>
                                    <mods:dateCreated point="end" encoding="w3cdtf">1930</mods:dateCreated>
                                </mods:originInfo>
                            </mods:relatedItem>                            
                        </xsl:when>
                        <xsl:when test="mods:extension/localCollectionName = 'XUL'">
                            <mods:relatedItem type="host">
                                <mods:titleInfo>
                                    <mods:title>XUL</mods:title>
                                </mods:titleInfo>
                            </mods:relatedItem>                            
                        </xsl:when>                        
                        <xsl:when test="mods:titleInfo/mods:title = 'Ailleurs'">
                            <mods:relatedItem type="host">
                                <mods:titleInfo>
                                    <mods:title>Ailleurs</mods:title>
                                </mods:titleInfo>
                            </mods:relatedItem>                            
                        </xsl:when>
                        <xsl:when test="mods:extension/localCollectionName = 'STANDALONE'">
                            <xsl:call-template name="makerelatedItem">
                                <xsl:with-param name="paraNonSort"><xsl:value-of select="mods:titleInfo/mods:nonSort"/></xsl:with-param>
                                <xsl:with-param name="paraTitle"><xsl:value-of select="mods:titleInfo/mods:title"/></xsl:with-param>
                            </xsl:call-template>                             
                        </xsl:when>    
                        <xsl:otherwise/>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>  
            <xsl:apply-templates select="mods:relatedItem[@type='original']"/>
            <xsl:apply-templates select="mods:identifier"/>            
            <xsl:apply-templates select="mods:location"/>
            <xsl:apply-templates select="mods:accessCondition"/>
            <xsl:apply-templates select="mods:part"/>
            <xsl:apply-templates select="mods:extension"/>
            <xsl:apply-templates select="mods:recordInfo"/>
        </mods:mods>
    </xsl:template>
    
    <!-- DONE -->
    <xsl:template  match="mods:titleInfo">
        <xsl:element name="mods:titleInfo">
            <xsl:if test="position() ='1'">
                <xsl:attribute name="usage">primary</xsl:attribute>
            </xsl:if>
            <xsl:for-each select="@*">
                <xsl:attribute name="{name()}">
                    <xsl:value-of select="."/>
                </xsl:attribute>                
            </xsl:for-each>
            <xsl:for-each select="*">
                <xsl:element name="{name(.)}">
                    <xsl:value-of select="translate(.,'[]','')"/>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    
    <!-- DONE -->
    <xsl:template match="mods:name">
        
        
        <xsl:element name="mods:name">
            <xsl:for-each select="@*">
                <xsl:choose>
                    <xsl:when test=".='needs_review'"/>
                    <xsl:when test=".='oclc_naf'">
                        <xsl:attribute name="authority">naf</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        <!--    <xsl:choose>
                <xsl:when test="position()='1'">
                    <xsl:if test="mods:role/mods:roleTerm = 'Author' or mods:role/mods:roleTerm = 'Creator' or mods:role/mods:roleTerm = 'creator' or mods:role/mods:roleTerm = 'Composer' or mods:role/mods:roleTerm = 'Photographer'">
                        <xsl:attribute name="usage">primary</xsl:attribute>
                    </xsl:if>
                </xsl:when>
            </xsl:choose>    -->
            <xsl:if
                test="(mods:role/mods:roleTerm = 'Author' or mods:role/mods:roleTerm = 'Creator' or mods:role/mods:roleTerm = 'creator' or mods:role/mods:roleTerm = 'Composer' or mods:role/mods:roleTerm = 'Photographer')">
                
                <xsl:if test="(count(preceding-sibling::mods:name/mods:role['creator'])='0') and (count(preceding-sibling::mods:name/mods:role['Creator'])='0') and (count(preceding-sibling::mods:name/mods:role['Author'])='0') and (count(preceding-sibling::mods:name/mods:role['Composer'])='0') and (count(preceding-sibling::mods:name/mods:role['Photographer'])='0')">
                                       
                    <xsl:attribute name="usage">primary</xsl:attribute>
                </xsl:if>
                
            </xsl:if>
            <!-- Fix some ugly mods:relatedItem/mods:name nodes -->
            <xsl:if test="not(@type)">
                <xsl:if test="mods:namePart[@type='given'] or mods:namePart[@type='family']">
                    <xsl:attribute name="type">personal</xsl:attribute>
                </xsl:if>
            </xsl:if>
            <xsl:for-each select="mods:namePart">
                <xsl:choose>
                    <!-- Skip empty nodes -->
                    <xsl:when test=".=''"/>
                    <xsl:otherwise>
                        <xsl:copy-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            <xsl:choose>
                <xsl:when test="mods:displayForm">
                    <xsl:copy-of select="mods:displayForm"/>
                </xsl:when>
                <!-- Fix some ugly mods:relatedItem/mods:name nodes -->
                <xsl:otherwise>
                    <xsl:element name="mods:displayForm">
                        <xsl:choose>
                            <xsl:when
                                test="mods:namePart[@type='given'] or mods:namePart[@type='family']">
                                <xsl:for-each select="mods:namePart">
                                    <xsl:value-of select="."/>
                                    <xsl:if test="position() != last()">
                                        <xsl:text>, </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:for-each select="mods:namePart">
                                    <xsl:value-of select="."/>
                                    <xsl:if test="substring(.,string-length(.),1) != '.'">
                                        <xsl:text>. </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="mods:role">
                    <xsl:for-each select="mods:role">
                        <xsl:choose>
                            <xsl:when test="count(mods:roleTerm[@type='text']) > 1">
                                <xsl:for-each select="mods:roleTerm[@type='text']">
                                    <xsl:call-template name="processRole">
                                        <xsl:with-param name="paraRole">
                                            <!-- Normalize for lookup -->
                                            <xsl:value-of
                                                select="translate(substring(.,1,1),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                                            <xsl:value-of
                                                select="translate(substring(.,2),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"
                                            />
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="mods:roleTerm[@type='text']">
                                        <xsl:call-template name="processRole">
                                            <xsl:with-param name="paraRole">
                                                <xsl:value-of select="mods:roleTerm[@type='text']"/>
                                            </xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:when>
                                    <!-- We usually have text but not code -->
                                    <xsl:when test="mods:roleTerm[@type='code']">
                                        <xsl:call-template name="processRole">
                                            <xsl:with-param name="paraRole">
                                                <xsl:value-of select="mods:roleTerm[@type='code']"/>
                                            </xsl:with-param>
                                        </xsl:call-template>                                
                                    </xsl:when> 
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <!-- Default to Contributor -->
                    <xsl:call-template name="processRole">
                        <xsl:with-param name="paraRole">
                            <xsl:text>Contributor</xsl:text>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    
    <!-- DONE -->
    <xsl:template name="processRole">
        <xsl:param name="paraRole"/>
        <xsl:element name="mods:role">
            <xsl:element name="mods:roleTerm">
                   <xsl:attribute name="type">text</xsl:attribute>
                    <xsl:attribute name="authority">marcrelator</xsl:attribute>
                    <xsl:value-of select="$paraRole"/>
            </xsl:element>
            <xsl:element name="mods:roleTerm">
                <xsl:attribute name="type">code</xsl:attribute>
                <xsl:attribute name="authority">marcrelator</xsl:attribute>
                <xsl:value-of select="$rolelookup/RoleLookUp/role[@text=$paraRole]/@code"/>
            </xsl:element>            
        </xsl:element>        
    </xsl:template>
    
    <!-- DONE -->
    <xsl:template match="mods:typeOfResource">
        <xsl:copy-of select="."/>
    </xsl:template>
    
    <xsl:template name="processGenre">
        <xsl:choose>
            <xsl:when test="mods:genre">
                <xsl:for-each select="mods:genre">
                    <xsl:variable name="varLookup">
                        <xsl:value-of select="."/>
                    </xsl:variable>
                    <xsl:variable name="varGenre">
                        <xsl:choose>
                            <xsl:when test="@authority='gmgpc'">
                                <xsl:value-of select="translate(substring(.,1,1),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                                <xsl:value-of select="substring(.,2)"/>
                            </xsl:when>
                            <xsl:when test="$genrelookup/genreLookup/genre[@value=$varLookup]/@term">
                                <xsl:value-of select="$genrelookup/genreLookup/genre[@value=$varLookup]/@term"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- If it's not in the lookup, use value as it matches gmgpc -->
                                <xsl:value-of select="translate(substring(.,1,1),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                                <xsl:value-of select="substring(.,2)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="varAuth">
                        <xsl:choose>
                            <xsl:when test="$genrelookup/genreLookup/genre[@value=$varLookup]/@auth">
                                <xsl:value-of select="$genrelookup/genreLookup/genre[@value=$varLookup]/@auth"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@authority"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>                    
                    <xsl:choose>
                        <xsl:when test="position()=1">
                            <xsl:element name="mods:genre">
                                <xsl:attribute name="usage">primary</xsl:attribute>
                                <xsl:attribute name="authority"><xsl:value-of select="$varAuth"/></xsl:attribute>
                                <xsl:attribute name="type">work type</xsl:attribute>
                                <xsl:if test="@displayLabel">
                                    <xsl:attribute name="displayLabel"><xsl:value-of select="@displayLabel"/></xsl:attribute>
                                </xsl:if>
                                <xsl:value-of select="$varGenre"/>                                
                            </xsl:element>
                            <xsl:if test="not(@authority='gmgpc') and not(@authority='lctgm')">
                                <xsl:element name="mods:genre">
                                    <xsl:attribute name="authority">
                                        <xsl:value-of select="@authority"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="type">
                                        <xsl:text>work type</xsl:text>
                                    </xsl:attribute> 
                                    <xsl:if test="@displayLabel">
                                        <xsl:attribute name="displayLabel"><xsl:value-of select="@displayLabel"/></xsl:attribute>
                                    </xsl:if>                                    
                                    <xsl:value-of select="."/>
                                </xsl:element> 
                            </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:element name="mods:genre">
                                <xsl:attribute name="authority">
                                    <xsl:value-of select="@authority"/>
                                </xsl:attribute>
                                <xsl:attribute name="type">
                                    <xsl:text>work type</xsl:text>
                                </xsl:attribute>   
                                <xsl:if test="@displayLabel">
                                    <xsl:attribute name="displayLabel"><xsl:value-of select="@displayLabel"/></xsl:attribute>
                                </xsl:if>
                                <xsl:value-of select="."/>
                            </xsl:element>                             
                        </xsl:otherwise>
                    </xsl:choose>             
                </xsl:for-each>
            </xsl:when>
            <!--  -->
            <xsl:otherwise>
                <xsl:element name="mods:genre">
                    <xsl:attribute name="usage">primary</xsl:attribute>
                    <xsl:attribute name="type">work type</xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="/mods:mods/mods:relatedItem/mods:identifier[@type='accession number'] = 'BC.1986.019'">
                            <xsl:attribute name="authority">gmgpc</xsl:attribute>
                            <xsl:text>Photographs</xsl:text>
                        </xsl:when>
                        <xsl:when test="/mods:mods/mods:relatedItem/mods:identifier[@type='accession number'] = 'MS.1986.041'">
                            <xsl:attribute name="authority">lctgm</xsl:attribute>
                            <xsl:text>Correspondence</xsl:text>
                        </xsl:when>   
                        <xsl:when test="/mods:mods/mods:relatedItem/mods:identifier[@type='accession number'] = 'MS.1986.043'">
                            <xsl:attribute name="authority">lctgm</xsl:attribute>
                            <xsl:text>Correspondence</xsl:text>
                        </xsl:when>    
                        <xsl:when test="/mods:mods/mods:relatedItem/mods:identifier[@type='accession number'] = 'MS.1992.012'">
                            <xsl:attribute name="authority">lctgm</xsl:attribute>
                            <xsl:text>Sound recordings</xsl:text>
                        </xsl:when>  
                    </xsl:choose>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>    
    
    <xsl:template match="mods:originInfo">
        <xsl:element name="mods:originInfo">
            <xsl:if test="mods:place">
                <xsl:element name="mods:place">
                    <xsl:choose>
                        <xsl:when test="(mods:place[1]/@supplied) or (mods:place[2]/@supplied)">
                            <xsl:attribute name="supplied">yes</xsl:attribute>
                        </xsl:when>
                        <xsl:when
                            test="starts-with(mods:place[1]/mods:placeTerm[*], '[') or starts-with(mods:place[2]/mods:placeTerm[*], '[')">
                            <xsl:attribute name="supplied">yes</xsl:attribute>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:for-each select="mods:place/mods:placeTerm">
                        <xsl:element name="mods:placeTerm">
                            <xsl:attribute name="type">
                                <xsl:choose>
                                    <xsl:when test="not(@type='code')">
                                        <xsl:text>text</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>code</xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                            <xsl:if test="@authority">
                                <xsl:attribute name="authority">
                                    <xsl:value-of select="@authority"/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="normalize-space(translate(., '[]', ''))"/>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:if>
            <xsl:copy-of select="mods:publisher"/>
            <xsl:copy-of select="mods:dateOther"/>            
            <xsl:copy-of select="mods:dateIssued"/>
            <xsl:copy-of select="mods:dateCreated"/>
            <xsl:copy-of select="mods:copyrightDate"/>
            <xsl:copy-of select="mods:edition"/>
            <xsl:copy-of select="mods:issuance"/>
        </xsl:element>
    </xsl:template>

    <!-- DONE -->
    <xsl:template match="mods:language">        
        <xsl:variable name="varCode">
            <xsl:choose>
                <!-- skip -->
                <xsl:when test="mods:languageTerm[1]='la'"/>
                <xsl:when test="mods:languageTerm[1] = 'eng' or mods:languageTerm[1] ='English'">eng</xsl:when>
                <xsl:when test="mods:languageTerm[1] = 'fre' or mods:languageTerm[1] ='French'">fre</xsl:when>  
                <xsl:when test="mods:languageTerm[1] = 'heb' or mods:languageTerm[1] ='Hebrew'">heb</xsl:when>  
                <xsl:when test="mods:languageTerm[1] = 'ita' or mods:languageTerm[1] ='Italian'">ita</xsl:when>  
                <xsl:when test="mods:languageTerm[1] = 'lat' or mods:languageTerm[1] ='Latin'">lat</xsl:when>  
                <xsl:when test="mods:languageTerm[1] = 'por' or mods:languageTerm[1] ='Portuguese'">por</xsl:when>  
                <xsl:when test="mods:languageTerm[1] = 'spa' or mods:languageTerm[1] ='Spanish'">spa</xsl:when>
                <xsl:when test="mods:languageTerm[1] = 'dum' or mods:languageTerm[1] ='Dutch, Middle (ca.1050-1350)'">dum</xsl:when>                 
                <xsl:when test="mods:languageTerm[1] = 'zxx' or mods:languageTerm[1] ='Not applicable'">zxx</xsl:when> 
                <xsl:otherwise>zxx</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="mods:language">
            <xsl:for-each select="@*">
                <xsl:attribute name="{name()}">
                    <xsl:value-of select="."/>
                </xsl:attribute>                
            </xsl:for-each>                
            <xsl:element name="mods:languageTerm">
                <xsl:attribute name="type">code</xsl:attribute>
                <xsl:attribute name="authority">iso639-2b</xsl:attribute>
                    <xsl:value-of select="$varCode"/>
            </xsl:element>             
            <xsl:element name="mods:languageTerm">
                <xsl:attribute name="type">text</xsl:attribute>
                <xsl:attribute name="authority">iso639-2b</xsl:attribute>
                    <xsl:value-of select="$languagelookup/LanguageLookUp/language[@code=$varCode]/@language"/>
            </xsl:element>            
        </xsl:element>
    </xsl:template>
    
    <!-- DONE -->
    <xsl:template match="mods:physicalDescription">
        <xsl:element name="mods:physicalDescription">  
            <xsl:for-each select="mods:form">
                <xsl:element name="mods:form">
                    <xsl:choose>
                        <xsl:when test="@authority='gmd'">
                            <xsl:attribute name="authority">gmd</xsl:attribute>
                            <xsl:text>electronic resource</xsl:text>                                
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="authority">marcform</xsl:attribute>
                            <xsl:text>electronic</xsl:text>                            
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
            </xsl:for-each>
            <xsl:choose>
                <xsl:when test="mods:internetMediaType">
                    <xsl:copy-of select="mods:internetMediaType"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="/mods/mods:titleInfo/mods:title = 'Librarium'">
                            <xsl:text>application/pdf</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>image/jpeg</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:copy-of select="mods:extent"/>
            <xsl:choose>
                <xsl:when test="contains(mods:digitalOrigin,'reformatted')">
                    <xsl:element name="mods:digitalOrigin">
                        <xsl:text>reformatted digital</xsl:text>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="mods:digitalOrigin">
                        <xsl:text>reformatted digital</xsl:text>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    
    <!-- DONE -->
    <xsl:template match="mods:abstract">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space(.)) = 0"/>
            <xsl:otherwise>
                <xsl:element name="mods:abstract">
                    <xsl:value-of select="normalize-space(translate(., '“”', '&quot;&quot;'))"/>
                </xsl:element>                
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- DONE -->
    <xsl:template match="mods:tableOfContents">
        <xsl:copy-of select="."/>
    </xsl:template>
    
    <!-- DONE Not used by BC-->
    <xsl:template match="mods:targetAudience">
        <xsl:copy-of select="."/>
    </xsl:template>
    
    <!-- DONE -->
    <xsl:template match="mods:note">
        <xsl:element name="mods:note">
            <xsl:for-each select="@*">
                <xsl:choose>
                    <xsl:when test=".='501'"/>
                    <xsl:when test=".='acquistion'">
                        <xsl:attribute name="type">
                            <xsl:text>acquisition</xsl:text>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="{name()}">
                            <xsl:value-of select="."/>
                        </xsl:attribute>
                    </xsl:otherwise>                    
                </xsl:choose>
            </xsl:for-each>
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
    
    <!-- DONE -->
    <xsl:template match="mods:subject">
        <xsl:choose>
            <xsl:when test="mods:hierarchicalGeographic">
                <xsl:choose>
                    <xsl:when test="not(mods:hierarchicalGeographic/*)"/>
                    <xsl:otherwise>
                        <xsl:copy-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="mods:subject">
                    <xsl:for-each select="@*">
                        <xsl:attribute name="{name(.)}"><xsl:value-of select="."/></xsl:attribute>
                    </xsl:for-each>
                    <xsl:for-each select="*">
                        <xsl:choose>
                            <xsl:when test="mods:name">
                                <xsl:element name="mods:name">
                                    <xsl:for-each select="@*">
                                        <xsl:choose>
                                            <xsl:when test=".='oclc_naf'">
                                                <xsl:attribute name="{name(.)}">naf</xsl:attribute>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:attribute name="{name(.)}"><xsl:value-of select="."/></xsl:attribute>                                        
                                            </xsl:otherwise>
                                        </xsl:choose>      
                                    </xsl:for-each>
                                    <xsl:copy-of select="."/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:copy-of select="."/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:element>
            </xsl:otherwise>    
        </xsl:choose>
    </xsl:template>  
    
    <!-- DONE -->
    <xsl:template match="mods:classification">
        <!-- Per DC Guidlines move Call Numbers to Identifier -->
        <xsl:choose>
            <xsl:when test="@authority='dcc'">
                <xsl:element name="mods:identifier">
                    <xsl:attribute name="authority">dcc</xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@authority='lcc'">
                <xsl:element name="mods:identifier">
                    <xsl:attribute name="authority">lcc</xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:element>                
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    
    <!-- DONE -->
    <!--xsl:template match="mods:relatedItem[@type='host']">
        <xsl:if test="attribute::node()">
        <xsl:element name="mods:relatedItem">
            <xsl:copy-of select="attribute::node()"/>
            <xsl:apply-templates select="mods:titleInfo"/>
            <xsl:apply-templates select="mods:name"/>
            <xsl:apply-templates select="mods:typeOfResource"/>
            <xsl:apply-templates select="mods:genre" mode="relatedItem"/>
            <xsl:apply-templates select="mods:originInfo"/>
            <xsl:apply-templates select="mods:language"/>
            <xsl:apply-templates select="mods:physicalDescription"/>
            <xsl:apply-templates select="mods:abstract"/>
            <xsl:apply-templates select="mods:tableOfContents"/>
            <xsl:apply-templates select="mods:targetAudience"/>
            <xsl:apply-templates select="mods:note"/>
            <xsl:apply-templates select="mods:subject"/>
            <xsl:apply-templates select="mods:relatedItem"/>
            <xsl:apply-templates select="mods:identifier"/>
            <xsl:apply-templates select="mods:classification"/>            
            <xsl:apply-templates select="mods:location"/>
            <xsl:apply-templates select="mods:accessCondition"/>
            <xsl:apply-templates select="mods:part"/>
            <xsl:apply-templates select="mods:extension"/>
            <xsl:apply-templates select="mods:recordInfo"/>            
        </xsl:element>
        </xsl:if>
    </xsl:template-->
    <xsl:template match="mods:relatedItem[@type='original']">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="mods:relatedItem[@type='host']" mode="passThru">
       <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template name="makerelatedItem">
        <xsl:param name="paraNonSort"/>
        <xsl:param name="paraTitle"/>
        <xsl:element name="mods:relatedItem">
            <xsl:attribute name="type">host</xsl:attribute>
            <xsl:element name="mods:titleInfo">
                <xsl:if test="$paraNonSort !=''">
                    <xsl:element name="mods:nonSort">
                        <xsl:value-of select="$paraNonSort"/>
                    </xsl:element>
                </xsl:if>
                <xsl:element name="mods:title">
                    <xsl:value-of select="$paraTitle"/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="mods:genre" mode="relatedItem">
        <xsl:copy-of select="."/>
    </xsl:template>

    <!-- DONE -->
    <xsl:template match="mods:identifier">
        <xsl:element name="mods:identifier">
            <xsl:for-each select="@*">
                <xsl:choose>
                    <xsl:when test=". = 'accession number'">
                        <xsl:attribute name="{name()}">
                            <xsl:text>local-accession</xsl:text>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test=". = 'local'">
                        <xsl:attribute name="{name()}">
                            <xsl:text>local-other</xsl:text>
                        </xsl:attribute>
                    </xsl:when> 
                    <xsl:otherwise>
                        <xsl:attribute name="{name()}">
                            <xsl:value-of select="."/>
                        </xsl:attribute>                        
                    </xsl:otherwise>
                </xsl:choose>              
            </xsl:for-each>
            <xsl:value-of select="."/>          
        </xsl:element>
    </xsl:template>
    
    <!-- DONE -->
    <!--xsl:template match="mods:location">
        <xsl:element name="mods:location">
            <xsl:element name="mods:url">
                <xsl:attribute name="access">object in context</xsl:attribute>
                <xsl:attribute name="usage">primary display</xsl:attribute>
                <xsl:value-of select="concat('http://dcollections.bc.edu/R/?func=dbin-jump-full&amp;object_id=',$pid,'local_base=GEN01-BCD01')"/>
            </xsl:element>
            <xsl:element name="mods:url">
                <xsl:attribute name="access">preview</xsl:attribute>
                <xsl:value-of select="concat('http://dcollections.bc.edu/webclient/DeliveryManager?pid=',$thumbpid)"/>
            </xsl:element>
        </xsl:element>
    </xsl:template-->
    
    <!-- DONE -->
    <xsl:template match="mods:accessCondition">
        <xsl:element name="mods:accessCondition">
            <xsl:choose>
                <xsl:when test="@type='restrictionOnAccess'">
                    <xsl:attribute name="type">restriction on access</xsl:attribute>  
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="type">use and reproduction</xsl:attribute>  
                    <xsl:if test="@displayLabel">
                        <xsl:attribute name="displayLabel">
                            <xsl:value-of select="@displayLabel"/>
                        </xsl:attribute>                
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>            
            <xsl:value-of select="normalize-space(translate(., '“”', '&quot;&quot;'))"/>
        </xsl:element>
    </xsl:template>
    
    <!-- DONE -->
    <xsl:template match="mods:part">
        <xsl:copy-of select="."/>
    </xsl:template>
    
    <!-- DONE - But needs to be excluded -->
    <xsl:template match="mods:extension">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space(*)) =0"/>
            <xsl:otherwise>
                <xsl:element name="mods:extension">
                    <xsl:for-each select="*">
                        <xsl:choose>
                            <xsl:when test="substring-before(name(), ':')">
                               <xsl:element name="{local-name(.)}">
                                   <xsl:value-of select="."/>
                               </xsl:element> 
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:if test="string-length(normalize-space(.)) >0">
                                    <xsl:element name="{name(.)}">
                                        <xsl:value-of select="."/>
                                    </xsl:element>
                                </xsl:if>                                
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- DONE -->
    <xsl:template match="mods:recordInfo">
        <xsl:element name="mods:recordInfo">
            <xsl:element name="mods:recordContentSource">
                <xsl:attribute name="authority">marcorg</xsl:attribute>
                <xsl:text>MChB</xsl:text>
            </xsl:element>               
            <xsl:copy-of select="mods:recordCreationDate"/>
            <xsl:copy-of select="mods:recordChangeDate"/>  
            <xsl:if test="mods:recordIdentifier[@source]">
                <xsl:element name="mods:recordIdentifier">
                    <xsl:attribute name="source">
                        <xsl:value-of select="mods:recordIdentifier/@source"/>
                    </xsl:attribute>
                    <xsl:value-of select="normalize-space(mods:recordIdentifier)"/>
                </xsl:element>
            </xsl:if>
            <xsl:element name="mods:recordOrigin">OAI-PMH request</xsl:element>
            <!-- mods:recordOrigin not used -->
            <xsl:copy-of select="mods:languageOfCataloging"/>
            <!-- mods:descriptionStandard not used -->
        </xsl:element>
    </xsl:template>
    <xsl:template match="text()"/>
</xsl:stylesheet>
