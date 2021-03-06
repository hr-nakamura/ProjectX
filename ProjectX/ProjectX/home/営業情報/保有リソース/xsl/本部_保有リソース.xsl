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
  <xsl:variable name="月数"><xsl:value-of select="/root/月数"/></xsl:variable>

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
    <xsl:if test="count(本部/グループ) = 0">
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

    <xsl:if test="count(本部/グループ) > 0">
      <span>
        <b>保有リソース　（実績・予測）</b>
      </span>
      <xsl:call-template name="全_要員数">
        <xsl:with-param name="stat" select="'結合'"/>
        <xsl:with-param name="mode" select="'社員'"/>
        <xsl:with-param name="unit" select="100"/>
        <xsl:with-param name="form" select="'#,##0.00'"/>
      </xsl:call-template>
      <br/>
      <hr width="70%"/>

      <xsl:call-template name="要員数">
        <xsl:with-param name="stat" select="'結合'"/>
        <xsl:with-param name="mode" select="'社員'"/>
        <xsl:with-param name="unit" select="100"/>
        <xsl:with-param name="form" select="'#,##0'"/>
      </xsl:call-template>
      <hr width="50%"/>
      <xsl:call-template name="要員数">
        <xsl:with-param name="stat" select="'結合'"/>
        <xsl:with-param name="mode" select="'パート'"/>
        <xsl:with-param name="unit" select="100"/>
        <xsl:with-param name="form" select="'#,##0'"/>
      </xsl:call-template>
      <hr width="50%"/>

      <xsl:call-template name="要員数">
        <xsl:with-param name="stat" select="'結合'"/>
        <xsl:with-param name="mode" select="'協力'"/>
        <xsl:with-param name="unit" select="100"/>
        <xsl:with-param name="form" select="'#,##0.00'"/>
      </xsl:call-template>

      <hr width="50%"/>
      <xsl:call-template name="要員数">
        <xsl:with-param name="stat" select="'結合'"/>
        <xsl:with-param name="mode" select="'社内発注'"/>
        <xsl:with-param name="unit" select="100"/>
        <xsl:with-param name="form" select="'#,##0.00'"/>
      </xsl:call-template>

      <br/>
      <hr width="100%" size="4" color="royalblue"/>
      <br/>
      <span>
        <b>保有リソース　（計画）</b>
      </span>

      <xsl:call-template name="全_要員数">
        <xsl:with-param name="stat" select="'計画'"/>
        <xsl:with-param name="mode" select="'社員'"/>
        <xsl:with-param name="unit" select="100"/>
        <xsl:with-param name="form" select="'#,##0'"/>
      </xsl:call-template>
      <br/>
      <hr width="70%"/>

      <xsl:call-template name="要員数">
        <xsl:with-param name="stat" select="'計画'"/>
        <xsl:with-param name="mode" select="'社員'"/>
        <xsl:with-param name="unit" select="100"/>
        <xsl:with-param name="form" select="'#,##0'"/>
      </xsl:call-template>
      <hr width="50%"/>
      <xsl:call-template name="要員数">
        <xsl:with-param name="stat" select="'計画'"/>
        <xsl:with-param name="mode" select="'パート'"/>
        <xsl:with-param name="unit" select="100"/>
        <xsl:with-param name="form" select="'#,##0'"/>
      </xsl:call-template>
      <hr width="50%"/>

      <xsl:call-template name="要員数">
        <xsl:with-param name="stat" select="'計画'"/>
        <xsl:with-param name="mode" select="'協力'"/>
        <xsl:with-param name="unit" select="100"/>
        <xsl:with-param name="form" select="'#,##0'"/>
      </xsl:call-template>

      <hr width="50%"/>

      <xsl:call-template name="要員数">
        <xsl:with-param name="stat" select="'計画'"/>
        <xsl:with-param name="mode" select="'社内発注'"/>
        <xsl:with-param name="unit" select="100"/>
        <xsl:with-param name="form" select="'#,##0.00'"/>
      </xsl:call-template>
    </xsl:if>

  </xsl:template>


  <!-- ########################################################### -->

  <xsl:template name="要員数">
    <xsl:param name="stat"/>
    <xsl:param name="mode"/>
    <xsl:param name="unit"/>
    <xsl:param name="form"/>
    <table class="table" border="0" CELLPADDING="0" CELLSPACING="0">
      <caption>
        <big>
          <b>
            <xsl:value-of select="$mode"/>
          </b>
        </big>
      </caption>
      <thead>
        <tr bgcolor='#aac2ea'>
          <th rowspan="2" colspan="1">
            <xsl:attribute name="nowrap" />
            <xsl:value-of select="'項　目'"/>
          </th>
          <xsl:call-template name="year_Loop">
            <xsl:with-param name="year" select="$開始年" />
            <xsl:with-param name="begin" select="$開始月" />
            <xsl:with-param name="mCnt" select="$月数" />
          </xsl:call-template>
          <th rowspan="2" width="70">
            <xsl:attribute name="nowrap" />
            <xsl:value-of select="'合　計'"/>
          </th>
        </tr>
        <tr bgcolor='#aac2ea'>
          <xsl:call-template name="month_Loop">
            <xsl:with-param name="begin" select="$開始月" />
            <xsl:with-param name="mCnt" select="$月数" />
          </xsl:call-template>
        </tr>
      </thead>
      <tbody>
         <xsl:apply-templates select="本部">
             <xsl:with-param name="stat" select="$stat"/>
             <xsl:with-param name="mode" select="$mode"/>
             <xsl:with-param name="unit" select="$unit"/>
             <xsl:with-param name="form" select="$form"/>
            </xsl:apply-templates>
      </tbody>
      <tfoot>
        <xsl:call-template name="全社計">
          <xsl:with-param name="element" select="本部"/>
          <xsl:with-param name="stat" select="$stat"/>
          <xsl:with-param name="mode" select="$mode"/>
          <xsl:with-param name="unit" select="$unit"/>
          <xsl:with-param name="form" select="$form"/>
        </xsl:call-template>
      </tfoot>
    </table>
  </xsl:template>
  <!-- ########################################################### -->


  <xsl:template match="本部">
    <xsl:param name="stat"/>
    <xsl:param name="mode"/>
    <xsl:param name="unit"/>
    <xsl:param name="form"/>
    <tr>
      <td class="groupType" align="left">
        <xsl:attribute name="id">
          <xsl:value-of select="'Row'"/>
        </xsl:attribute>
        <xsl:attribute name="name">
          <xsl:value-of select="@name"/>
        </xsl:attribute>
        <xsl:call-template name="部署名">
          <xsl:with-param name="name" select="@name"/>
        </xsl:call-template>
      </td>
      <xsl:call-template name="valueOut_Loop">
        <xsl:with-param name="stat" select="$stat" />
        <xsl:with-param name="mode" select="$mode" />
        <xsl:with-param name="unit" select="$unit"/>
        <xsl:with-param name="form" select="$form" />
        <xsl:with-param name="mCnt" select="12" />
      </xsl:call-template>
    </tr>
  </xsl:template>

  <xsl:template name="全社計">
    <xsl:param name="element"/>
    <xsl:param name="stat"/>
    <xsl:param name="mode"/>
    <xsl:param name="unit"/>
    <xsl:param name="form"/>
    <tr>
      <td class="groupType">
        <xsl:value-of select="'計'"/>
      </td>
      <xsl:call-template name="valueOut_Loop_All">
        <xsl:with-param name="element" select="$element"/>
        <xsl:with-param name="stat" select="$stat"/>
        <xsl:with-param name="mode" select="$mode"/>
        <xsl:with-param name="unit" select="$unit"/>
        <xsl:with-param name="form" select="$form" />
        <xsl:with-param name="mCnt" select="12" />
      </xsl:call-template>
    </tr>
  </xsl:template>

  <xsl:template match="保有リソース">
  </xsl:template>

  <!--　本部データ行の表示　-->
  <xsl:template name="valueOut_Loop">
    <xsl:param name="stat" />
    <xsl:param name="mode" />
    <xsl:param name="mCnt" />
    <xsl:param name="begin" select="0" />
    <xsl:param name="max" select="$begin+$mCnt"/>
    <xsl:param name="m" select="$begin"/>
    <xsl:param name="unit" />
    <xsl:param name="form"/>
    <xsl:choose>
      <xsl:when test="$m &lt; $max">
        <xsl:variable name="sumVal" select="sum(グループ/保有リソース[@name=$stat]/要員数/項目[@name=$mode]/月[@m=$m])"/>
        <td class="groupTypeData">
          <!--<xsl:attribute name="style">
            <xsl:if test="$sumVal &lt; 0">
              <xsl:value-of select="'color:tomato'"/>
            </xsl:if>
          </xsl:attribute>-->
          <xsl:call-template name="value_Out">
            <xsl:with-param name="color" select="グループ/保有リソース[@name=$stat]/月情報/月[@m=$m]"/>
            <xsl:with-param name="form" select="$form"/>
            <xsl:with-param name="unit" select="$unit" />
            <xsl:with-param name="value" select="$sumVal"/>
          </xsl:call-template>
        </td>
        <xsl:call-template name="valueOut_Loop">
          <xsl:with-param name="stat" select="$stat" />
          <xsl:with-param name="mode" select="$mode" />
          <xsl:with-param name="max" select="$max" />
          <xsl:with-param name="m" select="$m + 1" />
          <xsl:with-param name="unit" select="$unit" />
          <xsl:with-param name="form" select="$form" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <td class="groupTypeData">
          <xsl:variable name="sumVal_All" select="sum(グループ/保有リソース[@name=$stat]/要員数/項目[@name=$mode]/月)"/>
          <xsl:call-template name="value_Out">
            <xsl:with-param name="color" select="'実績'"/>
            <xsl:with-param name="form" select="$form"/>
            <xsl:with-param name="unit" select="$unit" />
            <xsl:with-param name="value" select="$sumVal_All"/>
          </xsl:call-template>
        </td>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!--　全本部の月合計の表示　-->
  <xsl:template name="valueOut_Loop_All">
    <xsl:param name="element"/>
    <xsl:param name="stat" />
    <xsl:param name="mode" />
    <xsl:param name="mCnt" />
    <xsl:param name="begin" select="0" />
    <xsl:param name="max" select="$begin+$mCnt"/>
    <xsl:param name="m" select="$begin"/>
    <xsl:param name="unit" />
    <xsl:param name="form"/>
    <xsl:choose>
      <xsl:when test="$m &lt; $max">
        <xsl:variable name="sumVal" select="sum($element/グループ/保有リソース[@name=$stat]/要員数/項目[@name=$mode]/月[@m=$m])"/>
        <td class="groupTypeData">
          <!--<xsl:attribute name="style">
            <xsl:if test="$sumVal &lt; 0">
              <xsl:value-of select="'color:tomato'"/>
            </xsl:if>
          </xsl:attribute>-->
          <xsl:call-template name="value_Out_All">
            <xsl:with-param name="color" select="$element/グループ/保有リソース[@name=$stat]/月情報/月[@m=$m]"/>
            <xsl:with-param name="form" select="$form"/>
            <xsl:with-param name="unit" select="$unit" />
            <xsl:with-param name="value" select="$sumVal"/>
          </xsl:call-template>
        </td>
        <xsl:call-template name="valueOut_Loop_All">
          <xsl:with-param name="element" select="$element"/>
          <xsl:with-param name="stat" select="$stat" />
          <xsl:with-param name="mode" select="$mode" />
          <xsl:with-param name="max" select="$max" />
          <xsl:with-param name="m" select="$m + 1" />
          <xsl:with-param name="unit" select="$unit" />
          <xsl:with-param name="form" select="$form" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <td class="groupTypeData">
          <xsl:variable name="sumVal_All" select="sum($element/グループ/保有リソース[@name=$stat]/要員数/項目[@name=$mode]/月)"/>
          <xsl:call-template name="value_Out_All">
            <xsl:with-param name="color" select="'実績'"/>
            <xsl:with-param name="form" select="$form"/>
            <xsl:with-param name="unit" select="$unit" />
            <xsl:with-param name="value" select="$sumVal_All"/>
          </xsl:call-template>
        </td>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="value_Out">
    <xsl:param name="color" />
    <xsl:param name="unit" />
    <xsl:param name="form" />
    <xsl:param name="value" />
    <xsl:attribute name="class">
      <xsl:choose>
        <xsl:when test="$color='計画'">
          <!-- - 計画-->
          <xsl:value-of select="'target'"/>
        </xsl:when>
        <xsl:when test="$color='予測'">
          <!-- - 予測-->
          <xsl:value-of select="'yosoku'"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- - 実績-->
          <xsl:value-of select="'actual'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:choose>
      <xsl:when test="$value=0">
        <xsl:value-of select="'　'"/>
        <!--<xsl:value-of select="$color"/>-->
      </xsl:when>
      <xsl:when test="($value mod 1) = 0">
        <xsl:value-of select="format-number($value div $unit,$form)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="format-number($value div $unit,$form)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="value_Out_All">
    <xsl:param name="color" />
    <xsl:param name="unit" />
    <xsl:param name="form" />
    <xsl:param name="value" />
    <xsl:attribute name="class">
      <xsl:choose>
        <xsl:when test="$color='計画'">
          <!-- - 計画-->
          <xsl:value-of select="'target'"/>
        </xsl:when>
        <xsl:when test="$color='予測'">
          <!-- - 予測-->
          <xsl:value-of select="'yosoku'"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- - 実績-->
          <xsl:value-of select="'actual'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:choose>
      <xsl:when test="$value=0">
        <xsl:value-of select="'0'"/>
      </xsl:when>
      <xsl:when test="($value mod $unit) = 0">
        <xsl:value-of select="format-number($value div $unit,$form)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="format-number($value div $unit,$form)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="部署名">
    <xsl:param name="name" />
      <xsl:choose>
        <xsl:when test="$name='所属無'">
          <xsl:value-of select="'本社部門（他）'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$name"/>
        </xsl:otherwise>
      </xsl:choose>
  </xsl:template>


  <!--		-->
  <xsl:include href="sub_cmn.xsl"/>
  <xsl:include href="sub_JScript.xsl"/>
  <xsl:include href="本部_保有リソース_合計.xsl"/>


</xsl:stylesheet>
