<?xml version="1.0" encoding="Shift_JIS" ?>
<!--	<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">	-->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:user="mynamespace">

	<!--	xmlns:msxsl="urn:schemas-microsoft-com:xslt"	-->
	<!--      xmlns:user="http://mycompany.com/mynamespace">	-->

  <xsl:variable name="年度"><xsl:value-of select="/root/年度"/></xsl:variable>
  <xsl:variable name="開始年"><xsl:value-of select="/root/開始年"/></xsl:variable>
  <xsl:variable name="開始月"><xsl:value-of select="/root/開始月"/></xsl:variable>
  <xsl:variable name="実績月"><xsl:value-of select="//実績月"/></xsl:variable>

  <xsl:template match="/">
    <html>
			<head>
				<title>保有リソース</title>
        <link rel="stylesheet" type="text/css" href="account.css"/>
        <link rel="stylesheet" type="text/css" href="main.css"/>
      </head>

			<body background="bg.gif">
				<xsl:apply-templates select="root" />
      </body>
		</html>

	</xsl:template>

  <xsl:template match="root">
    <xsl:if test="count(本部/部/課) = 0">
      <table border="0" align="center">
        <tbody>
          <tr>
            <td>
              <xsl:value-of select="'データはありません'"/>
            </td>
          </tr>
        </tbody>
      </table>
    </xsl:if>

    <xsl:if test="count(本部/部/課) > 0">
      <table class="table" border="0" CELLPADDING="0" CELLSPACING="0">
        <thead>
          <tr bgcolor='#aac2ea'>
            <th rowspan='3'>
              <xsl:attribute name="nowrap" />
              <xsl:value-of select="'本部名'"/>
            </th>
            <th rowspan='3'>
              <xsl:attribute name="nowrap" />
              <xsl:value-of select="'部門名'"/>
            </th>
            <th colspan="8">
              <xsl:attribute name="nowrap" />
              <xsl:value-of select="$年度"/>
              <xsl:value-of select="'年度'"/>
              <xsl:value-of select="'(実績月：'"/>
              <xsl:value-of select="user:yymmAddStr($実績月,0)"/>
              <xsl:value-of select="')'"/>
            </th>
          </tr>
          <tr bgcolor='#aac2ea'>
            <th colspan="4">
              <xsl:attribute name="nowrap" />
              <xsl:value-of select="'費用（千円）'"/>
            </th>
            <th colspan="4">
              <xsl:attribute name="nowrap" />
              <xsl:value-of select="'工数（人月）'"/>
            </th>
          </tr>
          <tr bgcolor='#aac2ea'>
            <th width="10%">
              <xsl:attribute name="nowrap" />
              <xsl:value-of select="'計　画'"/>
            </th>
            <th width="10%">
              <xsl:attribute name="nowrap" />
              <xsl:value-of select="'実績・予測'"/>
            </th>
            <th width="10%">
              <xsl:attribute name="nowrap" />
              <xsl:value-of select="'予実-計画'"/>
            </th>
            <th width="10%">
              <xsl:attribute name="nowrap" />
              <xsl:value-of select="'予実/計画'"/>
            </th>
            <th width="10%">
              <xsl:attribute name="nowrap" />
              <xsl:value-of select="'計　画'"/>
            </th>
            <th width="10%">
              <xsl:attribute name="nowrap" />
              <xsl:value-of select="'実績・予測'"/>
            </th>
            <th width="10%">
              <xsl:attribute name="nowrap" />
              <xsl:value-of select="'予実-計画'"/>
            </th>
            <th width="10%">
              <xsl:attribute name="nowrap" />
              <xsl:value-of select="'予実/計画'"/>
            </th>
          </tr>
        </thead>
        <tbody>
          <xsl:call-template name="EMG">
          </xsl:call-template>
          <xsl:apply-templates select="本部">
          </xsl:apply-templates>
        </tbody>
      </table>


    </xsl:if>

  </xsl:template>




  <xsl:template name="EMG">
    <xsl:variable name="sumVal_計画_工数_EMG" select="sum(本部/部/課/データ[@name='計画']/工数/項目[@name='協力']/月)"/>
    <xsl:variable name="sumVal_結合_工数_EMG" select="sum(本部/部/課/データ[@name='結合']/工数/項目[@name='協力']/月)"/>
    <xsl:variable name="sumVal_計画_費用_EMG" select="sum(本部/部/課/データ[@name='計画']/費用/項目[@name='協力']/月)"/>
    <xsl:variable name="sumVal_結合_費用_EMG" select="sum(本部/部/課/データ[@name='結合']/費用/項目[@name='協力']/月)"/>
    <tr>
      <td class="groupType" align="left"  style="border-style:solid none solid solid;">
        <xsl:call-template name="部署名">
          <xsl:with-param name="name" select="'EMG'"/>
        </xsl:call-template>
      </td>
      <td class="groupType" align="left" style="border-style:solid solid solid none;">
        <xsl:value-of select="'　'"/>
      </td>
      <xsl:call-template name="計算_value_Out">
        <xsl:with-param name="結合_費用" select="$sumVal_結合_費用_EMG"/>
        <xsl:with-param name="計画_費用" select="$sumVal_計画_費用_EMG"/>
        <xsl:with-param name="結合_工数" select="$sumVal_結合_工数_EMG"/>
        <xsl:with-param name="計画_工数" select="$sumVal_計画_工数_EMG"/>
      </xsl:call-template>
    </tr>

  </xsl:template>




  <xsl:template match="本部">
    <xsl:variable name="本部名" select="@name"/>
    <xsl:variable name="sumVal_計画_工数_本部" select="sum(部/課/データ[@name='計画']/工数/項目[@name='協力']/月)"/>
    <xsl:variable name="sumVal_結合_工数_本部" select="sum(部/課/データ[@name='結合']/工数/項目[@name='協力']/月)"/>
    <xsl:variable name="sumVal_計画_費用_本部" select="sum(部/課/データ[@name='計画']/費用/項目[@name='協力']/月)"/>
    <xsl:variable name="sumVal_結合_費用_本部" select="sum(部/課/データ[@name='結合']/費用/項目[@name='協力']/月)"/>
    <xsl:variable name="Cnt_部" select="count(部)"/>
    <xsl:for-each select="部">
      <xsl:variable name="部名" select="@name"/>
      <xsl:variable name="sumVal_計画_工数_部" select="sum(課/データ[@name='計画']/工数/項目[@name='協力']/月)"/>
      <xsl:variable name="sumVal_結合_工数_部" select="sum(課/データ[@name='結合']/工数/項目[@name='協力']/月)"/>
      <xsl:variable name="sumVal_計画_費用_部" select="sum(課/データ[@name='計画']/費用/項目[@name='協力']/月)"/>
      <xsl:variable name="sumVal_結合_費用_部" select="sum(課/データ[@name='結合']/費用/項目[@name='協力']/月)"/>
      <xsl:if test="position()=1 and $Cnt_部&gt;1">
        <tr>
          <td class="groupType" align="left" rowspan="{$Cnt_部+1}" style="border-style:solid none solid solid;vertical-align:top;">
            <xsl:call-template name="部署名">
              <xsl:with-param name="name" select="$本部名"/>
            </xsl:call-template>
          </td>
          <td class="groupType" align="left" style="border-style:solid solid solid none;">
            <xsl:value-of select="'　'"/>
          </td>
          <xsl:call-template name="計算_value_Out">
            <xsl:with-param name="結合_費用" select="$sumVal_結合_費用_本部"/>
            <xsl:with-param name="計画_費用" select="$sumVal_計画_費用_本部"/>
            <xsl:with-param name="結合_工数" select="$sumVal_結合_工数_本部"/>
            <xsl:with-param name="計画_工数" select="$sumVal_計画_工数_本部"/>
          </xsl:call-template>
        </tr>
      </xsl:if>
      <tr>
        <xsl:choose>
          <xsl:when test="$Cnt_部=1">
            <td class="groupType" align="left" style="border-style:solid none solid solid;">
              <xsl:call-template name="部署名">
                <xsl:with-param name="name" select="$本部名"/>
              </xsl:call-template>
            </td>
            <td class="groupType" align="left" style="border-style:solid solid solid none;">
              <xsl:value-of select="'　'"/>
            </td>
          </xsl:when>
          <xsl:otherwise>
            <td class="groupType" align="left" style="border-style:solid solid solid solid;">
              <xsl:call-template name="部署名">
                <xsl:with-param name="name" select="$部名"/>
              </xsl:call-template>
            </td>

          </xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="計算_value_Out">
          <xsl:with-param name="結合_費用" select="$sumVal_結合_費用_部"/>
          <xsl:with-param name="計画_費用" select="$sumVal_計画_費用_部"/>
          <xsl:with-param name="結合_工数" select="$sumVal_結合_工数_部"/>
          <xsl:with-param name="計画_工数" select="$sumVal_計画_工数_部"/>
        </xsl:call-template>
      </tr>
    </xsl:for-each>
  </xsl:template>



  <xsl:template name="計算_value_Out">
    <xsl:param name="結合_費用"/>
    <xsl:param name="計画_費用"/>
    <xsl:param name="結合_工数"/>
    <xsl:param name="計画_工数"/>
    <td align="right">
    <xsl:call-template name="value_Out">
      <xsl:with-param name="unit" select="1000"/>
      <xsl:with-param name="form" select="'#,##0'"/>
      <xsl:with-param name="value" select="$計画_費用"/>
    </xsl:call-template>
  </td>
  <td align="right">
    <xsl:call-template name="value_Out">
      <xsl:with-param name="unit" select="1000"/>
      <xsl:with-param name="form" select="'#,##0'"/>
      <xsl:with-param name="value" select="$結合_費用"/>
    </xsl:call-template>
  </td>
  <td align="right">
    <xsl:call-template name="value_Out">
      <xsl:with-param name="unit" select="1000"/>
      <xsl:with-param name="form" select="'#,##0'"/>
      <xsl:with-param name="value" select="$結合_費用 - $計画_費用"/>
    </xsl:call-template>
  </td>
  <td align="right">
    <xsl:call-template name="率">
      <xsl:with-param name="分母" select="$計画_費用"/>
      <xsl:with-param name="分子" select="$結合_費用"/>
    </xsl:call-template>
  </td>
  <td align="right">
    <xsl:call-template name="value_Out">
      <xsl:with-param name="unit" select="100"/>
      <xsl:with-param name="form" select="'#,###.00'"/>
      <xsl:with-param name="value" select="$計画_工数"/>
    </xsl:call-template>
  </td>
  <td align="right">
    <xsl:call-template name="value_Out">
      <xsl:with-param name="unit" select="100"/>
      <xsl:with-param name="form" select="'#,###.00'"/>
      <xsl:with-param name="value" select="$結合_工数"/>
    </xsl:call-template>
  </td>
  <td align="right">
    <xsl:call-template name="value_Out">
      <xsl:with-param name="unit" select="100"/>
      <xsl:with-param name="form" select="'#,###.00'"/>
      <xsl:with-param name="value" select="$結合_工数 - $計画_工数"/>
    </xsl:call-template>
  </td>
  <td align="right">
    <xsl:call-template name="率">
      <xsl:with-param name="分母" select="$計画_工数"/>
      <xsl:with-param name="分子" select="$結合_工数"/>
    </xsl:call-template>
  </td>
  </xsl:template>
  <!-- ########################################################### -->

  <xsl:template name="value_Out">
    <xsl:param name="unit" />
    <xsl:param name="form" />
    <xsl:param name="value" />
    <xsl:choose>
      <xsl:when test="$value=0">
        <xsl:value-of select="'　'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="format-number($value div $unit,$form)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="率">
    <xsl:param name="分母" />
    <xsl:param name="分子" />
    <xsl:choose>
      <xsl:when test="$分母=0">
        <xsl:value-of select="''"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="format-number($分子 div $分母,'##.00%')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="部署名">
    <xsl:param name="name" />
      <xsl:choose>
        <xsl:when test="$name='本社'">
          <xsl:value-of select="'本社'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$name"/>
        </xsl:otherwise>
      </xsl:choose>
  </xsl:template>


  <!--		-->
  <xsl:include href="sub_cmn.xsl"/>
  <xsl:include href="sub_JScript.xsl"/>
  <!--<xsl:include href="本部_保有リソース_合計.xsl"/>-->


</xsl:stylesheet>
