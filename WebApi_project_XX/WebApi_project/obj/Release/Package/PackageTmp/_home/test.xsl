<?xml version="1.0" encoding="Shift_JIS"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

  <xsl:template match="/">
    <html>
      <head>
        <style type="text/css">


          .table {
          border-collapse:collapse;
          border: 0px solid gray;
          padding: 0px;
          margin: 0px;
          font-size: smaller;
          width: 100%;
          }

          .table thead {
          display: block;
          background-color: powderblue;
          }

          .table tbody {
          display: block;
          overflow: hidden;
          overflow-y: scroll;
          background-color: mintcream;
          }

          .table th {
          border-top: none;
          border-right: 1px solid gray;
          border-bottom: none;
          border-left: 1px solid gray;
          text-align: center;
          }

          .table td {
          border: 1px solid gray;
          }
          <!--   ******************* -->
          .pStat {
          min-width: 30px;
          text-align: center;
          }

          .pCode {
          min-width: 60px;
          text-align: center;
          }

          .pName {
          min-width: 400px;
          text-align: left;
          }

          .pUser {
          min-width: 400px;
          text-align: left;
          }

          .pSales {
          min-width: 80px;
          text-align: left;
          }

          .pUpdate {
          min-width: 50px;
          text-align: center;
          }

          .pRegist {
          min-width: 80px;
          text-align: left;
          }

          .pGroup {
          width: 100%;
          min-width: 200px;
          text-align: left;
          }
        </style>
      </head>
      <body>
        <xsl:apply-templates select="root" />
      </body>
    </html>
  </xsl:template>

  <xsl:template match="root">
    <table class="table">
      <tbody>
        <xsl:apply-templates select="data" />
    </tbody>
  </table>
  </xsl:template>

  <xsl:template match="data">
    <xsl:for-each select=".">
      <tr>
        <td>
        <xsl:value-of select="."/>
      </td>
        <td>
        <xsl:value-of select="@class"/>
      </td>
        <td>
        <xsl:value-of select="@id"/>
      </td>
      </tr>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
