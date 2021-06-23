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
  <xsl:variable name="���ь�"><xsl:value-of select="//���ь�"/></xsl:variable>

  <xsl:template match="/">
    <html>
			<head>
				<title>�ۗL���\�[�X</title>
        <link rel="stylesheet" type="text/css" href="account.css"/>
        <link rel="stylesheet" type="text/css" href="main.css"/>
      </head>

			<body background="bg.gif">
				<xsl:apply-templates select="root" />
      </body>
		</html>

	</xsl:template>

  <xsl:template match="root">
    <xsl:if test="count(�{��/��/��) = 0">
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

    <xsl:if test="count(�{��/��/��) > 0">
      <table class="table" border="0" CELLPADDING="0" CELLSPACING="0">
        <thead>
          <tr bgcolor='#aac2ea'>
            <th rowspan='3'>
              <xsl:attribute name="nowrap" />
              <xsl:value-of select="'�{����'"/>
            </th>
            <th rowspan='3'>
              <xsl:attribute name="nowrap" />
              <xsl:value-of select="'���喼'"/>
            </th>
            <th colspan="8">
              <xsl:attribute name="nowrap" />
              <xsl:value-of select="$�N�x"/>
              <xsl:value-of select="'�N�x'"/>
              <xsl:value-of select="'(���ь��F'"/>
              <xsl:value-of select="user:yymmAddStr($���ь�,0)"/>
              <xsl:value-of select="')'"/>
            </th>
          </tr>
          <tr bgcolor='#aac2ea'>
            <th colspan="4">
              <xsl:attribute name="nowrap" />
              <xsl:value-of select="'��p�i��~�j'"/>
            </th>
            <th colspan="4">
              <xsl:attribute name="nowrap" />
              <xsl:value-of select="'�H���i�l���j'"/>
            </th>
          </tr>
          <tr bgcolor='#aac2ea'>
            <th width="10%">
              <xsl:attribute name="nowrap" />
              <xsl:value-of select="'�v�@��'"/>
            </th>
            <th width="10%">
              <xsl:attribute name="nowrap" />
              <xsl:value-of select="'���сE�\��'"/>
            </th>
            <th width="10%">
              <xsl:attribute name="nowrap" />
              <xsl:value-of select="'�\��-�v��'"/>
            </th>
            <th width="10%">
              <xsl:attribute name="nowrap" />
              <xsl:value-of select="'�\��/�v��'"/>
            </th>
            <th width="10%">
              <xsl:attribute name="nowrap" />
              <xsl:value-of select="'�v�@��'"/>
            </th>
            <th width="10%">
              <xsl:attribute name="nowrap" />
              <xsl:value-of select="'���сE�\��'"/>
            </th>
            <th width="10%">
              <xsl:attribute name="nowrap" />
              <xsl:value-of select="'�\��-�v��'"/>
            </th>
            <th width="10%">
              <xsl:attribute name="nowrap" />
              <xsl:value-of select="'�\��/�v��'"/>
            </th>
          </tr>
        </thead>
        <tbody>
          <xsl:call-template name="EMG">
          </xsl:call-template>
          <xsl:apply-templates select="�{��">
          </xsl:apply-templates>
        </tbody>
      </table>


    </xsl:if>

  </xsl:template>




  <xsl:template name="EMG">
    <xsl:variable name="sumVal_�v��_�H��_EMG" select="sum(�{��/��/��/�f�[�^[@name='�v��']/�H��/����[@name='����']/��)"/>
    <xsl:variable name="sumVal_����_�H��_EMG" select="sum(�{��/��/��/�f�[�^[@name='����']/�H��/����[@name='����']/��)"/>
    <xsl:variable name="sumVal_�v��_��p_EMG" select="sum(�{��/��/��/�f�[�^[@name='�v��']/��p/����[@name='����']/��)"/>
    <xsl:variable name="sumVal_����_��p_EMG" select="sum(�{��/��/��/�f�[�^[@name='����']/��p/����[@name='����']/��)"/>
    <tr>
      <td class="groupType" align="left"  style="border-style:solid none solid solid;">
        <xsl:call-template name="������">
          <xsl:with-param name="name" select="'EMG'"/>
        </xsl:call-template>
      </td>
      <td class="groupType" align="left" style="border-style:solid solid solid none;">
        <xsl:value-of select="'�@'"/>
      </td>
      <xsl:call-template name="�v�Z_value_Out">
        <xsl:with-param name="����_��p" select="$sumVal_����_��p_EMG"/>
        <xsl:with-param name="�v��_��p" select="$sumVal_�v��_��p_EMG"/>
        <xsl:with-param name="����_�H��" select="$sumVal_����_�H��_EMG"/>
        <xsl:with-param name="�v��_�H��" select="$sumVal_�v��_�H��_EMG"/>
      </xsl:call-template>
    </tr>

  </xsl:template>




  <xsl:template match="�{��">
    <xsl:variable name="�{����" select="@name"/>
    <xsl:variable name="sumVal_�v��_�H��_�{��" select="sum(��/��/�f�[�^[@name='�v��']/�H��/����[@name='����']/��)"/>
    <xsl:variable name="sumVal_����_�H��_�{��" select="sum(��/��/�f�[�^[@name='����']/�H��/����[@name='����']/��)"/>
    <xsl:variable name="sumVal_�v��_��p_�{��" select="sum(��/��/�f�[�^[@name='�v��']/��p/����[@name='����']/��)"/>
    <xsl:variable name="sumVal_����_��p_�{��" select="sum(��/��/�f�[�^[@name='����']/��p/����[@name='����']/��)"/>
    <xsl:variable name="Cnt_��" select="count(��)"/>
    <xsl:for-each select="��">
      <xsl:variable name="����" select="@name"/>
      <xsl:variable name="sumVal_�v��_�H��_��" select="sum(��/�f�[�^[@name='�v��']/�H��/����[@name='����']/��)"/>
      <xsl:variable name="sumVal_����_�H��_��" select="sum(��/�f�[�^[@name='����']/�H��/����[@name='����']/��)"/>
      <xsl:variable name="sumVal_�v��_��p_��" select="sum(��/�f�[�^[@name='�v��']/��p/����[@name='����']/��)"/>
      <xsl:variable name="sumVal_����_��p_��" select="sum(��/�f�[�^[@name='����']/��p/����[@name='����']/��)"/>
      <xsl:if test="position()=1 and $Cnt_��&gt;1">
        <tr>
          <td class="groupType" align="left" rowspan="{$Cnt_��+1}" style="border-style:solid none solid solid;vertical-align:top;">
            <xsl:call-template name="������">
              <xsl:with-param name="name" select="$�{����"/>
            </xsl:call-template>
          </td>
          <td class="groupType" align="left" style="border-style:solid solid solid none;">
            <xsl:value-of select="'�@'"/>
          </td>
          <xsl:call-template name="�v�Z_value_Out">
            <xsl:with-param name="����_��p" select="$sumVal_����_��p_�{��"/>
            <xsl:with-param name="�v��_��p" select="$sumVal_�v��_��p_�{��"/>
            <xsl:with-param name="����_�H��" select="$sumVal_����_�H��_�{��"/>
            <xsl:with-param name="�v��_�H��" select="$sumVal_�v��_�H��_�{��"/>
          </xsl:call-template>
        </tr>
      </xsl:if>
      <tr>
        <xsl:choose>
          <xsl:when test="$Cnt_��=1">
            <td class="groupType" align="left" style="border-style:solid none solid solid;">
              <xsl:call-template name="������">
                <xsl:with-param name="name" select="$�{����"/>
              </xsl:call-template>
            </td>
            <td class="groupType" align="left" style="border-style:solid solid solid none;">
              <xsl:value-of select="'�@'"/>
            </td>
          </xsl:when>
          <xsl:otherwise>
            <td class="groupType" align="left" style="border-style:solid solid solid solid;">
              <xsl:call-template name="������">
                <xsl:with-param name="name" select="$����"/>
              </xsl:call-template>
            </td>

          </xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="�v�Z_value_Out">
          <xsl:with-param name="����_��p" select="$sumVal_����_��p_��"/>
          <xsl:with-param name="�v��_��p" select="$sumVal_�v��_��p_��"/>
          <xsl:with-param name="����_�H��" select="$sumVal_����_�H��_��"/>
          <xsl:with-param name="�v��_�H��" select="$sumVal_�v��_�H��_��"/>
        </xsl:call-template>
      </tr>
    </xsl:for-each>
  </xsl:template>



  <xsl:template name="�v�Z_value_Out">
    <xsl:param name="����_��p"/>
    <xsl:param name="�v��_��p"/>
    <xsl:param name="����_�H��"/>
    <xsl:param name="�v��_�H��"/>
    <td align="right">
    <xsl:call-template name="value_Out">
      <xsl:with-param name="unit" select="1000"/>
      <xsl:with-param name="form" select="'#,##0'"/>
      <xsl:with-param name="value" select="$�v��_��p"/>
    </xsl:call-template>
  </td>
  <td align="right">
    <xsl:call-template name="value_Out">
      <xsl:with-param name="unit" select="1000"/>
      <xsl:with-param name="form" select="'#,##0'"/>
      <xsl:with-param name="value" select="$����_��p"/>
    </xsl:call-template>
  </td>
  <td align="right">
    <xsl:call-template name="value_Out">
      <xsl:with-param name="unit" select="1000"/>
      <xsl:with-param name="form" select="'#,##0'"/>
      <xsl:with-param name="value" select="$����_��p - $�v��_��p"/>
    </xsl:call-template>
  </td>
  <td align="right">
    <xsl:call-template name="��">
      <xsl:with-param name="����" select="$�v��_��p"/>
      <xsl:with-param name="���q" select="$����_��p"/>
    </xsl:call-template>
  </td>
  <td align="right">
    <xsl:call-template name="value_Out">
      <xsl:with-param name="unit" select="100"/>
      <xsl:with-param name="form" select="'#,###.00'"/>
      <xsl:with-param name="value" select="$�v��_�H��"/>
    </xsl:call-template>
  </td>
  <td align="right">
    <xsl:call-template name="value_Out">
      <xsl:with-param name="unit" select="100"/>
      <xsl:with-param name="form" select="'#,###.00'"/>
      <xsl:with-param name="value" select="$����_�H��"/>
    </xsl:call-template>
  </td>
  <td align="right">
    <xsl:call-template name="value_Out">
      <xsl:with-param name="unit" select="100"/>
      <xsl:with-param name="form" select="'#,###.00'"/>
      <xsl:with-param name="value" select="$����_�H�� - $�v��_�H��"/>
    </xsl:call-template>
  </td>
  <td align="right">
    <xsl:call-template name="��">
      <xsl:with-param name="����" select="$�v��_�H��"/>
      <xsl:with-param name="���q" select="$����_�H��"/>
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
        <xsl:value-of select="'�@'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="format-number($value div $unit,$form)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="��">
    <xsl:param name="����" />
    <xsl:param name="���q" />
    <xsl:choose>
      <xsl:when test="$����=0">
        <xsl:value-of select="''"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="format-number($���q div $����,'##.00%')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="������">
    <xsl:param name="name" />
      <xsl:choose>
        <xsl:when test="$name='�{��'">
          <xsl:value-of select="'�{��'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$name"/>
        </xsl:otherwise>
      </xsl:choose>
  </xsl:template>


  <!--		-->
  <xsl:include href="sub_cmn.xsl"/>
  <xsl:include href="sub_JScript.xsl"/>
  <!--<xsl:include href="�{��_�ۗL���\�[�X_���v.xsl"/>-->


</xsl:stylesheet>
