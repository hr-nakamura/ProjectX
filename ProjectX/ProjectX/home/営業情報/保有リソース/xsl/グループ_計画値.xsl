<?xml version="1.0" encoding="Shift_JIS" ?>
<!--	<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">	-->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:user="mynamespace">

	<!--	xmlns:msxsl="urn:schemas-microsoft-com:xslt"	-->
	<!--      xmlns:user="http://mycompany.com/mynamespace">	-->

  <xsl:variable name="�N�x"><xsl:value-of select="/root/�N�x"/></xsl:variable>
  <xsl:variable name="�J�n�N"><xsl:value-of select="/root/�J�n�N"/></xsl:variable>
  <xsl:variable name="�J�n��"><xsl:value-of select="/root/�J�n��"/></xsl:variable>
  <xsl:variable name="����"><xsl:value-of select="/root/����"/></xsl:variable>
  <xsl:variable name="�{����">��P�J����</xsl:variable>

  <xsl:template match="/">
    <html>
			<head>
				<title>�O���[�v�@�v��l</title>
        <link rel="stylesheet" type="text/css" href="account.css"/>
        <link rel="stylesheet" type="text/css" href="main.css"/>
      </head>

			<body background="bg.gif">
				<xsl:apply-templates select="root" />
      </body>
		</html>

	</xsl:template>

	<xsl:template match="root">
    <xsl:if test="count(�{��/�O���[�v) = 0">
      <table border="0" align="center">
        <tbody>
          <tr>
            <td>
              <xsl:value-of select="'�f�[�^�͂���܂���'"/>
            </td>
          </tr>
        </tbody>
      </table>
    </xsl:if>

    <xsl:if test="count(�{��[@name=$�{����]/�O���[�v) > 0">
      <span>
        <b>�O���[�v�@�v��l</b>
      </span>

      <hr width="50%"/>
      <xsl:call-template name="�v��l">
        <xsl:with-param name="�{����" select="$�{����"/>
        <xsl:with-param name="stat" select="$�{����"/>
        <xsl:with-param name="mode" select="'�z��H��'"/>
        <xsl:with-param name="form" select="'#,##0.00'"/>
      </xsl:call-template>

      <hr width="50%"/>
      <xsl:call-template name="�v��l">
        <xsl:with-param name="�{����" select="$�{����"/>
        <xsl:with-param name="stat" select="$�{����"/>
        <xsl:with-param name="mode" select="'�_��H��'"/>
        <xsl:with-param name="form" select="'#,##0.00'"/>
      </xsl:call-template>

      <hr width="50%"/>
      <xsl:call-template name="�v��l">
        <xsl:with-param name="�{����" select="$�{����"/>
        <xsl:with-param name="stat" select="$�{����"/>
        <xsl:with-param name="mode" select="'���ύH��'"/>
        <xsl:with-param name="form" select="'#,##0.00'"/>
      </xsl:call-template>

    </xsl:if>

  </xsl:template>


  <!-- ########################################################### -->

  <xsl:template name="�v��l">
    <xsl:param name="�{����"/>
    <xsl:param name="stat"/>
    <xsl:param name="mode"/>
    <xsl:param name="form"/>
    <table class="table" border="0" CELLPADDING="0" CELLSPACING="0">
      <caption>
        <big>
          <b>
            <xsl:value-of select="$stat"/>
            <xsl:value-of select="'�E'"/>
            <xsl:value-of select="$mode"/>
          </b>
        </big>
      </caption>
      <thead>
        <tr bgcolor='#aac2ea'>
          <th rowspan="2" colspan="1" width="100">
            <xsl:attribute name="nowrap" />
            <xsl:value-of select="'���@��'"/>
          </th>
          <xsl:call-template name="year_Loop">
            <xsl:with-param name="year" select="$�J�n�N" />
            <xsl:with-param name="begin" select="$�J�n��" />
            <xsl:with-param name="mCnt" select="$����" />
          </xsl:call-template>
          <th rowspan="2" width="70">
            <xsl:attribute name="nowrap" />
            <xsl:value-of select="'���@�v'"/>
          </th>
        </tr>
        <tr bgcolor='#aac2ea'>
          <xsl:call-template name="month_Loop">
            <xsl:with-param name="begin" select="$�J�n��" />
            <xsl:with-param name="mCnt" select="$����" />
          </xsl:call-template>
        </tr>
      </thead>
      <tbody>
        <xsl:apply-templates select="�{��[@name=$�{����]/�O���[�v">
              <xsl:with-param name="stat" select="$stat"/>
              <xsl:with-param name="mode" select="$mode"/>
              <xsl:with-param name="form" select="$form"/>
            </xsl:apply-templates>
      </tbody>
      <tfoot>
        <xsl:call-template name="�{���v">
          <xsl:with-param name="element" select="�{��[@name=$�{����]"/>
          <xsl:with-param name="stat" select="$stat"/>
          <xsl:with-param name="mode" select="$mode"/>
          <xsl:with-param name="form" select="$form"/>
        </xsl:call-template>
      </tfoot>
    </table>
  </xsl:template>
  <!-- ########################################################### -->

  <xsl:template match="�O���[�v">
    <xsl:param name="stat"/>
    <xsl:param name="mode"/>
    <xsl:param name="form"/>
    <tr>
      <td class="groupType">
        <xsl:value-of select="@name"/>
      </td>
      <xsl:call-template name="valueOut_Loop">
        <xsl:with-param name="stat" select="$stat" />
        <xsl:with-param name="mode" select="$mode" />
        <xsl:with-param name="form" select="$form" />
        <xsl:with-param name="mCnt" select="12" />
      </xsl:call-template>
    </tr>
  </xsl:template>

  <xsl:template name="�{���v">
    <xsl:param name="element"/>
    <xsl:param name="stat"/>
    <xsl:param name="mode"/>
    <xsl:param name="form"/>
    <tr>
      <td class="groupType">
        <xsl:value-of select="'�v'"/>
      </td>
      <xsl:call-template name="valueOut_Loop_All">
        <xsl:with-param name="element" select="$element"/>
        <xsl:with-param name="stat" select="$stat"/>
        <xsl:with-param name="mode" select="$mode"/>
        <xsl:with-param name="form" select="$form" />
        <xsl:with-param name="mCnt" select="12" />
      </xsl:call-template>
    </tr>
  </xsl:template>

  <!--�@�f�[�^�s�̕\���@-->
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
        <!--<xsl:variable name="sumVal" select="sum(���H��/�f�[�^[@name=$stat]/����[@name=$mode]/��[@m=$m])"/>-->
        <xsl:variable name="sumVal" select="sum(�v��l/�f�[�^/����[@name=$mode]/��[@m=$m])"/>
        <td class="groupTypeData">
          <!--<xsl:attribute name="style">
            <xsl:if test="$sumVal &lt; 0">
              <xsl:value-of select="'color:tomato'"/>
            </xsl:if>
          </xsl:attribute>-->
          <xsl:call-template name="value_Out">
            <xsl:with-param name="form" select="$form"/>
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
          <!--<xsl:variable name="sumVal_All" select="sum(���H��/�f�[�^[@name=$stat]/����[@name=$mode]/��)"/>-->
          <xsl:variable name="sumVal_All" select="sum(�v��l/�f�[�^/����[@name=$mode]/��)"/>
          <xsl:call-template name="value_Out">
            <xsl:with-param name="form" select="$form"/>
            <xsl:with-param name="value" select="$sumVal_All"/>
          </xsl:call-template>
        </td>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!--�@�S�{���̌����v�̕\���@-->
  <xsl:template name="valueOut_Loop_All">
    <xsl:param name="element" />
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
        <!--<xsl:variable name="sumVal" select="sum($element/�O���[�v/���H��/�f�[�^[@name=$stat]/����[@name=$mode]/��[@m=$m])"/>-->
        <xsl:variable name="sumVal" select="sum($element/�O���[�v/�v��l/�f�[�^/����[@name=$mode]/��[@m=$m])"/>
        <td class="groupTypeData">
          <!--<xsl:attribute name="style">
            <xsl:if test="$sumVal &lt; 0">
              <xsl:value-of select="'color:tomato'"/>
            </xsl:if>
          </xsl:attribute>-->
          <xsl:call-template name="value_Out_All">
            <xsl:with-param name="form" select="$form"/>
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
          <!--<xsl:variable name="sumVal_All" select="sum($element/�O���[�v/���H��/�f�[�^[@name=$stat]/����[@name=$mode]/��)"/>-->
          <xsl:variable name="sumVal_All" select="sum($element/�O���[�v/�v��l/�f�[�^/����[@name=$mode]/��)"/>
          <xsl:call-template name="value_Out_All">
            <xsl:with-param name="form" select="$form"/>
            <xsl:with-param name="value" select="$sumVal_All"/>
          </xsl:call-template>
        </td>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="value_Out">
    <xsl:param name="color" />
    <xsl:param name="form" />
    <xsl:param name="value" />
    <xsl:attribute name="class">
      <xsl:choose>
        <xsl:when test="$color='�v��'">
          <!-- - �v��-->
          <xsl:value-of select="'target'"/>
        </xsl:when>
        <xsl:when test="$color='�\��'">
          <!-- - �\��-->
          <xsl:value-of select="'yosoku'"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- - ����-->
          <xsl:value-of select="'actual'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:choose>
      <xsl:when test="$value=0">
        <xsl:value-of select="'�@'"/>
      </xsl:when>
      <xsl:when test="($value mod 1) = 0">
        <xsl:value-of select="format-number($value,$form)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="format-number($value,$form)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="value_Out_All">
    <xsl:param name="color" />
    <xsl:param name="form" />
    <xsl:param name="value" />
    <xsl:attribute name="class">
      <xsl:choose>
        <xsl:when test="$color='�v��'">
          <!-- - �v��-->
          <xsl:value-of select="'target'"/>
        </xsl:when>
        <xsl:when test="$color='�\��'">
          <!-- - �\��-->
          <xsl:value-of select="'yosoku'"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- - ����-->
          <xsl:value-of select="'actual'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:choose>
      <xsl:when test="$value=0">
        <xsl:value-of select="'0'"/>
      </xsl:when>
      <xsl:when test="($value mod 1) = 0">
        <xsl:value-of select="format-number($value,$form)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="format-number($value,$form)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="value_OutX">
    <xsl:param name="form" />
    <xsl:param name="value" />
    <xsl:choose>
      <xsl:when test="$value=0">
        <xsl:value-of select="'�@'"/>
      </xsl:when>
      <xsl:when test="($value mod 1) = 0">
        <xsl:value-of select="format-number($value,'#,##0')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="format-number($value,'#,##0.00')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!--		-->
  <xsl:include href="sub_cmn.xsl"/>
  <xsl:include href="sub_JScript.xsl"/>

</xsl:stylesheet>
