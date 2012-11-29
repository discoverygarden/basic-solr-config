<?xml version="1.0" encoding="UTF-8"?>
<!-- Template to make the iso8601 date -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:java="http://xml.apache.org/xalan/java"
  xmlns:xlink="http://www.w3.org/1999/xlink">
     
  <xsl:template name="get_ISO8601_date">
    <xsl:param name="date"/>
    <xsl:message><xsl:value-of select="$date"/></xsl:message>
      
    <xsl:variable name="pattern1">
      <xsl:variable name="frac">([.,][0-9]+)</xsl:variable>
      <xsl:variable name="sec_el">(\:[0-9]{2}<xsl:value-of select="$frac"/>?)</xsl:variable>
      <xsl:variable name="min_el">(\:[0-9]{2}(<xsl:value-of select="$frac"/>|<xsl:value-of select="$sec_el"/>?))</xsl:variable>
      <xsl:variable name="time_el">([0-9]{2}(<xsl:value-of select="$frac"/>|<xsl:value-of select="$min_el"/>))</xsl:variable>
      <xsl:variable name="time_offset">(Z|[+-]<xsl:value-of select="$time_el"/>)</xsl:variable>
      <xsl:variable name="time_pattern">(T<xsl:value-of select="$time_el"/><xsl:value-of select="$time_offset"/>?)</xsl:variable>

      <xsl:variable name="day_el">(-[0-9]{2})</xsl:variable>
      <xsl:variable name="month_el">(-[0-9]{2}<xsl:value-of select="$day_el"/>?)</xsl:variable>
      <xsl:variable name="date_el">([0-9]{4}<xsl:value-of select="$month_el"/>?)</xsl:variable>
      <xsl:variable name="date_opt_pattern">(<xsl:value-of select="$date_el"/><xsl:value-of select="$time_pattern"/>?)</xsl:variable>
      <!--xsl:text>(<xsl:value-of select="$time_pattern"/> | <xsl:value-of select="$date_opt_pattern"/>)</xsl:text-->
      <xsl:value-of select="$date_opt_pattern"/>
    </xsl:variable>

    <xsl:variable name="pattern2">([0-9]{1,2}/)([0-9]{1,2}/)([0-9]{4})</xsl:variable>
    <xsl:variable name="pattern3">([0-9]{1,2}/)?([0-9]{1,2}/)?([0-9]{4}) ([0-9]{1,2}:[0-9]{2})</xsl:variable>

    <!-- Have JODA or fail silently. -->

    <xsl:variable name="parsed">
      <xsl:choose>
        <xsl:when test="java:matches($date, $pattern2)">
          <xsl:variable name="dp" select="java:org.joda.time.format.DateTimeFormat.forPattern('M/d/y')"/>
          <xsl:value-of select="java:parseDateTime($dp, $date)"/>
        </xsl:when>
        <xsl:when test="java:matches($date, $pattern3)">
          <xsl:variable name="dp" select="java:org.joda.time.format.DateTimeFormat.forPattern('M/d/y H:m')"/>
          <xsl:value-of select="java:parseDateTime($dp, $date)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$date"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="asdf" select="string($parsed)"/>
    <xsl:message><xsl:value-of select="$asdf"/></xsl:message>
    <xsl:choose>
    <xsl:when test="java:matches($asdf, $pattern1)">
      <xsl:variable name="dp" select="java:org.joda.time.format.ISODateTimeFormat.dateTimeParser()"/>

      <!--<xsl:message><xsl:value-of select="java:parseDateTime($dp, $parsed)"/></xsl:message>-->
      <xsl:variable name="f" select="java:org.joda.time.format.ISODateTimeFormat.dateTime()"/>
      <xsl:variable name="df" select="java:withZoneUTC($f)"/>
      <xsl:value-of select="java:print($df, java:parseDateTime($dp, $asdf))"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message><xsl:value-of select="$parsed"/></xsl:message>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  </xsl:stylesheet>
  