<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:pom="http://maven.apache.org/POM/4.0.0"
>
    <xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes" indent="yes"/>

    <!-- <xsl:variable name="version" select="/pom:project/pom:version/text()"/> -->
    <xsl:variable name="version" select="/pom:project/pom:url/text()"/>

    <!--
    <xsl:template match="/pom:project/pom:properties/*">
        <xsl:value-of select="$version"/>, PROP, <xsl:value-of select="name()"/>, <xsl:value-of select="string()"/>
    </xsl:template>
    -->

    <!-- Add columns names. -->
    <xsl:template match="/pom:project/pom:dependencyManagement/pom:dependencies">
          <xsl:text disable-output-escaping="yes"># release, type, artifact, version&#10;</xsl:text>
          <xsl:apply-templates select="@*|node()" />
    </xsl:template>

    <xsl:template match="/pom:project/pom:dependencyManagement/pom:dependencies/pom:dependency">
        <xsl:variable name="stripped1">
          <!-- Replace the suffix. -->
          <xsl:choose>
            <xsl:when test="contains( pom:version, '${version.suffix.org.jboss.javaee}' )">
              <xsl:value-of select="concat( substring-before( pom:version, '${version.suffix.org.jboss.javaee}' ), '.GA')"/>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="pom:version"/></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:if test="starts-with( $stripped1, '${' )">
          <xsl:variable name="stripped" select="normalize-space( translate( $stripped1, '${}', '   ') )"/>
          <!-- <xsl:variable name="stripped2" select="fn:replace( $stripped1, '${version.suffix.org.jboss.javaee}', '.GA' )"/> -->
          <!-- <xsl:variable name="stripped" select="fn:replace( 'aa', 'a', 'b' )"/> -->
          
          <xsl:value-of select="$version"/>, DEP, <xsl:value-of select="pom:groupId"/>:<xsl:value-of select="pom:artifactId"/>, <xsl:value-of select="/pom:project/pom:properties/*[name() = $stripped]/text()"/>
          <xsl:text disable-output-escaping="yes">&#10;</xsl:text>
        </xsl:if>
        <xsl:if test="not( starts-with( $stripped1, '${' ) )">
          <xsl:value-of select="$version"/>, DEP, <xsl:value-of select="pom:groupId"/>:<xsl:value-of select="pom:artifactId"/>, <xsl:value-of select="$stripped1"/>
          <xsl:text disable-output-escaping="yes">&#10;</xsl:text>
        </xsl:if>
    </xsl:template>

    <!-- Copy all other data -->
    <xsl:template match="@*|node()">
          <xsl:apply-templates select="@*|node()" />
    </xsl:template>

</xsl:stylesheet>
