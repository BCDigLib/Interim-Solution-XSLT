<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:mods="http://www.loc.gov/mods/v3" 
	xmlns:xlink="http://www.w3.org/1999/xlink" 
	xmlns:marc="http://www.loc.gov/MARC21/slim" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	exclude-result-prefixes="xlink marc"> 
	<xsl:include href="MARC212MODSUtils.xsl"/>
	
	<xsl:template match="/marc:record">
		<mods:mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-6.xsd" version="3.6">
			<!-- mods:titleInfo -->
			<xsl:apply-templates select="marc:datafield[@tag=245] | marc:datafield[@tag=246] | marc:datafield[@tag=740]"/>
			<!-- mods:name -->
			<xsl:apply-templates select="marc:datafield[@tag=100] | marc:datafield[@tag=700]"/>
			<!-- mods:typeOfResource 
				 mods:genre -->
			<xsl:apply-templates select="marc:leader" mode="formats">
				<xsl:with-param name="para008" select="substring(marc:controlfield[@tag='008'],34,1)"/>
			</xsl:apply-templates>
			<!-- mods:originInfo -->
			<xsl:element name="mods:originInfo">
				<xsl:apply-templates select="marc:datafield[@tag=033]"/>
				<xsl:apply-templates select="marc:datafield[@tag=260]/marc:subfield[@code='a']"/>
				<xsl:apply-templates select="marc:datafield[@tag=260]/marc:subfield[@code='e']"/>
				<xsl:apply-templates select="marc:datafield[@tag=260]/marc:subfield[@code='b']"/>
				<xsl:apply-templates select="marc:datafield[@tag=260]/marc:subfield[@code='f']"/>					
				<xsl:apply-templates select="marc:datafield[@tag=260]/marc:subfield[@code='c']">
					<xsl:with-param name="paraDate1" select="substring(marc:controlfield[@tag='008'],8,4)"/>
					<xsl:with-param name="paraDate2" select="substring(marc:controlfield[@tag='008'],12,4)"/>		
					<xsl:with-param name="para008_06" select="substring(marc:controlfield[@tag='008'],7,1)"/>
					<xsl:with-param name="paraLdr06" select="substring(marc:controlfield[@tag='008'],7,1)"/>
				</xsl:apply-templates>
				<xsl:element name="mods:issuance">monographic</xsl:element>
			</xsl:element>
			<!-- mods:language -->
			<xsl:call-template name="processLanguage">
				<xsl:with-param name="paraLang">substring(marc:controlfield[@tag='008'],36,3)</xsl:with-param>
			</xsl:call-template>
			<!-- mods:extent -->
			<xsl:apply-templates select="marc:datafield[@tag=300]"/>
			<!-- mods:abstract -->
			<xsl:apply-templates select="marc:datafield[@tag=520]"/>
			<!-- mods:tableOfContents / mods:targetAudience not used -->
			<!--  mods:note -->
			<xsl:apply-templates select="marc:datafield[@tag=500]"/>		
			<xsl:apply-templates select="marc:datafield[@tag=530]"/>
			<xsl:apply-templates select="marc:datafield[@tag=533]"/>
			<xsl:apply-templates select="marc:datafield[@tag=535]"/>	
			<!-- mods:subject -->	
			<xsl:apply-templates select="marc:datafield[@tag=600]"/>
			<xsl:apply-templates select="marc:datafield[@tag=610]"/>
			<xsl:apply-templates select="marc:datafield[@tag=611]"/>
			<xsl:apply-templates select="marc:datafield[@tag=630]"/> 
			<xsl:apply-templates select="marc:datafield[@tag=650]"/> 
			<xsl:apply-templates select="marc:datafield[@tag=651]"/>
			<xsl:apply-templates select="marc:datafield[@tag=653]"/>
			<xsl:apply-templates select="marc:datafield[@tag=655]"/>			
			<xsl:apply-templates select="marc:datafield[@tag=752]"/>			
			<!-- mods:classification not used -->
			<!-- mods:relateditem -->
			<xsl:call-template name="processRelatedItem"/>
			<!-- mods:identifier  Added by addUrlsToDigComm.xsl -->
			<xsl:apply-templates select="marc:datafield[@tag=035]"/>
			<xsl:call-template name="processHdl">
				<xsl:with-param name="paraId">
					<xsl:choose>
						<xsl:when test="marc:datafield[@tag='940']/marc:subfield[@code='a'] = 'BECKER COLLECTION'">
							<xsl:value-of select="marc:datafield[@tag='035']/marc:subfield[@code='a']"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="marc:controlfield[@tag='001']"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
			</xsl:call-template>
			<!-- mods:location  Added by addUrlsToDigComm.xsl -->
			<!-- mods:accessCondition -->
			<xsl:apply-templates select="marc:datafield[@tag=540]"/>
			<!-- mods:part not used -->
			<!-- mods:extension -->
			<xsl:call-template name="process940"/>
			<!-- mods:recordInfo -->
			<xsl:call-template name="processRecordInfo"/>
		</mods:mods>
	</xsl:template>
	<!-- 
		mods:titleInfo
	-->
	<xsl:template match="marc:datafield[@tag=245] | marc:datafield[@tag=246] | marc:datafield[@tag=740]">
		<xsl:element name="mods:titleInfo">
			<xsl:choose>
				<xsl:when test="@tag=245">
					<xsl:attribute name="usage">primary</xsl:attribute>					
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="type">alternative</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="contains(marc:subfield[@code='a'],'[')">
				<xsl:attribute name="supplied">yes</xsl:attribute>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="@ind2 > '0'">
					<xsl:element name="mods:nonSort">
						<xsl:call-template name="stripBrackets">
							<xsl:with-param name="paraData">
								<xsl:value-of select="substring(marc:subfield[@code='a'], 1, @ind2)"/>
							</xsl:with-param>
						</xsl:call-template>						
					</xsl:element>
					<xsl:element name="mods:title">
						<xsl:call-template name="stripBrackets">
							<xsl:with-param name="paraData">		
								<xsl:call-template name="chopPunctuation">
									<xsl:with-param name="chopString">
										<xsl:value-of select="substring(marc:subfield[@code='a'], @ind2+1)"/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="mods:title">
						<xsl:call-template name="stripBrackets">
							<xsl:with-param name="paraData">
								<xsl:call-template name="chopPunctuation">
									<xsl:with-param name="chopString">
								<xsl:value-of select="marc:subfield[@code='a']"/>
									</xsl:with-param>
								</xsl:call-template>
						</xsl:with-param>
						</xsl:call-template>
					</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="marc:subfield[@code='b']">
				<xsl:element name="mods:subTitle">
					<xsl:call-template name="stripBrackets">
						<xsl:with-param name="paraData">
							<xsl:call-template name="chopPunctuation">
								<xsl:with-param name="chopString">
							<xsl:value-of select="marc:subfield[@code='b']"/>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:element>
			</xsl:if>
		</xsl:element>
	</xsl:template>
	<!-- 
		mods:name
	-->
	<xsl:template match="marc:datafield[@tag=100] | marc:datafield[@tag=700] | marc:datafield[@tag=720]">
		<xsl:element name="mods:name">
			<xsl:choose>
				<xsl:when test="@tag=720">
					<xsl:element name="mods:namePart">
						<xsl:value-of select="marc:subfield[@code='a']"/>
					</xsl:element>					
				</xsl:when>
				<xsl:when test="contains(marc:subfield[@code='a'],',')">
						<xsl:attribute name="type">personal</xsl:attribute>
					<xsl:variable name="varFamily">
						<xsl:call-template name="chopPunctuation">
							<xsl:with-param name="chopString">
								<xsl:value-of select="substring-before(marc:subfield[@code='a'],',')"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:variable>
					<xsl:variable name="varGiven">
						<xsl:call-template name="chopPunctuation">
							<xsl:with-param name="chopString">
								<xsl:value-of select="translate(substring-after(marc:subfield[@code='a'],', '),',','')"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:variable>
					<xsl:element name="mods:namePart">
							<xsl:attribute name="type">family</xsl:attribute>
							<xsl:value-of select="$varFamily"/>
						</xsl:element>
					<xsl:element name="mods:namePart">
						<xsl:attribute name="type">given</xsl:attribute>
						<xsl:value-of select="$varGiven"/>
					</xsl:element>	
					<xsl:if test="marc:subfield[@code='d']">
						<xsl:element name="mods:namePart">
							<xsl:attribute name="type">date</xsl:attribute>
							<xsl:call-template name="chopPunctuation">
								<xsl:with-param name="chopString"><xsl:value-of select="marc:subfield[@code='d']"/></xsl:with-param>
							</xsl:call-template>							
						</xsl:element>
					</xsl:if>					
					<xsl:element name="mods:displayForm">
						<xsl:value-of select="concat($varFamily,', ',$varGiven)"/>
						<xsl:if test="marc:subfield[@code='d']">
							<xsl:text> </xsl:text>
							<xsl:call-template name="chopPunctuation">
								<xsl:with-param name="chopString"><xsl:value-of select="marc:subfield[@code='d']"/></xsl:with-param>
							</xsl:call-template>	
						</xsl:if>
					</xsl:element>
					<xsl:if test="marc:subfield[@code='4']">
						<xsl:call-template name="processRole">
							<xsl:with-param name="paraRole">
								<xsl:value-of select="marc:subfield[@code='4']"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="mods:displayForm">
						<xsl:call-template name="chopPunctuation">
							<xsl:with-param name="chopString"><xsl:value-of select="marc:subfield[@code='a']"/></xsl:with-param>
						</xsl:call-template>
					</xsl:element>
					<xsl:if test="marc:subfield[@code='4']">
						<xsl:call-template name="processRole">
							<xsl:with-param name="paraRole">
								<xsl:value-of select="marc:subfield[@code='4']"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>	
		</xsl:element>
	</xsl:template>
	<!-- 
		mods:typeOfResource
	-->
	<xsl:template match="marc:leader" mode="formats">
		<xsl:param name="para008"/>
		<xsl:element name="mods:typeOfResource">
			<xsl:choose>
				<xsl:when test="substring(.,7,1) = 'k'">
					<xsl:text>still image</xsl:text>
				</xsl:when>
				<xsl:when test="substring(.,7,1) = 'r'">
					<xsl:text>three dimensional object</xsl:text>
				</xsl:when>				
			</xsl:choose>
		</xsl:element>
			<xsl:choose>
				<xsl:when test="$para008 = 'a'">
					<xsl:element name="mods:genre">
						<xsl:attribute name="usage">primary</xsl:attribute>
						<xsl:attribute name="authority">gmgpc</xsl:attribute>
						<xsl:attribute name="type">work type</xsl:attribute>
						<xsl:text>Drawings</xsl:text>
					</xsl:element>
					<xsl:element name="mods:genre">
						<xsl:attribute name="authority">marcgt</xsl:attribute>
						<xsl:attribute name="type">work type</xsl:attribute>
						<xsl:text>art original</xsl:text>
					</xsl:element>						
				</xsl:when>
				<xsl:when test="$para008 = 'i'">
					<xsl:element name="mods:genre">
						<xsl:attribute name="usage">primary</xsl:attribute>
						<xsl:attribute name="authority">gmgpc</xsl:attribute>
						<xsl:attribute name="type">work type</xsl:attribute>
						<xsl:text>Photographs</xsl:text>
					</xsl:element>
					<xsl:element name="mods:genre">
						<xsl:attribute name="authority">marcgt</xsl:attribute>
						<xsl:attribute name="type">work type</xsl:attribute>
						<xsl:text>picture</xsl:text>
					</xsl:element>
				</xsl:when>
				<xsl:when test="$para008 = 'r'">
					<xsl:element name="mods:genre">
						<xsl:attribute name="usage">primary</xsl:attribute>
						<xsl:attribute name="authority">gmgpc</xsl:attribute>
						<xsl:attribute name="type">work type</xsl:attribute>
						<xsl:text>Objects</xsl:text>
					</xsl:element>
					<xsl:element name="mods:genre">
						<xsl:attribute name="authority">lctgm</xsl:attribute>
						<xsl:attribute name="type">work type</xsl:attribute>
						<xsl:text>realia</xsl:text>
					</xsl:element>					
				</xsl:when>
			</xsl:choose>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=655]">
		<xsl:element name="mods:subject">
			<xsl:apply-templates select="marc:subfield[@code='2']" mode="authority"/>
			<xsl:if test="marc:subfield[@code='a']">
				<xsl:element name="mods:genre">
					<xsl:call-template name="chopPunctuation">
						<xsl:with-param name="chopString"><xsl:value-of select="marc:subfield[@code='a']"/></xsl:with-param>
					</xsl:call-template>
				</xsl:element>
			</xsl:if>
			<xsl:if test="marc:subfield[@code='x']">
				<xsl:element name="mods:topic">
					<xsl:call-template name="chopPunctuation">
						<xsl:with-param name="chopString"><xsl:value-of select="marc:subfield[@code='x']"/></xsl:with-param>
					</xsl:call-template>
				</xsl:element>
			</xsl:if>
			<xsl:if test="marc:subfield[@code='y']">
				<xsl:element name="mods:temporal">
					<xsl:call-template name="chopPunctuation">
						<xsl:with-param name="chopString"><xsl:value-of select="marc:subfield[@code='y']"/></xsl:with-param>
					</xsl:call-template>
				</xsl:element>
			</xsl:if>	
		</xsl:element>
	</xsl:template>
	<!-- 
		mods:dateCaptured
	-->
	<xsl:template match="marc:datafield[@tag=033]">
		<xsl:for-each select="marc:subfield[@code='a']">
			<xsl:element name="mods:dateCaptured">
				<xsl:attribute name="encoding">iso8601</xsl:attribute>
				<xsl:value-of select="."/>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
	<!-- mods:place -->
	<xsl:template match="marc:datafield[@tag=260]/marc:subfield[@code='a'] | marc:datafield[@tag=260]/marc:subfield[@code='e']">
		<xsl:element name="mods:place">
			<xsl:element name="mods:placeTerm">
			<xsl:attribute name="type">text</xsl:attribute>
				<xsl:variable name="varNode">
				<xsl:call-template name="stripBrackets">
					<xsl:with-param name="paraData">
						<xsl:call-template name="chopPunctuation">
							<xsl:with-param name="chopString"><xsl:value-of select="."/></xsl:with-param>
						</xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="normalize-space($varNode)"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<!-- mods:publisher -->
	<xsl:template match="marc:datafield[@tag=260]/marc:subfield[@code='b'] | marc:datafield[@tag=260]/marc:subfield[@code='f']">
		<xsl:element name="mods:publisher">
			<xsl:variable name="varNode">
				<xsl:call-template name="stripBrackets">
					<xsl:with-param name="paraData">
						<xsl:call-template name="chopPunctuation">
							<xsl:with-param name="chopString"><xsl:value-of select="."/></xsl:with-param>
						</xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:variable>
			<xsl:value-of select="normalize-space($varNode)"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=260]/marc:subfield[@code='c']">
		<xsl:param name="paraDate1"/> 
		<xsl:param name="paraDate2"/>
		<xsl:param name="para008_06"/>
		<xsl:param name="paraLdr06"/>
		<!-- sanity check -->
		<!--xsl:element name="mods:dateOther">
			<xsl:value-of select="."/>
		</xsl:element-->
		<!-- Date for display -->
		<xsl:variable name="varYearCheck">
			<xsl:value-of select="translate(.,'0123456789[]()?. ','9999999999')"/>
		</xsl:variable>
		<xsl:variable name="varIsoDate">
			<xsl:call-template name="processIsoDate">
				<xsl:with-param name="paraNode">
					<xsl:value-of select="translate(.,'?[]().th','')"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$varYearCheck='9999'">
				<xsl:element name="mods:dateCreated">
					<xsl:attribute name="encoding">w3cdtf</xsl:attribute>	
					<xsl:attribute name="keyDate">yes</xsl:attribute>
					<xsl:choose>
						<xsl:when test="contains(.,'?')">
							<xsl:attribute name="qualifier">questionable</xsl:attribute>
						</xsl:when>
						<xsl:when test="contains(translate(.,'[]()','@@@@'),'@')">
							<xsl:attribute name="qualifier">inferred</xsl:attribute>
						</xsl:when>
					</xsl:choose>
					<xsl:value-of select="normalize-space(translate(.,'?[]().',''))"/>
				</xsl:element>
				<xsl:element name="mods:dateCreated">
					<xsl:value-of select="normalize-space(translate(.,'?[]().',''))"/>
				</xsl:element>
			</xsl:when>
			<!-- Becker default -->
			<xsl:when test="translate($varYearCheck,'N','n') = 'nodate'">
				<xsl:call-template name="processStartEnd">
					<xsl:with-param name="paraStart">1858</xsl:with-param>
					<xsl:with-param name="paraEnd">1898</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="translate(.,'u?[]().','-') = '19--'">
				<xsl:call-template name="processStartEnd">
					<xsl:with-param name="paraStart">1900</xsl:with-param>
					<xsl:with-param name="paraEnd">1999</xsl:with-param>
					<xsl:with-param name="paraQualifier">inferred</xsl:with-param>
				</xsl:call-template>
			</xsl:when>	
			<xsl:when test=". = '[18--?].'">
				<xsl:call-template name="processStartEnd">
					<xsl:with-param name="paraStart">1800</xsl:with-param>
					<xsl:with-param name="paraEnd">1899</xsl:with-param>
					<xsl:with-param name="paraQualifier">questionable</xsl:with-param>
				</xsl:call-template>
			</xsl:when>	
			<xsl:when test=". = '186-.'">
				<xsl:call-template name="processStartEnd">
					<xsl:with-param name="paraStart">1860</xsl:with-param>
					<xsl:with-param name="paraEnd">1869</xsl:with-param>
					<xsl:with-param name="paraQualifier">inferred</xsl:with-param>
				</xsl:call-template>
			</xsl:when>			
			<xsl:when test=". = '[188-?].'">
				<xsl:call-template name="processStartEnd">
					<xsl:with-param name="paraStart">1880</xsl:with-param>
					<xsl:with-param name="paraEnd">1889</xsl:with-param>
					<xsl:with-param name="paraQualifier">questionable</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test=". = '[188-].'">
				<xsl:call-template name="processStartEnd">
					<xsl:with-param name="paraStart">1880</xsl:with-param>
					<xsl:with-param name="paraEnd">1889</xsl:with-param>
					<xsl:with-param name="paraQualifier">inferred</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test=". = '[189-?].'">
				<xsl:call-template name="processStartEnd">
					<xsl:with-param name="paraStart">1890</xsl:with-param>
					<xsl:with-param name="paraEnd">1899</xsl:with-param>
					<xsl:with-param name="paraQualifier">questionable</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test=". = '[189-].'">
				<xsl:call-template name="processStartEnd">
					<xsl:with-param name="paraStart">1890</xsl:with-param>
					<xsl:with-param name="paraEnd">1899</xsl:with-param>
					<xsl:with-param name="paraQualifier">inferred</xsl:with-param>
				</xsl:call-template>
			</xsl:when>		
			<xsl:when test="(. = '[192-?].') or (. = '[1920s?].')">
				<xsl:call-template name="processStartEnd">
					<xsl:with-param name="paraStart">1920</xsl:with-param>
					<xsl:with-param name="paraEnd">1929</xsl:with-param>
					<xsl:with-param name="paraQualifier">questionable</xsl:with-param>
				</xsl:call-template>
			</xsl:when>	
			<xsl:when test=". = '[195-?].'">
				<xsl:call-template name="processStartEnd">
					<xsl:with-param name="paraStart">1950</xsl:with-param>
					<xsl:with-param name="paraEnd">1959</xsl:with-param>
					<xsl:with-param name="paraQualifier">questionable</xsl:with-param>
				</xsl:call-template>
			</xsl:when>	
			<xsl:when test=". = '[196-?].'">
				<xsl:call-template name="processStartEnd">
					<xsl:with-param name="paraStart">1960</xsl:with-param>
					<xsl:with-param name="paraEnd">1969</xsl:with-param>
					<xsl:with-param name="paraQualifier">questionable</xsl:with-param>
				</xsl:call-template>
			</xsl:when>	
			<xsl:when test=". = '[197-?].'">
				<xsl:call-template name="processStartEnd">
					<xsl:with-param name="paraStart">1970</xsl:with-param>
					<xsl:with-param name="paraEnd">1979</xsl:with-param>
					<xsl:with-param name="paraQualifier">questionable</xsl:with-param>
				</xsl:call-template>
			</xsl:when>	
			<xsl:when test=". = '197-.'">
				<xsl:call-template name="processStartEnd">
					<xsl:with-param name="paraStart">1970</xsl:with-param>
					<xsl:with-param name="paraEnd">1979</xsl:with-param>
					<xsl:with-param name="paraQualifier">inferred</xsl:with-param>
				</xsl:call-template>
			</xsl:when>				
			<xsl:when test=". = '[198-?].'">
				<xsl:call-template name="processStartEnd">
					<xsl:with-param name="paraStart">1980</xsl:with-param>
					<xsl:with-param name="paraEnd">1989</xsl:with-param>
					<xsl:with-param name="paraQualifier">questionable</xsl:with-param>
				</xsl:call-template>
			</xsl:when>				
			<xsl:when test=". = '1869-70.'">
				<xsl:call-template name="processStartEnd">
					<xsl:with-param name="paraStart">1869</xsl:with-param>
					<xsl:with-param name="paraEnd">1870</xsl:with-param>
				</xsl:call-template>
			</xsl:when>			
			<xsl:when test="(translate($varIsoDate,'0123456789','9999999999') = '9999-99-99') or (translate($varIsoDate,'0123456789','9999999999') = '9999-99')">
				<xsl:element name="mods:dateCreated">
					<xsl:attribute name="encoding">w3cdtf</xsl:attribute>	
					<xsl:attribute name="keyDate">yes</xsl:attribute>
					<xsl:choose>
						<xsl:when test="contains(.,'?')">
							<xsl:attribute name="qualifier">questionable</xsl:attribute>
						</xsl:when>
						<xsl:when test="contains(.,'[')">
							<xsl:attribute name="qualifier">inferred</xsl:attribute>
						</xsl:when>						
					</xsl:choose>
					<xsl:value-of select="$varIsoDate"/>
				</xsl:element>
				<xsl:element name="mods:dateCreated">
					<xsl:choose>
						<xsl:when test="contains(.,'?')">
							<xsl:attribute name="qualifier">questionable</xsl:attribute>
						</xsl:when>
						<xsl:when test="contains(.,'[')">
							<xsl:attribute name="qualifier">inferred</xsl:attribute>
						</xsl:when>
					</xsl:choose>
					<xsl:value-of select="translate(.,'?[]().','')"/>
				</xsl:element>
			</xsl:when>
			<!-- Between #### and #### -->
			<xsl:when test="contains(.,'ween') and contains(.,'?')">
				<xsl:call-template name="processStartEnd">
					<xsl:with-param name="paraStart">
						<xsl:value-of select="translate(substring-before(substring-after(.,'ween '), ' '),'?[]().','')"/>
					</xsl:with-param>
					<xsl:with-param name="paraEnd">
						<xsl:value-of select="translate(substring-after(.,'and '),'?[]().','')"/>
					</xsl:with-param>
					<xsl:with-param name="paraQualifier">questionable</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains(.,'tween') and contains(.,']')">
				<xsl:call-template name="processStartEnd">
					<xsl:with-param name="paraStart">
						<xsl:value-of select="translate(substring-before(substring-after(.,'ween '), ' '),'?[]().','')"/>
					</xsl:with-param>
					<xsl:with-param name="paraEnd">
						<xsl:value-of select="translate(substring-after(.,'and '),'?[]().','')"/>
					</xsl:with-param>
					<xsl:with-param name="paraQualifier">inferred</xsl:with-param>
				</xsl:call-template>
			</xsl:when>		
			<xsl:when test="contains(.,'tween')">
				<xsl:call-template name="processStartEnd">
					<xsl:with-param name="paraStart">
						<xsl:value-of select="translate(substring-before(substring-after(.,'ween '), ' '),'?[]().','')"/>
					</xsl:with-param>
					<xsl:with-param name="paraEnd">
						<xsl:value-of select="translate(substring-after(.,'and '),'?[]().','')"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>				
			<!-- After ##### -->
			<xsl:when test="contains(.,'fter') and contains(.,'?')">
				<xsl:call-template name="processStartEnd">
					<xsl:with-param name="paraStart">
						<xsl:value-of select="translate(substring-after(.,'fter '),'?[]().','')"/>
					</xsl:with-param>
					<xsl:with-param name="paraQualifier">questionable</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains(.,'fter') and contains(.,']')">
				<xsl:call-template name="processStartEnd">
					<xsl:with-param name="paraStart">
						<xsl:value-of select="translate(substring-after(.,'fter '),'?[]().','')"/>
					</xsl:with-param>
					<xsl:with-param name="paraQualifier">inferred</xsl:with-param>
				</xsl:call-template>
			</xsl:when>	
			<!-- Before ##### -->
			<xsl:when test="contains(.,'efore') and contains(.,'?')">
				<xsl:call-template name="processStartEnd">
					<xsl:with-param name="paraEnd">
						<xsl:value-of select="translate(substring-after(.,'efore '),'?[]().','')"/>
					</xsl:with-param>
					<xsl:with-param name="paraQualifier">questionable</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains(.,'efore') and contains(.,']')">
				<xsl:call-template name="processStartEnd">
					<xsl:with-param name="paraEnd">
						<xsl:value-of select="translate(substring-after(.,'efore '),'?[]().','')"/>
					</xsl:with-param>
					<xsl:with-param name="paraQualifier">inferred</xsl:with-param>
				</xsl:call-template>
			</xsl:when>	
			<xsl:when test=". = 'c. September-October 1863.'">
				<xsl:element name="mods:dateCreated">
					<xsl:value-of select="."/>
				</xsl:element>
				<xsl:element name="mods:dateCreated">
					<xsl:attribute name="encoding">w3cdtf</xsl:attribute>	
					<xsl:attribute name="keyDate">yes</xsl:attribute>
					<xsl:attribute name="point">start</xsl:attribute>
					<xsl:attribute name="qualifier">approximate</xsl:attribute>
					<xsl:text>1863-09</xsl:text>
				</xsl:element>
				<xsl:element name="mods:dateCreated">
					<xsl:attribute name="point">start</xsl:attribute>
					<xsl:attribute name="qualifier">approximate</xsl:attribute>					
					<xsl:text>1863-10</xsl:text>
				</xsl:element>
			</xsl:when>	
			<xsl:when test=". = 'November 8-9, 1861.'">
				<xsl:element name="mods:dateCreated">
					<xsl:value-of select="."/>
				</xsl:element>
				<xsl:element name="mods:dateCreated">
					<xsl:attribute name="encoding">w3cdtf</xsl:attribute>	
					<xsl:attribute name="keyDate">yes</xsl:attribute>
					<xsl:attribute name="point">start</xsl:attribute>
					<xsl:text>1861-11-08</xsl:text>
				</xsl:element>
				<xsl:element name="mods:dateCreated">
					<xsl:attribute name="point">start</xsl:attribute>			
					<xsl:text>1861-11-09</xsl:text>
				</xsl:element>
			</xsl:when>		
			<xsl:when test=". = '[ca. 1933].'">
				<xsl:element name="mods:dateCreated">
					<xsl:value-of select="."/>
				</xsl:element>
				<xsl:element name="mods:dateCreated">
					<xsl:attribute name="encoding">w3cdtf</xsl:attribute>	
					<xsl:attribute name="keyDate">yes</xsl:attribute>
					<xsl:attribute name="qualifier">approximate</xsl:attribute>	
					<xsl:text>1933</xsl:text>
				</xsl:element>
			</xsl:when>	
			<xsl:when test=".='Jan. 15 [1865].'">
				<xsl:element name="mods:dateCreated">
					<xsl:attribute name="encoding">w3cdtf</xsl:attribute>	
					<xsl:attribute name="keyDate">yes</xsl:attribute>
					<xsl:attribute name="qualifier">inferred</xsl:attribute>
					<xsl:value-of select="1865-01-15"/>
				</xsl:element>
				<xsl:element name="mods:dateCreated">
					<xsl:value-of select="normalize-space(translate(.,'?[]().',''))"/>
				</xsl:element>
			</xsl:when>
			<xsl:when test=". = '[July – August, 1861]'">
				<xsl:element name="mods:dateCreated">
					<xsl:text>July-August, 1861</xsl:text>
				</xsl:element>
				<xsl:element name="mods:dateCreated">
					<xsl:attribute name="encoding">w3cdtf</xsl:attribute>	
					<xsl:attribute name="keyDate">yes</xsl:attribute>
					<xsl:attribute name="point">start</xsl:attribute>
					<xsl:attribute name="qualifier">inferred</xsl:attribute>
					<xsl:text>1861-07</xsl:text>
				</xsl:element>
				<xsl:element name="mods:dateCreated">
					<xsl:attribute name="point">start</xsl:attribute>			
					<xsl:text>1861-08</xsl:text>
				</xsl:element>
			</xsl:when>	
			<xsl:when test=". = 'July ? 1864.'">
				<xsl:element name="mods:dateCreated">
					<xsl:text>July 1864.</xsl:text>
				</xsl:element>
				<xsl:element name="mods:dateCreated">
					<xsl:attribute name="encoding">w3cdtf</xsl:attribute>	
					<xsl:attribute name="keyDate">yes</xsl:attribute>
					<xsl:attribute name="qualifier">questionable</xsl:attribute>
					<xsl:text>1864-07</xsl:text>
				</xsl:element>
			</xsl:when>	
			<!-- Anything left is Becker -->
			<xsl:otherwise>
				<xsl:element name="mods:dateCreated">1858-1898</xsl:element>
				<xsl:element name="mods:dateCreated">
					<xsl:attribute name="encoding">w3cdtf</xsl:attribute>	
					<xsl:attribute name="keyDate">yes</xsl:attribute>
					<xsl:attribute name="point">start</xsl:attribute>
					<xsl:text>1858</xsl:text>
				</xsl:element>
				<xsl:element name="mods:dateCreated">
					<xsl:attribute name="point">end</xsl:attribute>
					<xsl:text>1898</xsl:text>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- mods:language -->
	<xsl:template name="processLanguage">
		<xsl:param name="paraLang"/>
		<xsl:element name="mods:language">
			<xsl:element name="mods:languageTerm">
				<xsl:attribute name="type">code</xsl:attribute>
				<xsl:attribute name="authority">iso639-2b</xsl:attribute>
				<xsl:choose>
					<xsl:when test="$paraLang = 'eng'">
						<xsl:text>eng</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>zxx</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
			<xsl:element name="mods:languageTerm">
				<xsl:attribute name="type">text</xsl:attribute>
				<xsl:attribute name="authority">iso639-2b</xsl:attribute>
				<xsl:choose>
					<xsl:when test="$paraLang = 'eng'">
						<xsl:text>English</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Not applicable</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>			
		</xsl:element>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=300]">
		<xsl:element name="mods:physicalDescription">
			<xsl:element name="mods:form">
				<xsl:attribute name="authority">marcform</xsl:attribute>
				<xsl:text>electronic</xsl:text>
				</xsl:element>
				<xsl:element name="mods:internetMediaType">
					<xsl:text>image/jp2</xsl:text>
				</xsl:element>
				<xsl:element name="mods:internetMediaType">
					<xsl:text>image/tiff</xsl:text>
				</xsl:element>
				<xsl:element name="mods:extent">
					<xsl:for-each select="marc:subfield">
						<xsl:value-of select="."/>
						<xsl:if test="position()!=last()">
							<xsl:text> </xsl:text>
						</xsl:if>
					</xsl:for-each>
				</xsl:element>
				<xsl:element name="mods:digitalOrigin">
					<xsl:text>reformatted digital</xsl:text>
				</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=520]">
	<xsl:element name="mods:abstract">
		<xsl:for-each select="marc:subfield">
			<xsl:value-of select="."/>
			<xsl:if test="position()!=last()">
				<xsl:text> </xsl:text>
			</xsl:if>
		</xsl:for-each>	
	</xsl:element>
	</xsl:template>
	<!-- mods:note -->
	<xsl:template match="marc:datafield[@tag=500]">
		<xsl:element name="mods:note">
			<xsl:for-each select="marc:subfield">
				<xsl:value-of select="."/>
				<xsl:if test="position()!=last()">
						<xsl:text> </xsl:text>
					</xsl:if>
			</xsl:for-each>				
		</xsl:element>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=530]">
		<xsl:element name="mods:note">
			<xsl:attribute name="type">
				<xsl:text>additional physical form</xsl:text>
			</xsl:attribute>
			<xsl:for-each select="marc:subfield">
				<xsl:value-of select="."/>
				<xsl:if test="position()!=last()">
					<xsl:text> </xsl:text>
				</xsl:if>
			</xsl:for-each>				
		</xsl:element>		
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=533]">
		<xsl:element name="mods:note">
			<xsl:attribute name="type">
				<xsl:text>reproduction</xsl:text>
			</xsl:attribute>
			<xsl:for-each select="marc:subfield">
				<xsl:if test="translate(@code,'abcdefmn','AAAAAAAA')='A'">
					<xsl:value-of select="."/>
					<xsl:if test="position()!=last()">
						<xsl:text> </xsl:text>
					</xsl:if>
				</xsl:if>
			</xsl:for-each>				
		</xsl:element>		
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=535]">
		<xsl:element name="mods:note">
			<xsl:attribute name="type">
				<xsl:text>original location</xsl:text>
			</xsl:attribute>
			<xsl:for-each select="marc:subfield">
				<xsl:choose>
					<xsl:when test=". = 'Becker Archive, Boston College.'">
						<xsl:text>Becker Archive, Boston College Fine Arts Dept.</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="."/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="position()!=last()">
					<xsl:text>. </xsl:text>
				</xsl:if>
			</xsl:for-each>				
		</xsl:element>		
	</xsl:template>	
	<!-- mods:subject -->
	<xsl:template match="marc:datafield[@tag=600] | marc:datafield[@tag=610]">
		<xsl:element name="mods:subject">
			<xsl:attribute name="authority">lcsh</xsl:attribute>
			<xsl:element name="mods:name">
				<xsl:attribute name="authority">naf</xsl:attribute>
				<xsl:choose>
					<xsl:when test="@tag='600'">
						<xsl:attribute name="type">personal</xsl:attribute>						
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="type">corporate</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="marc:subfield[@code='a']">
					<xsl:element name="mods:namePart">
						<xsl:if test="@tag='600'">
							<xsl:attribute name="type">given</xsl:attribute>
						</xsl:if>
						<xsl:call-template name="chopPunctuation">
							<xsl:with-param name="chopString"><xsl:value-of select="marc:subfield[@code='a']"/></xsl:with-param>
						</xsl:call-template>
					</xsl:element>
				</xsl:if>	
				<xsl:if test="marc:subfield[@code='q']">
					<xsl:element name="mods:namePart">
						<xsl:call-template name="chopPunctuation">
							<xsl:with-param name="chopString"><xsl:value-of select="marc:subfield[@code='q']"/></xsl:with-param>
						</xsl:call-template>
					</xsl:element>
				</xsl:if>					
				<xsl:if test="marc:subfield[@code='b']">
					<xsl:element name="mods:namePart">
						<xsl:call-template name="chopPunctuation">
							<xsl:with-param name="chopString"><xsl:value-of select="marc:subfield[@code='b']"/></xsl:with-param>
						</xsl:call-template>
					</xsl:element>
				</xsl:if>	
				<xsl:if test="marc:subfield[@code='c']">
					<xsl:element name="mods:namePart">
						<xsl:attribute name="type">termsOfAddress</xsl:attribute>
						<xsl:call-template name="chopPunctuation">
							<xsl:with-param name="chopString"><xsl:value-of select="marc:subfield[@code='c']"/></xsl:with-param>
						</xsl:call-template>
					</xsl:element>
				</xsl:if>	
				<xsl:if test="marc:subfield[@code='d']">
					<xsl:element name="mods:namePart">
						<xsl:call-template name="chopPunctuation">
							<xsl:with-param name="chopString"><xsl:value-of select="marc:subfield[@code='d']"/></xsl:with-param>
						</xsl:call-template>
					</xsl:element>
				</xsl:if>					
				<xsl:element name="mods:displayForm">
					<xsl:variable name="varDisplay">
						<xsl:call-template name="subfieldSelect">
							<xsl:with-param name="codes">abcd</xsl:with-param>
							<xsl:with-param name="delimeter"><xsl:text> </xsl:text></xsl:with-param>
						</xsl:call-template>
					</xsl:variable>
					<xsl:call-template name="chopPunctuation">
						<xsl:with-param name="chopString"><xsl:value-of select="$varDisplay"/></xsl:with-param>
					</xsl:call-template>
				</xsl:element>
			</xsl:element>	
			<xsl:for-each select="marc:subfield[@code='x']">
				<xsl:element name="mods:topic">
					<xsl:call-template name="chopPunctuation">
						<xsl:with-param name="chopString"><xsl:value-of select="."/></xsl:with-param>
					</xsl:call-template>
				</xsl:element>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='z']">
				<xsl:element name="mods:geographic">
					<xsl:call-template name="chopPunctuation">
						<xsl:with-param name="chopString"><xsl:value-of select="."/></xsl:with-param>
					</xsl:call-template>
				</xsl:element>
			</xsl:for-each>
			<xsl:for-each select="marc:subfield[@code='v']">
				<xsl:element name="mods:genre">
					<xsl:call-template name="chopPunctuation">
						<xsl:with-param name="chopString"><xsl:value-of select="."/></xsl:with-param>
					</xsl:call-template>
				</xsl:element>
			</xsl:for-each>				
		</xsl:element>
	</xsl:template>
	<!--xsl:template match="marc:datafield[@tag=610]">
		<xsl:element name="mods:subject">
			<xsl:if test="@ind2='0'">
				<xsl:attribute name="authority">lcsh</xsl:attribute>
			</xsl:if>
			<xsl:for-each select="marc:subfield">
				<xsl:element name="mods:topic">
					<xsl:call-template name="chopPunctuation">
						<xsl:with-param name="chopString"><xsl:value-of select="."/></xsl:with-param>
					</xsl:call-template>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template-->
	<xsl:template match="marc:datafield[@tag=611]">
		<xsl:element name="mods:subject">
			<xsl:if test="@ind2='0'">
				<xsl:attribute name="authority">lcsh</xsl:attribute>
			</xsl:if>
			<xsl:element name="mods:name">
				<xsl:attribute name="type">conference</xsl:attribute>
				<xsl:element name="mods:displayForm">
					<xsl:for-each select="marc:subfield">
						<xsl:value-of select="."/>
					</xsl:for-each>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>	
	<xsl:template match="marc:datafield[@tag=630]">
		<xsl:element name="mods:subject">
			<xsl:if test="@ind2='0'">
				<xsl:attribute name="authority">lcsh</xsl:attribute>
			</xsl:if>
			<xsl:element name="mods:titleInfo">
				<xsl:for-each select="marc:subfield">
					<xsl:choose>
						<xsl:when test="@code='a'">
							<xsl:apply-templates select="." mode="subject">
								<xsl:with-param name="paraNode">mods:title</xsl:with-param>
							</xsl:apply-templates>						
						</xsl:when>
						<xsl:when test="@code='p'">
							<xsl:apply-templates select="." mode="subject">
								<xsl:with-param name="paraNode">mods:partName</xsl:with-param>
							</xsl:apply-templates>						
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
	</xsl:template>		
	<xsl:template match="marc:datafield[@tag=650]">
		<xsl:element name="mods:subject">
			<xsl:if test="@ind2='0'">
				<xsl:attribute name="authority">lcsh</xsl:attribute>
			</xsl:if>
			<xsl:for-each select="marc:subfield">
				<xsl:choose>
					<xsl:when test="@code='v'">
						<xsl:apply-templates select="." mode="subject">
							<xsl:with-param name="paraNode">mods:genre</xsl:with-param>
						</xsl:apply-templates>						
					</xsl:when>
					<xsl:when test="@code='y'">
						<xsl:apply-templates select="." mode="subject">
							<xsl:with-param name="paraNode">mods:temporal</xsl:with-param>
						</xsl:apply-templates>						
					</xsl:when>
					<xsl:when test="@code='y'">
						<xsl:apply-templates select="." mode="subject">
							<xsl:with-param name="paraNode">mods:geographic</xsl:with-param>
						</xsl:apply-templates>						
					</xsl:when>	
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="subject">
							<xsl:with-param name="paraNode">mods:topic</xsl:with-param>
						</xsl:apply-templates>						
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>			
		</xsl:element>
	</xsl:template>	
	
	<xsl:template match="marc:datafield[@tag=651]">
		<xsl:element name="mods:subject">
			<xsl:if test="@ind2='0'">
				<xsl:attribute name="authority">lcsh</xsl:attribute>
			</xsl:if>
			<xsl:for-each select="marc:subfield">
				<xsl:choose>
					<xsl:when test="@code='a'">
						<xsl:apply-templates select="." mode="subject">
							<xsl:with-param name="paraNode">mods:geographic</xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="@code='v'">
						<xsl:apply-templates select="." mode="subject">
							<xsl:with-param name="paraNode">mods:genre</xsl:with-param>
						</xsl:apply-templates>						
					</xsl:when>
					<xsl:when test="@code='x'">
						<xsl:apply-templates select="." mode="subject">
							<xsl:with-param name="paraNode">mods:topic</xsl:with-param>
						</xsl:apply-templates>						
					</xsl:when>
					<xsl:when test="@code='y'">
						<xsl:apply-templates select="." mode="subject">
							<xsl:with-param name="paraNode">mods:temporal</xsl:with-param>
						</xsl:apply-templates>						
					</xsl:when>
					<xsl:when test="@code='z'">
						<xsl:apply-templates select="." mode="subject">
							<xsl:with-param name="paraNode">mods:geographic</xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>					
				</xsl:choose>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>		
	<xsl:template match="marc:datafield[@tag=653]">
		<xsl:element name="mods:subject">
			<xsl:for-each select="marc:subfield">
				<xsl:element name="mods:topic">
					<xsl:call-template name="chopPunctuation">
						<xsl:with-param name="chopString"><xsl:value-of select="."/></xsl:with-param>
					</xsl:call-template>
				</xsl:element>
			</xsl:for-each>			
		</xsl:element>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=752]">
		<xsl:element name="mods:subject">
			<xsl:element name="mods:hierarchicalGeographic">
				<xsl:apply-templates select="marc:subfield[@code='2']" mode="authority"/>
				<xsl:for-each select="marc:subfield">
					<xsl:variable name="varNode">					
						<xsl:choose>
							<xsl:when test="@code='a'">mods:country</xsl:when>
							<xsl:when test="@code='b'">mods:state</xsl:when>
							<xsl:when test="@code='c'">mods:county</xsl:when>
							<xsl:when test="@code='d'">mods:city</xsl:when>
							<xsl:when test="@code='f'">mods:citySection</xsl:when>
							<xsl:when test="@code='g'">mods:area</xsl:when>					
						</xsl:choose>
					</xsl:variable>
					<xsl:if test="translate(@code,'abcdfg','AAAAAA')='A'">
						<xsl:element name="{$varNode}">
							<xsl:call-template name="chopPunctuation">
								<xsl:with-param name="chopString"><xsl:value-of select="."/></xsl:with-param>
							</xsl:call-template>
						</xsl:element>
					</xsl:if>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<!-- mods:classification not used -->
	<!-- mods:relateditem -->
	<xsl:template match="marc:datafield[@tag=035]">
		<xsl:if test="contains(.,'Becker')">
			<xsl:element name="mods:identifier">
				<xsl:attribute name="type">local-other</xsl:attribute>
				<xsl:value-of select="."/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<!-- mods:identifier Added by addUrlsToDigComm.xsl -->
	<!-- mods:location AddedaddUrlsToDigComm.xsl -->
	<!-- mods:accessCondition -->
	<xsl:template match="marc:datafield[@tag=540]">
		<xsl:element name="mods:accessCondition">
			<xsl:attribute name="type">use and reproduction</xsl:attribute>
			<xsl:value-of select="marc:subfield[@code='a']"/>
		</xsl:element>
	</xsl:template>
	<!-- mods:part not used -->
	<!-- mods:extension -->
	<xsl:template name="process940">
		<xsl:element name="mods:extension">
			<!-- Add the missing Boston Gas -->
			<xsl:if test="marc:datafield[@tag=535]/marc:subfield[@code='a'] = 'Boston Gas Company'">
				<xsl:element name="mods:localCollectionName">
					<xsl:text>BOSTON GAS COMPANY</xsl:text>
				</xsl:element>
			</xsl:if>
			<xsl:for-each select="marc:datafield[@tag=940]">
				<xsl:element name="localCollectionName">
					<xsl:value-of select="marc:subfield[@code='a']"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<!-- mods:recordInfo -->
	<xsl:template name="processRecordInfo">
		<xsl:element name="mods:recordInfo">
			<xsl:element name="mods:recordContentSource">
				<xsl:attribute name="authority">marcorg</xsl:attribute>
				<xsl:text>MChB</xsl:text>
			</xsl:element>
			<xsl:element name="mods:languageOfCataloging">
				<xsl:element name="mods:languageTerm">
					<xsl:attribute name="type">text</xsl:attribute>
					<xsl:attribute name="authority">iso639-2b</xsl:attribute>
					<xsl:text>English</xsl:text>
				</xsl:element>
				<xsl:element name="mods:languageTerm">
					<xsl:attribute name="type">code</xsl:attribute>
					<xsl:attribute name="authority">iso639-2b</xsl:attribute>
					<xsl:text>eng</xsl:text>
				</xsl:element>	
			</xsl:element>
			<xsl:element name="mods:recordCreationDate">
				<xsl:attribute name="encoding">marc</xsl:attribute>
				<xsl:value-of select="substring(marc:controlfield[@tag='008'],1,5)"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template name="processRelatedItem">
		<xsl:element name="mods:relatedItem">
			<xsl:attribute name="type">host</xsl:attribute>
				<xsl:choose>
					<xsl:when test="marc:datafield[@tag=535]/marc:subfield[@code='a'] = 'Boston Gas Company'">
						<xsl:element name="mods:titleInfo">
							<xsl:element name="mods:title">Boston Gas Company</xsl:element>
						</xsl:element>
						<xsl:element name="mods:originInfo">
							<xsl:element name="mods:dateCreated">1922-1986</xsl:element>
							<xsl:element name="mods:dateCreated">
								<xsl:attribute name="point">start</xsl:attribute>
								<xsl:text>1922</xsl:text>
							</xsl:element>
							<xsl:element name="mods:dateCreated">
								<xsl:attribute name="point">end</xsl:attribute>
								<xsl:text>1986</xsl:text>
							</xsl:element>
						</xsl:element>						
					</xsl:when>
					<xsl:when test="marc:datafield[@tag=940]/marc:subfield[@code='a'] = 'LITURGY AND LIFE'">
						<xsl:element name="mods:titleInfo">
							<xsl:element name="mods:title">Liturgy and life collection</xsl:element>
						</xsl:element>
						<xsl:element name="mods:originInfo">
							<xsl:element name="mods:dateCreated">1925-1975</xsl:element>
							<xsl:element name="mods:dateCreated">
								<xsl:attribute name="point">start</xsl:attribute>
								<xsl:text>1925</xsl:text>
							</xsl:element>
							<xsl:element name="mods:dateCreated">
								<xsl:attribute name="point">end</xsl:attribute>
								<xsl:text>1975</xsl:text>
							</xsl:element>
						</xsl:element>							
					</xsl:when>
					<xsl:when test="marc:datafield[@tag=940]/marc:subfield[@code='a'] = 'CONGRESSIONAL ARCHIVE'">
						<xsl:element name="mods:titleInfo">
							<xsl:element name="mods:title">Thomas P. O'Neill, Jr. Photographs</xsl:element>
						</xsl:element>
						<xsl:element name="mods:originInfo">
							<xsl:element name="mods:dateCreated">1936-1994</xsl:element>
							<xsl:element name="mods:dateCreated">
								<xsl:attribute name="point">start</xsl:attribute>
								<xsl:text>1936</xsl:text>
							</xsl:element>
							<xsl:element name="mods:dateCreated">
								<xsl:attribute name="point">end</xsl:attribute>
								<xsl:text>1994</xsl:text>
							</xsl:element>
						</xsl:element>							
					</xsl:when>
					<xsl:when test="marc:datafield[@tag=940]/marc:subfield[@code='a'] = 'BECKER COLLECTION'">
						<xsl:element name="mods:titleInfo">
							<xsl:element name="mods:nonSort">The </xsl:element>
							<xsl:element name="mods:title">Becker Collection</xsl:element>
						</xsl:element>
						<xsl:element name="mods:originInfo">
							<xsl:element name="mods:dateCreated">1858-1898</xsl:element>
							<xsl:element name="mods:dateCreated">
								<xsl:attribute name="point">start</xsl:attribute>
								<xsl:text>1858</xsl:text>
							</xsl:element>
							<xsl:element name="mods:dateCreated">
								<xsl:attribute name="point">end</xsl:attribute>
								<xsl:text>1898</xsl:text>
							</xsl:element>
						</xsl:element>							
					</xsl:when>
			</xsl:choose>
		</xsl:element>  
	</xsl:template>
	<xsl:template match="text()"/>
</xsl:stylesheet>