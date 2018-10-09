<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl"
	xmlns:arco-fn="http://w3id.org/arco/saxon-extension" xmlns:arco="https://w3id.org/arco/core/"
	xmlns:identifier="https://w3id.org/arco/identifier/" xmlns:arco-event="https://w3id.org/arco/culturalevent/"
	xmlns:cataloguerecord="https://w3id.org/arco/catalogue/"
	xmlns:cpdescription="https://w3id.org/arco/objective/" xmlns:cis="http://dati.beniculturali.it/cis/"
	xmlns:l0="https://w3id.org/italia/onto/l0/" xmlns:clvapit="https://w3id.org/italia/onto/CLV/"
	xmlns:tiapit="https://w3id.org/italia/onto/TI/" xmlns:roapit="https://w3id.org/italia/onto/RO/"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:dcterms="http://purl.org/dc/terms/creator"
	xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:frbr="http://purl.org/vocab/frbr/core#"
	xmlns:locgeoamm="https://w3id.org/arco/location/"
	xmlns:culturaldefinition="https://w3id.org/arco/subjective/"
	exclude-result-prefixes="xsl php">

	<xsl:output method="xml" encoding="utf-8" indent="yes" />
	<xsl:param name="item" />
	<!-- xsl:template match="schede/*/MT/MTA"> <xsl:for-each select="MTAP"> 
		<rdf:Description> <xsl:attribute name="rdf:about"> <xsl:value-of select="concat($NS, 
		'CulturalPropertyPart/', $itemURI, '-part-', position())" />" </xsl:attribute> 
		<rdf:type rdf:resource="https://w3id.org/arco/core/CulturalPropertyPart" 
		/> <clvapit:hasGeometry> <xsl:attribute name="rdf:resource"> <xsl:value-of 
		select="concat($NS, 'Geometry/', $itemURI, '-geometry-point-', position())" 
		/> </xsl:attribute> </clvapit:hasGeometry> <arco:isPartOf> <xsl:attribute 
		name="rdf:resource"> <xsl:value-of select="$objectOfDescription" /> </xsl:attribute> 
		</arco:isPartOf> </rdf:Description> </xsl:for-each> </xsl:template -->
	<xsl:output method="xml" encoding="utf-8" indent="yes" />

	<xsl:variable name="itemURI">
		<xsl:choose>
			<xsl:when test="schede/*/RV/RVE/RVEL">
				<xsl:value-of
					select="concat(schede/*/CD/NCT/NCTR, schede/*/CD/NCT/NCTN, schede/*/CD/NCT/NCTS, '-', arco-fn:urify(normalize-space(schede/*/RV/RVE/RVEL)))" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of
					select="concat(schede/*/CD/NCT/NCTR, schede/*/CD/NCT/NCTN, schede/*/CD/NCT/NCTS)" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="NS" select="'https://w3id.org/arco/resource/'" />

	<xsl:variable name="culturalPropertyComponent"
		select="concat($NS, arco-fn:local-name(arco-fn:getSpecificPropertyType($sheetType)), '/', $itemURI, '-component')" />

	<xsl:variable name="culturalProperty"
		select="concat($NS, arco-fn:local-name(arco-fn:getSpecificPropertyType($sheetType)), '/', $itemURI)" />

	<xsl:variable name="objectOfDescription">
		<xsl:choose>
			<xsl:when test="schede/*/OG/OGT/OGTP">
				<xsl:value-of select="$culturalPropertyComponent" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$culturalProperty" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="sheetVersion" select="schede/*/@version"></xsl:variable>
	<xsl:variable name="sheetType" select="name(schede/*)"></xsl:variable>
	<xsl:variable name="cp-name" select="''"></xsl:variable>

	<xsl:template match="/">
		<rdf:RDF>
			<xsl:for-each select="schede/*/CO/STC">
				<xsl:variable name="conservationStatus">
					<xsl:value-of
						select="concat($NS, 'ConservationStatus/', $itemURI, '-conservation-status-', position())" />
				</xsl:variable>
				<xsl:variable name="parentPosition">
					<xsl:value-of select="position()" />
				</xsl:variable>
				<xsl:for-each select="./STCP">
					<xsl:if test="not(.='intero bene')">
						<rdf:Description>
							<xsl:attribute name="rdf:about">
						 		<xsl:value-of
									select="concat($NS, 'CulturalPropertyPart/', $itemURI, '-part-', arco-fn:urify(normalize-space(.)))" />
						 	</xsl:attribute>
							<rdf:type rdf:resource="https://w3id.org/arco/core/CulturalPropertyPart" />
							<cpdescription:hasConservationStatus>
								<xsl:attribute name="rdf:resource">
									<xsl:value-of select="$conservationStatus" />
								</xsl:attribute>
							</cpdescription:hasConservationStatus>
							<rdfs:label>
								<xsl:value-of select="normalize-space(.)" />
							</rdfs:label>
							<l0:name>
								<xsl:value-of select="normalize-space(.)" />
							</l0:name>
						</rdf:Description>
					</xsl:if>
				</xsl:for-each>
			</xsl:for-each>

			<xsl:for-each select="schede/*/AU/AUT">
				<xsl:if test="./AUTW">
					<xsl:variable name="part">
						<xsl:value-of
							select="concat($NS, 'CulturalPropertyPart', $itemURI, '-part-', arco-fn:urify(normalize-space(./AUTW)))" />
					</xsl:variable>
					<xsl:variable name="partLabel">
						<xsl:value-of select="normalize-space(./AUTW)" />
					</xsl:variable>
					<rdf:Description>
						<xsl:attribute name="rdf:about">
							<xsl:value-of select="$part" />
						</xsl:attribute>
						<rdf:type rdf:resource="https://w3id.org/arco/core/CulturalPropertyPart" />
						<rdfs:label>
							<xsl:value-of select="$partLabel" />
						</rdfs:label>
						<l0:name>
							<xsl:value-of select="$partLabel" />
						</l0:name>

						<culturaldefinition:hasAuthorshipAttribution>
							<xsl:attribute name="rdf:resource">
								<xsl:value-of
								select="concat($NS, 'PreferredAuthorshipAttribution/', $itemURI, '-', position())" />
		                    </xsl:attribute>
						</culturaldefinition:hasAuthorshipAttribution>

						<arco:hasAuthor>
							<xsl:attribute name="rdf:resource">
		                    		<xsl:variable name="author">
				                            <xsl:choose>
				                                <xsl:when test="./AUTA">
				                                    <xsl:value-of
								select="concat($NS, 'Agent/', arco-fn:urify(normalize-space(./AUTN)), '-', arco-fn:urify(normalize-space(./AUTA)))" />
				                                </xsl:when>
				                                <xsl:when
								test="../AUF/AUFA and ../AUF/AUFN">
				                                    <xsl:value-of
								select="concat($NS, 'Agent/', arco-fn:urify(normalize-space(../AUF/AUFN)), '-', arco-fn:urify(normalize-space(../AUF/AUFA)))" />
				                                </xsl:when>
				                                <xsl:when
								test="../AUF/AUFA and ../AUF/AUFB">
				                                    <xsl:value-of
								select="concat($NS, 'Agent/', arco-fn:urify(normalize-space(../AUF/AUFB)), '-', arco-fn:urify(normalize-space(../AUF/AUFA)))" />
				                                </xsl:when>
				                                <xsl:when test="../AUF/AUFB">
				                                    <xsl:value-of
								select="concat($NS, 'Agent/', arco-fn:urify(normalize-space(../AUF/AUFB)))" />
				                                </xsl:when>
				                                <xsl:when test="../AUF/AUFN">
				                                    <xsl:value-of
								select="concat($NS, 'Agent/', arco-fn:urify(normalize-space(../AUF/AUFN)))" />
				                                </xsl:when>
				                                <xsl:otherwise>
				                                    <xsl:value-of
								select="concat($NS, 'Agent/', arco-fn:urify(normalize-space(./AUTN)))" />
				                                </xsl:otherwise>
				                            </xsl:choose>
			                            </xsl:variable>
			                            <xsl:choose>
			                                <xsl:when test="./AUTS">
			                                    <xsl:value-of
								select="concat($author, '-', arco-fn:urify(normalize-space(./AUTS)))" />
			                                </xsl:when>
			                                <xsl:when test="../AUF/AUFS">
			                                    <xsl:value-of
								select="concat($author, '-', arco-fn:urify(normalize-space(../AUF/AUFS)))" />
			                                </xsl:when>
			                                <xsl:otherwise>
			                                    <xsl:value-of
								select="$author" />
			                                </xsl:otherwise>
			                            </xsl:choose>
		                    	</xsl:attribute>
						</arco:hasAuthor>

					</rdf:Description>
				</xsl:if>
			</xsl:for-each>
		</rdf:RDF>
	</xsl:template>
</xsl:stylesheet>