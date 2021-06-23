<?xml version="1.0" encoding="Shift_JIS" ?>
<!--	<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">	-->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:user="mynamespace">

	<!--	xmlns:msxsl="urn:schemas-microsoft-com:xslt"	-->
	<!--      xmlns:user="http://mycompany.com/mynamespace">	-->


  <!-- ########################################################### -->

  <xsl:template name="全_要員数">
    <xsl:param name="stat"/>
    <xsl:param name="mode"/>
    <xsl:param name="unit" />
    <xsl:param name="form"/>
    <table class="table" border="0" CELLPADDING="0" CELLSPACING="0">
      <caption>
        <big>
          <b>
            <xsl:value-of select="'合計'"/>
          </b>
        </big>
      </caption>
      <thead>
        <tr bgcolor='#aac2ea'>
          <th rowspan="2" colspan="1" width="100">
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
        <xsl:call-template name="全_本部">
          <xsl:with-param name="stat" select="$stat"/>
          <xsl:with-param name="mode" select="$mode"/>
          <xsl:with-param name="unit" select="100"/>
          <xsl:with-param name="form" select="$form"/>
        </xsl:call-template>
      </tbody>
      <tfoot>
        <xsl:call-template name="全_全社計">
          <xsl:with-param name="element" select="本部"/>
          <xsl:with-param name="stat" select="$stat"/>
          <xsl:with-param name="mode" select="$mode"/>
          <xsl:with-param name="unit" select="100"/>
          <xsl:with-param name="form" select="$form"/>
        </xsl:call-template>
      </tfoot>
    </table>
  </xsl:template>
  <!-- ########################################################### -->


  <xsl:template name="全_本部">
    <xsl:param name="stat"/>
    <xsl:param name="mode"/>
    <xsl:param name="unit" />
    <xsl:param name="form"/>
    <xsl:for-each select="本部">
    <tr>
      <td class="groupType">
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
      <xsl:call-template name="全_valueOut_Loop">
        <xsl:with-param name="stat" select="$stat" />
        <xsl:with-param name="mode" select="$mode" />
        <xsl:with-param name="form" select="$form" />
        <xsl:with-param name="unit" select="100"/>
        <xsl:with-param name="mCnt" select="12" />
      </xsl:call-template>
    </tr>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="全_全社計">
    <xsl:param name="element"/>
    <xsl:param name="stat"/>
    <xsl:param name="mode"/>
    <xsl:param name="unit" />
    <xsl:param name="form"/>
    <tr>
      <td class="groupType">
        <xsl:value-of select="'計'"/>
      </td>
      <xsl:call-template name="全_valueOut_Loop_All">
        <xsl:with-param name="element" select="$element"/>
        <xsl:with-param name="stat" select="$stat"/>
        <xsl:with-param name="mode" select="$mode"/>
        <xsl:with-param name="form" select="$form" />
        <xsl:with-param name="unit" select="100"/>
        <xsl:with-param name="mCnt" select="12" />
      </xsl:call-template>
    </tr>
  </xsl:template>

  <xsl:template match="保有リソース">
  </xsl:template>

  <!--　本部データ行の表示　-->
  <xsl:template name="全_valueOut_Loop">
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
        <xsl:variable name="sumVal" select="sum(グループ/保有リソース[@name=$stat]/要員数/項目[@name='社員' or @name='パート' or @name='協力' or @name='社内発注']/月[@m=$m])"/>
        <td class="groupTypeData">
          <!--<xsl:attribute name="style">
            <xsl:if test="$sumVal &lt; 0">
              <xsl:value-of select="'color:tomato'"/>
            </xsl:if>
          </xsl:attribute>-->
          <xsl:call-template name="value_Out">
            <xsl:with-param name="color" select="グループ/保有リソース[@name=$stat]/月情報/月[@m=$m]"/>
            <xsl:with-param name="form" select="$form"/>
            <xsl:with-param name="unit" select="$unit"/>
            <xsl:with-param name="value" select="$sumVal"/>
          </xsl:call-template>
        </td>
        <xsl:call-template name="全_valueOut_Loop">
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
          <xsl:variable name="sumVal_All" select="sum(グループ/保有リソース[@name=$stat]/要員数/項目[@name='社員' or @name='パート' or @name='協力' or @name='社内発注']/月)"/>
          <xsl:call-template name="value_Out">
            <xsl:with-param name="color" select="'実績'"/>
            <xsl:with-param name="form" select="$form"/>
            <xsl:with-param name="unit" select="$unit"/>
            <xsl:with-param name="value" select="$sumVal_All"/>
          </xsl:call-template>
        </td>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!--　全本部の月合計の表示　-->
  <xsl:template name="全_valueOut_Loop_All">
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
        <xsl:variable name="sumVal" select="sum($element/グループ/保有リソース[@name=$stat]/要員数/項目[@name='社員' or @name='パート' or @name='協力' or @name='社内発注']/月[@m=$m])"/>
        <td class="groupTypeData">
          <!--<xsl:attribute name="style">
            <xsl:if test="$sumVal &lt; 0">
              <xsl:value-of select="'color:tomato'"/>
            </xsl:if>
          </xsl:attribute>-->
          <xsl:call-template name="value_Out_All">
            <xsl:with-param name="color" select="$element/グループ/保有リソース[@name=$stat]/月情報/月[@m=$m]"/>
            <xsl:with-param name="form" select="$form"/>
            <xsl:with-param name="unit" select="$unit"/>
            <xsl:with-param name="value" select="$sumVal"/>
          </xsl:call-template>
        </td>
        <xsl:call-template name="全_valueOut_Loop_All">
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
          <xsl:variable name="sumVal_All" select="sum($element/グループ/保有リソース[@name=$stat]/要員数/項目[@name='社員' or @name='パート' or @name='協力' or @name='社内発注']/月)"/>
          <xsl:call-template name="value_Out_All">
            <xsl:with-param name="color" select="'実績'"/>
            <xsl:with-param name="form" select="$form"/>
            <xsl:with-param name="unit" select="$unit"/>
            <xsl:with-param name="value" select="$sumVal_All"/>
          </xsl:call-template>
        </td>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--<xsl:template name="部署名">
    <xsl:param name="name" />
    <xsl:choose>
      <xsl:when test="$name='所属無'">
        <xsl:value-of select="'その他の部署'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$name"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>-->


</xsl:stylesheet>
