<?xml version="1.0" encoding="Shift_JIS" ?>
<!--	<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">	-->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:user="mynamespace">

	<!--	xmlns:msxsl="urn:schemas-microsoft-com:xslt"	-->
	<!--      xmlns:user="http://mycompany.com/mynamespace">	-->


  <!-- ########################################################### -->

  <xsl:template name="�S_�v����">
    <xsl:param name="stat"/>
    <xsl:param name="mode"/>
    <xsl:param name="unit" />
    <xsl:param name="form"/>
    <table class="table" border="0" CELLPADDING="0" CELLSPACING="0">
      <caption>
        <big>
          <b>
            <xsl:value-of select="'���v'"/>
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
        <xsl:call-template name="�S_�{��">
          <xsl:with-param name="stat" select="$stat"/>
          <xsl:with-param name="mode" select="$mode"/>
          <xsl:with-param name="unit" select="100"/>
          <xsl:with-param name="form" select="$form"/>
        </xsl:call-template>
      </tbody>
      <tfoot>
        <xsl:call-template name="�S_�S�Ќv">
          <xsl:with-param name="element" select="�{��"/>
          <xsl:with-param name="stat" select="$stat"/>
          <xsl:with-param name="mode" select="$mode"/>
          <xsl:with-param name="unit" select="100"/>
          <xsl:with-param name="form" select="$form"/>
        </xsl:call-template>
      </tfoot>
    </table>
  </xsl:template>
  <!-- ########################################################### -->


  <xsl:template name="�S_�{��">
    <xsl:param name="stat"/>
    <xsl:param name="mode"/>
    <xsl:param name="unit" />
    <xsl:param name="form"/>
    <xsl:for-each select="�{��">
    <tr>
      <td class="groupType">
        <xsl:attribute name="id">
          <xsl:value-of select="'Row'"/>
        </xsl:attribute>
        <xsl:attribute name="name">
          <xsl:value-of select="@name"/>
        </xsl:attribute>
        <xsl:call-template name="������">
          <xsl:with-param name="name" select="@name"/>
        </xsl:call-template>
      </td>
      <xsl:call-template name="�S_valueOut_Loop">
        <xsl:with-param name="stat" select="$stat" />
        <xsl:with-param name="mode" select="$mode" />
        <xsl:with-param name="form" select="$form" />
        <xsl:with-param name="unit" select="100"/>
        <xsl:with-param name="mCnt" select="12" />
      </xsl:call-template>
    </tr>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="�S_�S�Ќv">
    <xsl:param name="element"/>
    <xsl:param name="stat"/>
    <xsl:param name="mode"/>
    <xsl:param name="unit" />
    <xsl:param name="form"/>
    <tr>
      <td class="groupType">
        <xsl:value-of select="'�v'"/>
      </td>
      <xsl:call-template name="�S_valueOut_Loop_All">
        <xsl:with-param name="element" select="$element"/>
        <xsl:with-param name="stat" select="$stat"/>
        <xsl:with-param name="mode" select="$mode"/>
        <xsl:with-param name="form" select="$form" />
        <xsl:with-param name="unit" select="100"/>
        <xsl:with-param name="mCnt" select="12" />
      </xsl:call-template>
    </tr>
  </xsl:template>

  <xsl:template match="�ۗL���\�[�X">
  </xsl:template>

  <!--�@�{���f�[�^�s�̕\���@-->
  <xsl:template name="�S_valueOut_Loop">
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
        <xsl:variable name="sumVal" select="sum(�O���[�v/�ۗL���\�[�X[@name=$stat]/�v����/����[@name='�Ј�' or @name='�p�[�g' or @name='����' or @name='�Г�����']/��[@m=$m])"/>
        <td class="groupTypeData">
          <!--<xsl:attribute name="style">
            <xsl:if test="$sumVal &lt; 0">
              <xsl:value-of select="'color:tomato'"/>
            </xsl:if>
          </xsl:attribute>-->
          <xsl:call-template name="value_Out">
            <xsl:with-param name="color" select="�O���[�v/�ۗL���\�[�X[@name=$stat]/�����/��[@m=$m]"/>
            <xsl:with-param name="form" select="$form"/>
            <xsl:with-param name="unit" select="$unit"/>
            <xsl:with-param name="value" select="$sumVal"/>
          </xsl:call-template>
        </td>
        <xsl:call-template name="�S_valueOut_Loop">
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
          <xsl:variable name="sumVal_All" select="sum(�O���[�v/�ۗL���\�[�X[@name=$stat]/�v����/����[@name='�Ј�' or @name='�p�[�g' or @name='����' or @name='�Г�����']/��)"/>
          <xsl:call-template name="value_Out">
            <xsl:with-param name="color" select="'����'"/>
            <xsl:with-param name="form" select="$form"/>
            <xsl:with-param name="unit" select="$unit"/>
            <xsl:with-param name="value" select="$sumVal_All"/>
          </xsl:call-template>
        </td>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!--�@�S�{���̌����v�̕\���@-->
  <xsl:template name="�S_valueOut_Loop_All">
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
        <xsl:variable name="sumVal" select="sum($element/�O���[�v/�ۗL���\�[�X[@name=$stat]/�v����/����[@name='�Ј�' or @name='�p�[�g' or @name='����' or @name='�Г�����']/��[@m=$m])"/>
        <td class="groupTypeData">
          <!--<xsl:attribute name="style">
            <xsl:if test="$sumVal &lt; 0">
              <xsl:value-of select="'color:tomato'"/>
            </xsl:if>
          </xsl:attribute>-->
          <xsl:call-template name="value_Out_All">
            <xsl:with-param name="color" select="$element/�O���[�v/�ۗL���\�[�X[@name=$stat]/�����/��[@m=$m]"/>
            <xsl:with-param name="form" select="$form"/>
            <xsl:with-param name="unit" select="$unit"/>
            <xsl:with-param name="value" select="$sumVal"/>
          </xsl:call-template>
        </td>
        <xsl:call-template name="�S_valueOut_Loop_All">
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
          <xsl:variable name="sumVal_All" select="sum($element/�O���[�v/�ۗL���\�[�X[@name=$stat]/�v����/����[@name='�Ј�' or @name='�p�[�g' or @name='����' or @name='�Г�����']/��)"/>
          <xsl:call-template name="value_Out_All">
            <xsl:with-param name="color" select="'����'"/>
            <xsl:with-param name="form" select="$form"/>
            <xsl:with-param name="unit" select="$unit"/>
            <xsl:with-param name="value" select="$sumVal_All"/>
          </xsl:call-template>
        </td>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--<xsl:template name="������">
    <xsl:param name="name" />
    <xsl:choose>
      <xsl:when test="$name='������'">
        <xsl:value-of select="'���̑��̕���'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$name"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>-->


</xsl:stylesheet>
