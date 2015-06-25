<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:gml="http://www.opengis.net/gml" xmlns:srv="http://www.isotc211.org/2005/srv"
                xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gmd="http://www.isotc211.org/2005/gmd"
                exclude-result-prefixes="gmd">

  <!-- Fix language code -->
  <xsl:template match="gmd:MD_Metadata/gmd:language" priority="2">
    <xsl:choose>
      <xsl:when test="gmd:LanguageCode">
        <xsl:copy>
          <xsl:copy-of select="@*" />
          <xsl:apply-templates select="node()" />
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <gmd:language>
          <gmd:LanguageCode codeList="http://www.loc.gov/standards/iso639-2/" codeListValue="dut">Nederlands</gmd:LanguageCode>
        </gmd:language>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Add default topic category if no topic category in the metadata -->
  <xsl:template match="gmd:MD_DataIdentification">
    <xsl:copy>
      <xsl:copy-of select="@*" />

      <xsl:apply-templates select="gmd:citation" />
      <xsl:apply-templates select="gmd:abstract" />
      <xsl:apply-templates select="gmd:purpose" />
      <xsl:apply-templates select="gmd:credit" />
      <xsl:apply-templates select="gmd:status" />
      <xsl:apply-templates select="gmd:pointOfContact" />
      <xsl:apply-templates select="gmd:resourceMaintenance" />
      <xsl:apply-templates select="gmd:graphicOverview" />
      <xsl:apply-templates select="gmd:resourceFormat" />
      <xsl:apply-templates select="gmd:descriptiveKeywords" />
      <xsl:apply-templates select="gmd:resourceSpecificUsage" />
      <xsl:apply-templates select="gmd:resourceConstraints" />
      <xsl:apply-templates select="gmd:aggregationInfo" />
      <xsl:apply-templates select="gmd:spatialRepresentationType" />
      <xsl:apply-templates select="gmd:spatialResolution" />
      <xsl:apply-templates select="gmd:language" />
      <xsl:apply-templates select="gmd:characterSet" />

      <xsl:choose>
        <xsl:when test="count(gmd:topicCategory[gmd:MD_TopicCategoryCode != '']) = 0">
          <gmd:topicCategory>
            <gmd:MD_TopicCategoryCode>location</gmd:MD_TopicCategoryCode>
          </gmd:topicCategory>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="gmd:topicCategory" />
        </xsl:otherwise>
      </xsl:choose>

      <xsl:apply-templates select="gmd:environmentDescription" />
      <xsl:apply-templates select="gmd:extent" />
      <xsl:apply-templates select="gmd:supplementalInformation" />
    </xsl:copy>
  </xsl:template>

  <!-- ================================================================= -->

  <!-- Do a copy of every nodes and attributes -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Always remove geonet:* elements. -->
  <xsl:template match="geonet:*" priority="2"/>

</xsl:stylesheet>
