<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">



	<xsl:template match="/">
    <html>
		<head>
		<style type="text/css">
			body {
			background-image: inherit;
			}


			thead th {
			background-color: skyblue;
			}
			tbody td {
			background-color: antiquewhite;
			}
			th, td {
			text-align: center;
			}
		</style>
     </head>
	 <body>
        <xsl:apply-templates select="root" />
     </body>
</html>
</xsl:template>


  <xsl:template match="root">
    <table border="1">
      <thead>
        <xsl:call-template name="head1"/>
      </thead>
      <xsl:for-each select="種別">
        <tbody>
          <xsl:if test="count(客先) > 0">
            <xsl:call-template name="head2"/>
          </xsl:if>
          <xsl:for-each select="客先">
              <tr>
                <xsl:if test="position()=1">
                <td>
                  <xsl:attribute name="rowspan">
                    <xsl:value-of select="count(../客先)+2"/>
                  </xsl:attribute>
                  <xsl:value-of select="../@name"/>
                </td>
                </xsl:if>
                <td>
                <xsl:value-of select="@name"/>
                </td>
                <td class="m">
                  <xsl:value-of select="format-number( sum(月) ,'#,##0')"/>
                </td>
                <xsl:for-each select="月">
                <td class="m">
                  <xsl:value-of select="format-number( . ,'#,##0')"/>
                </td>
              </xsl:for-each>
                <td class="m">
                  <xsl:value-of select="format-number( sum(月) ,'#,##0')"/>
                </td>
                <td class="m">
                  <xsl:call-template name="emg"/>
                </td>
                <td>
                  <xsl:value-of select="@name"/>
                </td>
              </tr>
          </xsl:for-each>
          <xsl:if test="count(客先) > 0">
            <xsl:call-template name="total1"/>
            <xsl:call-template name="total2"/>
          </xsl:if>
        </tbody>
          </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template name="head1">
    <tr>
      
    <th>
      <xsl:value-of select="'グループ名'"/>
    </th>
      <th>
        <xsl:value-of select="'客先名'"/>
      </th>
      <th>
        <xsl:value-of select="''"/>
      </th>
      <th colspan="3">
        <xsl:value-of select="'2017年'"/>
      </th>
      <th colspan="9">
        <xsl:value-of select="'2018年'"/>
      </th>
      <th>
        <xsl:value-of select="''"/>
      </th>
      <th colspan="2">
        <xsl:value-of select="'客先名'"/>
      </th>
    </tr>
  </xsl:template>

  <xsl:template name="head2">
    <tr>
      <th colspan="2">
        <xsl:value-of select="''"/>
      </th>
      <th>
        <xsl:value-of select="'合計'"/>
      </th>
      <th>
        <xsl:value-of select="'10月'"/>
      </th>
      <th>
        <xsl:value-of select="'11月'"/>
      </th>
      <th>
        <xsl:value-of select="'12月'"/>
      </th>
      <th>
        <xsl:value-of select="'1月'"/>
      </th>
      <th>
        <xsl:value-of select="'2月'"/>
      </th>
      <th>
        <xsl:value-of select="'3月'"/>
      </th>
      <th>
        <xsl:value-of select="'4月'"/>
      </th>
      <th>
        <xsl:value-of select="'5月'"/>
      </th>
      <th>
        <xsl:value-of select="'6月'"/>
      </th>
      <th>
        <xsl:value-of select="'7月'"/>
      </th>
      <th>
        <xsl:value-of select="'8月'"/>
      </th>
      <th>
        <xsl:value-of select="'9月'"/>
      </th>
      <th>
        <xsl:value-of select="'合計'"/>
      </th>
      <th colspan="2">
        <xsl:value-of select="''"/>
      </th>
    </tr>
  </xsl:template>

  <xsl:template name="emg">
    <xsl:choose>
      <xsl:when test="@emg='EM'">
        <xsl:value-of select="''"/>
      </xsl:when>
      <xsl:when test="@emg = 'ACEL'">
        <xsl:value-of select="'A'"/>
      </xsl:when>
      <xsl:when test="@emg = 'PSL'">
        <xsl:value-of select="'P'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@emg"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="total1">
<tr>
  <td>
    <xsl:value-of select="'合計'"/>
  </td>
  <td>
    <xsl:value-of select="sum(合計/月)"/>
  </td>
  <xsl:for-each select="合計/月">
    <td class="m">
      <xsl:value-of select="format-number( . ,'#,##0')"/>
    </td>
  </xsl:for-each>
  <td>
    <xsl:value-of select="sum(合計/月)"/>
  </td>
  <td colspan="2">
    <xsl:value-of select="''"/>
  </td>
</tr>
  </xsl:template>
  <xsl:template name="total2">
    <tr>
      <td>
        <xsl:value-of select="'累計'"/>
      </td>
      <td>
        <xsl:value-of select="''"/>
      </td>
      <xsl:for-each select="累計/月">
        <td class="m">
          <xsl:value-of select="format-number( . ,'#,##0')"/>
        </td>
      </xsl:for-each>
      <td>
        <xsl:value-of select="''"/>
      </td>
      <td colspan="2">
        <xsl:value-of select="''"/>
      </td>
    </tr>
  </xsl:template>
</xsl:stylesheet>