<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:mods="http://www.loc.gov/mods/v3" 
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"   
    exclude-result-prefixes="mods oai" version="1.0">
    <xsl:template match="/oai:OAI-PMH/oai:ListRecords">
        <xsl:element name="add">
            <xsl:for-each select="oai:record">
                <xsl:element name="doc">
                    <field>
                        <xsl:attribute name="name">
                            <!-- Unless you want to muck around with BlackLight, this must be id and NOT PID -->
                            <xsl:text>id</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of select="oai:header/oai:identifier"/>
                    </field> 
                    <xsl:apply-templates select="oai:metadata/mods:mods/*" mode="processNode">
                        <xsl:with-param name="prefix">mods</xsl:with-param>
                    </xsl:apply-templates>
                    <!-- Sort fields for SOLR -->
                    <xsl:apply-templates select="oai:metadata/mods:mods/mods:originInfo/mods:dateCreated[@keyDate='yes']"/>
                    <xsl:apply-templates select="oai:metadata/mods:mods/mods:originInfo/mods:dateIssued[@keyDate='yes']"/>
                    <xsl:if test="oai:metadata/mods:mods/mods:originInfo/mods:dateCreated[@keyDate='yes'][@point='start']">
                        <xsl:element name="field">
                            <xsl:attribute name="name">
                                <xsl:text>mods_era_facet_ms</xsl:text>
                            </xsl:attribute>
                            <xsl:value-of select="concat(oai:metadata/mods:mods/mods:originInfo/mods:dateCreated[@keyDate='yes'][@point='start'], '-',oai:metadata/mods:mods/mods:originInfo/mods:dateCreated[@point='end'])"/>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="oai:metadata/mods:mods/mods:originInfo/mods:dateIssued[@keyDate='yes'][@point='yes']">
                        <xsl:element name="field">
                            <xsl:attribute name="name">
                                <xsl:text>mods_era_facet_ms</xsl:text>
                            </xsl:attribute>
                            <xsl:value-of select="concat(oai:metadata/mods:mods/mods:originInfo/mods:dateIssued[@keyDate='yes'][@point='start'], '-',oai:metadata/mods:mods/mods:originInfo/mods:dateIssued[@point='end'])"/>
                        </xsl:element>                        
                    </xsl:if>                    
                    <xsl:apply-templates select="oai:metadata/mods:mods/mods:genre[@usage='primary']"/>
                    <xsl:apply-templates select="oai:metadata/mods:mods/mods:genre[not(@usage='primary')]"/>
                    <xsl:if test="oai:metadata/mods:mods/mods:relatedItem[@type='host']/mods:titleInfo/mods:title = 'Bobbie Hanvey Photographic Archives'">
                        <xsl:apply-templates select="oai:metadata/mods:mods/mods:location/mods:holdingSimple/mods:copyInformation/mods:itemIdentifier[@type='local']"/> 
                    </xsl:if>
                    <xsl:for-each select="oai:metadata/mods:mods/mods:subject/mods:geographic[not(.=../preceding-sibling::*/mods:geographic)]">
                        <xsl:variable name="prefix">
                            <xsl:value-of select="concat('mods_', local-name())"/>
                        </xsl:variable>  
                        <xsl:element name="field">
                            <xsl:attribute name="name">
                                <xsl:value-of select="concat($prefix, '_subject_ms')"/>
                            </xsl:attribute>
                            <xsl:value-of select="."/>
                        </xsl:element>   
                        <xsl:element name="field">
                            <xsl:attribute name="name">
                                <xsl:value-of select="concat($prefix, '_subject_mt')"/>
                            </xsl:attribute>
                            <xsl:value-of select="."/>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="*" mode="processNode">
        <xsl:param name="prefix"/>
        <xsl:choose>
            <xsl:when test="local-name()='subject'">
                <xsl:apply-templates select="." mode="processSubject"/>
            </xsl:when>
            <xsl:when test="local-name()='relatedItem'">
                <xsl:apply-templates select="." mode="processrelatedItem"/>
            </xsl:when> 
            <xsl:when test="local-name()='name'">
                <xsl:apply-templates select="." mode="processName"/>
            </xsl:when>             
            <xsl:when test="local-name()='titleInfo' and @usage='primary'">
                <xsl:apply-templates select="."/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="thisPrefix">
                    <xsl:value-of select="concat($prefix, '_', local-name())"/>
                    <xsl:for-each select="@*">
                        <xsl:text>_</xsl:text>                
                        <xsl:value-of select="local-name()"/>
                        <xsl:text>_</xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="textValue">
                    <xsl:value-of select="normalize-space(text())"/>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="not($textValue ='')">
                        <field>
                            <xsl:attribute name="name">
                                <xsl:value-of select="concat(translate($thisPrefix,' /','__'), '_ms')"/>
                            </xsl:attribute>
                            <xsl:value-of select="text()"/>
                        </field>  
                        <field>
                            <xsl:attribute name="name">
                                <xsl:value-of select="concat(translate($thisPrefix,' /','__'), '_mt')"/>
                            </xsl:attribute>
                            <xsl:value-of select="text()"/>
                        </field>                
                    </xsl:when>
                    <xsl:otherwise>       
                        <xsl:apply-templates mode="processNode">
                            <xsl:with-param name="prefix">
                                <xsl:value-of select="$thisPrefix"/>
                            </xsl:with-param>
                        </xsl:apply-templates>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="mods:titleInfo[@usage='primary']">
        <xsl:variable name="varTitle">
            <xsl:value-of select="mods:title"/>
            <xsl:if test="mods:subTitle">
                <xsl:value-of select="concat(': ', mods:subTitle)"/>
           </xsl:if>
            <xsl:if test="mods:partName">
                <xsl:value-of select="concat('. ', mods:partName)"/>
            </xsl:if>
            <xsl:if test="mods:partNumber">
                <xsl:value-of select="concat('. ', mods:partNumber)"/>
            </xsl:if>
        </xsl:variable>    
        <field>
            <xsl:attribute name="name">
                <xsl:text>mods_titleInfo_usage_primary_title_ms</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="concat(mods:nonSort,$varTitle)"/>
        </field>
        <field>
            <xsl:attribute name="name">
                <xsl:text>mods_titleInfo_usage_primary_title_mt</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="concat(mods:nonSort,$varTitle)"/>
        </field>   
        <field>
            <xsl:attribute name="name">
                <xsl:text>mods_titleInfo_usage_primary_title_sort</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="$varTitle"/>
        </field>      
    </xsl:template>
    <xsl:template match="mods:name" mode="processName">
        <xsl:variable name="prefix">
            <xsl:value-of select="concat('mods', '_', local-name())"/>
            <xsl:if test="@usage='primary'">
                <xsl:text>_usage_primary</xsl:text>
            </xsl:if>
        </xsl:variable>
        <field>
            <xsl:attribute name="name">
                <xsl:value-of select="concat($prefix, '_displayForm_', mods:role/mods:roleTerm[@type='code'], '_ms')"/>
            </xsl:attribute>
            <xsl:value-of select="mods:displayForm"/>
        </field>  
        <field>
            <xsl:attribute name="name">
                <xsl:value-of select="concat($prefix, '_displayForm_', mods:role/mods:roleTerm[@type='code'], '_mt')"/>
            </xsl:attribute>
            <xsl:value-of select="mods:displayForm"/>
        </field>         
    </xsl:template>   
    <xsl:template match="mods:subject" mode="processSubject">
        <xsl:variable name="prefix">
            <xsl:value-of select="concat('mods', '_', local-name())"/>
            <xsl:for-each select="@*">
                <xsl:text>_</xsl:text>                
                <xsl:value-of select="local-name()"/>
                <xsl:text>_</xsl:text>
                <xsl:value-of select="."/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="mods:geographicCode"/>
            <xsl:when test="mods:name">
                <xsl:variable name="varSubjectName">
                    <xsl:choose>
                        <xsl:when test="mods:name/mods:displayForm">
                            <xsl:value-of select="mods:name/mods:displayForm"/>
                            <xsl:if test="mods:topic">
                                <xsl:value-of select="concat(' -- ', mods:topic)"/>
                            </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="mods:name/mods:namePart"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <field>
                    <xsl:attribute name="name">
                        <xsl:value-of select="concat($prefix, '_name_displayForm_ms')"/>
                    </xsl:attribute>
                    <xsl:value-of select="$varSubjectName"/>
                </field> 
                <field>
                    <xsl:attribute name="name">
                        <xsl:value-of select="concat($prefix, '_name_displayForm_mt')"/>
                    </xsl:attribute>
                    <xsl:value-of select="$varSubjectName"/>
                </field>   
            </xsl:when>
            <xsl:when test="mods:hierarchicalGeographic">
                <xsl:variable name="varPlace">
                    <xsl:value-of select="mods:hierarchicalGeographic/mods:area"/>
                    <xsl:if test="mods:hierarchicalGeographic/mods:citySection">
                        <xsl:choose>
                            <xsl:when test="mods:hierarchicalGeographic/mods:area">
                                <xsl:value-of select="concat(', ',mods:hierarchicalGeographic/mods:citySection)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="mods:hierarchicalGeographic/mods:citySection"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    <xsl:if test="mods:hierarchicalGeographic/mods:city">
                        <xsl:choose>
                            <xsl:when test="mods:hierarchicalGeographic/mods:area | mods:hierarchicalGeographic/mods:citySection">
                                <xsl:value-of select="concat(', ',mods:hierarchicalGeographic/mods:city)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="mods:hierarchicalGeographic/mods:city"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    <xsl:if test="mods:hierarchicalGeographic/mods:county">
                        <xsl:choose>
                            <xsl:when test="mods:hierarchicalGeographic/mods:area | mods:hierarchicalGeographic/mods:citySection | mods:hierarchicalGeographic/mods:city">
                                <xsl:value-of select="concat(', ',mods:hierarchicalGeographic/mods:county)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="mods:hierarchicalGeographic/mods:county"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    <xsl:if test="mods:hierarchicalGeographic/mods:state">
                        <xsl:choose>
                            <xsl:when test="mods:hierarchicalGeographic/mods:area | mods:hierarchicalGeographic/mods:citySection | mods:hierarchicalGeographic/mods:city | mods:hierarchicalGeographic/mods:county">
                                <xsl:value-of select="concat(', ',mods:hierarchicalGeographic/mods:state)"/>                                
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="mods:hierarchicalGeographic/mods:state"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if> 
                    <xsl:if test="mods:hierarchicalGeographic/mods:country">
                        <xsl:choose>
                            <xsl:when test="mods:hierarchicalGeographic/mods:area | mods:hierarchicalGeographic/mods:citySection | mods:hierarchicalGeographic/mods:city | mods:hierarchicalGeographic/mods:county | mods:hierarchicalGeographic/mods:state">
                                <xsl:value-of select="concat(', ',mods:hierarchicalGeographic/mods:country)"/>                                
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="mods:hierarchicalGeographic/mods:country"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>                     
                </xsl:variable>
                <field>
                    <xsl:attribute name="name">
                        <xsl:value-of select="concat($prefix, '_hierarchicalGeographic_displayForm_ms')"/>
                    </xsl:attribute>   
                    <xsl:value-of select="$varPlace"/>
                </field>     
                <field>
                    <xsl:attribute name="name">
                        <xsl:value-of select="concat($prefix, '_hierarchicalGeographic_displayForm_mt')"/>
                    </xsl:attribute>   
                    <xsl:value-of select="$varPlace"/>
                </field>                   
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="varSubject">
                    <xsl:choose>
                        <xsl:when test="@authority='tucua'">
                            <!-- Ditch these for now : similar terms in other vocabs -->
                            <!--xsl:value-of select="translate(substring(mods:topic,1,1),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                            <xsl:value-of select="substring(mods:topic,2)"/-->                          
                        </xsl:when>
                        <xsl:when test="@authority='lctgm'">
                            <xsl:value-of select="translate(substring(mods:topic,1,1),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                            <xsl:value-of select="substring(mods:topic,2)"/>                          
                        </xsl:when>
                        <xsl:when test="mods:cartographics"/>
                        <!-- Not very useful unless we deploy a map. -->
                        <xsl:otherwise>
                            <xsl:for-each select="*">
                                <xsl:choose>                           
                                    <xsl:when test="position()=last()">
                                        <xsl:value-of select="."/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="concat(.,' -- ')"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>                            
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable> 
                <xsl:if test="$varSubject !='' and @authority='marcgac'">
                    <field>
                        <xsl:attribute name="name">
                            <xsl:value-of select="concat($prefix, '_subject_displayForm_ms')"/>
                        </xsl:attribute>
                        <xsl:value-of select="$varSubject"/>
                    </field>  
                    <field>
                        <xsl:attribute name="name">
                            <xsl:value-of select="concat($prefix, '_subject_displayForm_mt')"/>
                        </xsl:attribute>
                        <xsl:value-of select="$varSubject"/>
                    </field>
                </xsl:if>
                <xsl:if test="$varSubject !='' and @authority='gmgpc'">
                    <field>
                        <xsl:attribute name="name">
                            <xsl:value-of select="concat($prefix, '_displayForm_ms')"/>
                        </xsl:attribute>
                        <xsl:value-of select="$varSubject"/>
                    </field>  
                    <field>
                        <xsl:attribute name="name">
                            <xsl:value-of select="concat($prefix, '_displayForm_mt')"/>
                        </xsl:attribute>
                        <xsl:value-of select="$varSubject"/>
                    </field>
                </xsl:if>                
                <xsl:if test="$varSubject !='' and @authority='lcsh'">
                    <field>
                        <xsl:attribute name="name">
                            <xsl:value-of select="concat($prefix, '_displayForm_ms')"/>
                        </xsl:attribute>
                        <xsl:value-of select="$varSubject"/>
                    </field>  
                    <field>
                        <xsl:attribute name="name">
                            <xsl:value-of select="concat($prefix, '_displayForm_mt')"/>
                        </xsl:attribute>
                        <xsl:value-of select="$varSubject"/>
                    </field>
                </xsl:if>
                <xsl:if test="$varSubject !='' and not(@authority)">
                    <xsl:for-each select="*">
                    <field>
                        <xsl:attribute name="name">
                            <xsl:value-of select="concat($prefix, '_keyword_displayForm_ms')"/>
                        </xsl:attribute>
                        <xsl:value-of select="."/>
                    </field>  
                    <field>
                        <xsl:attribute name="name">
                            <xsl:value-of select="concat($prefix, '_keyword_displayForm_mt')"/>
                        </xsl:attribute>
                        <xsl:value-of select="."/>
                    </field>
                    </xsl:for-each>
                </xsl:if>                
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="mods:relatedItem[@type='host']" mode="processrelatedItem">
        <xsl:variable name="prefix">
            <xsl:value-of select="concat('mods', '_', local-name())"/>
            <xsl:for-each select="@*">
                <xsl:text>_</xsl:text>                
                <xsl:value-of select="local-name()"/>
                <xsl:text>_</xsl:text>
                <xsl:value-of select="."/>
            </xsl:for-each>
        </xsl:variable>    
        <xsl:variable name="varTitle">
            <xsl:apply-templates select="mods:titleInfo" mode="processrelatedItem"/>
        </xsl:variable>
        <xsl:variable name="varPart">
            <xsl:if test="mods:part/mods:detail[@type='series']">
                <xsl:text>. </xsl:text>
                <xsl:apply-templates select="mods:part/mods:detail[@type='series']" mode="processrelatedItem"/>
            </xsl:if>
        </xsl:variable>
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:value-of select="concat($prefix, '_collectionFacet_ms')"/>
            </xsl:attribute>
            <xsl:value-of select="$varTitle"/>
            <xsl:value-of select="$varPart"/>            
        </xsl:element> 
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:value-of select="concat($prefix, '_collectionFacet_mt')"/>
            </xsl:attribute>
            <xsl:value-of select="$varTitle"/>
            <xsl:value-of select="$varPart"/>            
        </xsl:element>
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:value-of select="concat($prefix, '_collection_ms')"/>
            </xsl:attribute>
            <xsl:value-of select="$varTitle"/>         
        </xsl:element> 
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:value-of select="concat($prefix, '_collection_mt')"/>
            </xsl:attribute>
            <xsl:value-of select="$varTitle"/>           
        </xsl:element>          
        <xsl:if test="mods:part">
            <xsl:if test="mods:part/mods:detail[@type='series']">
                <xsl:variable name="varSeries">
                    <xsl:apply-templates select="mods:part/mods:detail[@type='series']" mode="processrelatedItem"/>
                </xsl:variable>
                <xsl:element name="field">
                    <xsl:attribute name="name">
                        <xsl:value-of select="concat($prefix, '_series_ms')"/>
                    </xsl:attribute>
                    <xsl:value-of select="$varSeries"/>
                </xsl:element> 
                <xsl:element name="field">
                    <xsl:attribute name="name">
                        <xsl:value-of select="concat($prefix, '_series_mt')"/>
                    </xsl:attribute>
                    <xsl:value-of select="$varSeries"/>
                </xsl:element>
            </xsl:if>
            <xsl:variable name="varParts">
                <xsl:for-each select="mods:part/mods:detail[not(@type='series')]">
                    <xsl:apply-templates select="." mode="processrelatedItem"/>
                </xsl:for-each>
            </xsl:variable>   
            <xsl:element name="field">
                <xsl:attribute name="name">
                    <xsl:value-of select="concat($prefix, '_partOf_ms')"/>
                </xsl:attribute>
                <xsl:value-of select="$varParts"/>
            </xsl:element> 
            <xsl:element name="field">
                <xsl:attribute name="name">
                    <xsl:value-of select="concat($prefix, '_partOf_mt')"/>
                </xsl:attribute>
                <xsl:value-of select="$varParts"/>
            </xsl:element>             
        </xsl:if>
        <xsl:if test="mods:location/mods:url">
            <xsl:element name="field">
                <xsl:attribute name="name">
                    <xsl:value-of select="concat($prefix, '_findingAid_ms')"/>
                </xsl:attribute>
                <xsl:value-of select="mods:location/mods:url"/>
            </xsl:element>             
        </xsl:if>
    </xsl:template>
    <xsl:template match="mods:titleInfo" mode="processrelatedItem">
        <xsl:value-of select="mods:nonSort"/>
        <xsl:value-of select="normalize-space(mods:title)"/>
        <xsl:if test="mods:subTitle">
            <xsl:value-of select="concat(': ', mods:nonSort)"/>
        </xsl:if>
        <xsl:if test="mods:partName">
            <xsl:value-of select="concat('. ', mods:partName)"/>
        </xsl:if>
        <xsl:if test="mods:partNumber">
            <xsl:value-of select="concat('. ', mods:partNumber)"/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="mods:detail" mode="processrelatedItem">
        <xsl:for-each select="*">
            <xsl:choose>
                <xsl:when test="position()=1">
                    <xsl:value-of select="."/>
                </xsl:when>
                <xsl:when test="position()=last()">
                    <xsl:value-of select="concat(' ', . ,'. ')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat(' ', . ,', ')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="mods:dateCreated[@keyDate='yes'] | mods:dateIssued[@keyDate='yes']">
        <xsl:if test=".!=''">
            <xsl:choose>
                <xsl:when test="not(@point)">
                    <field>
                        <xsl:attribute name="name">
                            <xsl:text>mods_keydate_sort</xsl:text>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="contains(.,'-')">
                                <xsl:value-of select="substring-before(.,'-')"/>   
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="."/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </field>
                    <field>
                        <xsl:attribute name="name">
                            <xsl:text>mods_date_facet_ms</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of select="concat(substring(.,1,3),'0s')"/>
                    </field>                     
                </xsl:when>
                <xsl:otherwise>
                    <field>
                        <xsl:attribute name="name">
                            <xsl:text>mods_date_facet_ms</xsl:text>
                        </xsl:attribute>
                        <xsl:text>Undated</xsl:text>
                    </field>                      
                </xsl:otherwise>
            </xsl:choose>                
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="mods:genre[@usage='primary']"> 
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>mods_format_normalized_ms</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="."/>
            <!--xsl:value-of select="translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/-->
        </xsl:element>   
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>mods_format_normalized_mt</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="."/>
            <!--xsl:value-of select="translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/-->
        </xsl:element>        
    </xsl:template>
    <xsl:template match="mods:genre[not(@usage='primary')]">
        <xsl:variable name="prefix">
            <xsl:value-of select="concat('mods_', local-name())"/>
        </xsl:variable>   
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:value-of select="concat($prefix, '_normalized_ms')"/>
            </xsl:attribute>
            <xsl:value-of select="."/>
            <!--xsl:value-of select="translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/-->
        </xsl:element>   
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:value-of select="concat($prefix, '_normalized_mt')"/>
            </xsl:attribute>
            <xsl:value-of select="."/>
            <!--xsl:value-of select="translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/-->
        </xsl:element>        
    </xsl:template>
    <xsl:template match="text()" mode="processNode"/>
    <xsl:template match="text()" mode="processrelatedItem"/>
    <xsl:template match="text()"/>    
</xsl:stylesheet>
