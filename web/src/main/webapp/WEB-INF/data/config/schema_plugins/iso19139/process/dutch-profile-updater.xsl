<?xml version="1.0" encoding="UTF-8"?>

<!-- This process applies metadata updates in Zaanstad metadata
     for the ducth metadata profile compliancy.

   Calling the process using:

   http://localhost:8080/geonetwork/srv/eng/metadata.batch.processing?process=dutch-profile-updater
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:util="java:java.util.UUID"
                xmlns:gml="http://www.opengis.net/gml" xmlns:srv="http://www.isotc211.org/2005/srv"
                xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gmd="http://www.isotc211.org/2005/gmd"
                exclude-result-prefixes="gmd srv util">

  <xsl:param name="baseUrl" select="''"/>
  <xsl:param name="siteUrl" select="''"/>

  <xsl:variable name="uuid" select="//gmd:MD_Metadata/gmd:fileIdentifier/gco:CharacterString" />

  <!-- Fix language code -->
  <xsl:template match="gmd:MD_Metadata/gmd:language">
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

  <!-- Metadata standard name -->
  <xsl:template match="gmd:metadataStandardName">
    <xsl:copy>
      <gco:CharacterString>ISO 19115</gco:CharacterString>
    </xsl:copy>
  </xsl:template>

  <!-- Metadata standard version -->
  <xsl:template match="gmd:metadataStandardVersion">
    <xsl:copy>
      <gco:CharacterString>Nederlands metadata profiel op ISO 19115 voor geografie 1.3.1</gco:CharacterString>
    </xsl:copy>
  </xsl:template>


  <!-- Add resource identifier -->
  <xsl:template match="gmd:MD_DataIdentification/gmd:citation">
    <xsl:choose>
      <xsl:when test="count(gmd:CI_Citation/gmd:identifier[gmd:MD_Identifier/gmd:code/gco:CharacterString != '']) > 0">
        <xsl:copy>
          <xsl:copy-of select="@*" />
          <xsl:apply-templates select="node()" />
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:copy-of select="@*" />
          <gmd:CI_Citation>
            <xsl:apply-templates select="gmd:CI_Citation/gmd:title" />
            <xsl:apply-templates select="gmd:CI_Citation/gmd:alternateTitle" />
            <xsl:apply-templates select="gmd:CI_Citation/gmd:date" />
            <xsl:apply-templates select="gmd:CI_Citation/gmd:edition" />
            <xsl:apply-templates select="gmd:CI_Citation/gmd:editionDate" />

            <xsl:apply-templates select="gmd:CI_Citation/gmd:identifier[not(gmd:MD_Identifier)]" />

            <xsl:choose>
              <!-- There's a gmd:code, keep it -->
              <xsl:when test="string(gmd:identifier/gmd:MD_Identifier/gmd:code/gco:CharacterString)">
                <xsl:apply-templates select="gmd:identifier" />
              </xsl:when>
              <!-- No gmd:identifier -->
              <xsl:when test="not(gmd:CI_Citation/gmd:identifier)">
                <gmd:identifier>
                  <gmd:MD_Identifier>
                    <xsl:call-template name="AddCode"  />
                  </gmd:MD_Identifier>
                </gmd:identifier>
              </xsl:when>
              <!-- No gmd:identifier with gmd:MD_Identifier -->
              <xsl:when test="count(gmd:CI_Citation/gmd:identifier[gmd:MD_Identifier]) = 0">
                <gmd:identifier>
                  <gmd:MD_Identifier>
                    <xsl:call-template name="AddCode"  />
                  </gmd:MD_Identifier>
                </gmd:identifier>
              </xsl:when>

              <xsl:otherwise>
                <xsl:apply-templates select="gmd:CI_Citation/gmd:identifier[gmd:MD_Identifier][position()!=1]" />

                <xsl:for-each select="gmd:CI_Citation/gmd:identifier[gmd:MD_Identifier][1]">
                  <xsl:copy>
                    <xsl:copy-of select="@*" />
                    <xsl:for-each select="gmd:MD_Identifier">
                      <xsl:copy>
                        <xsl:copy-of select="@*" />
                        <xsl:apply-templates select="gmd:authority" />
                        <xsl:call-template name="AddCode"  />
                      </xsl:copy>
                    </xsl:for-each>
                  </xsl:copy>
                </xsl:for-each>
              </xsl:otherwise>
            </xsl:choose>

            <xsl:apply-templates select="gmd:CI_Citation/gmd:citedResponsibleParty" />
            <xsl:apply-templates select="gmd:CI_Citation/gmd:presentationForm" />
            <xsl:apply-templates select="gmd:CI_Citation/gmd:series" />
            <xsl:apply-templates select="gmd:CI_Citation/gmd:otherCitationDetails" />
            <xsl:apply-templates select="gmd:CI_Citation/gmd:collectiveTitle" />
            <xsl:apply-templates select="gmd:CI_Citation/gmd:ISBN" />
            <xsl:apply-templates select="gmd:CI_Citation/gmd:ISSN" />
          </gmd:CI_Citation>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="AddCode">
    <gmd:code>
      <gco:CharacterString><xsl:value-of select="util:toString(util:randomUUID())" /></gco:CharacterString>
    </gmd:code>
  </xsl:template>

  <!-- Set default contact mail, if not set -->
  <xsl:template match="gmd:contact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress">
    <xsl:choose>
      <xsl:when test="string(gco:CharacterString)">
        <xsl:copy>
          <xsl:copy-of select="@*" />
          <xsl:apply-templates select="node()" />
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <gmd:electronicMailAddress>
          <gco:CharacterString>geo-informatie@zaanstad.nl</gco:CharacterString>
        </gmd:electronicMailAddress>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Update the protocol for WMS -->
  <xsl:template match="gmd:protocol">
    <xsl:copy>
      <xsl:copy-of select="@*" />
      <xsl:choose>
        <xsl:when test="gco:CharacterString = 'OGC:WMS-1.1.1-http-get-map'">
          <gco:CharacterString>OGC:WMS</gco:CharacterString>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="node()" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <!-- Restrictions -->
  <xsl:template match="gmd:MD_LegalConstraints[starts-with(gmd:useLimitation/gco:CharacterString, 'Niet geschikt voor commercieel gebruik')]">
    <gmd:MD_LegalConstraints>
      <gmd:accessConstraints>
        <gmd:MD_RestrictionCode codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_RestrictionCode" codeListValue="otherRestrictions"/>
      </gmd:accessConstraints>
      <gmd:otherConstraints>
        <gco:CharacterString>http://creativecommons.org/publicdomain/mark/1.0/deed.nl</gco:CharacterString>
      </gmd:otherConstraints>
    </gmd:MD_LegalConstraints>
  </xsl:template>

  <!-- Update thumbnail urls -->
  <xsl:template match="gmd:MD_BrowseGraphic">
    <xsl:copy>
      <xsl:copy-of select="@*" />

      <xsl:choose>
        <xsl:when test="starts-with(gmd:fileName/gco:CharacterString, 'http')">
          <xsl:apply-templates select="gmd:fileName"/>
        </xsl:when>
        <xsl:otherwise>
          <gmd:fileName>
            <xsl:variable name="fname" select="gmd:fileName/gco:CharacterString" />
            <gco:CharacterString><xsl:value-of select="concat($siteUrl, '/resources.get?uuid=', $uuid ,'&amp;fname=',$fname)" /></gco:CharacterString>
          </gmd:fileName>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:apply-templates select="gmd:fileDescription"/>
      <xsl:apply-templates select="gmd:fileType"/>
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
