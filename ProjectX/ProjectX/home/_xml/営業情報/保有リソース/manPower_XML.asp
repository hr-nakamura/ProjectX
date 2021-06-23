<%@ Language=JavaScript %>
<!--#include virtual = "/Project/home/_inc/cmn.inc"-->
<%
    var serverUrl = "http://kansa.in.eandm.co.jp";
    
    var xmlDoc = Server.CreateObject("Microsoft.XMLDom")
    xmlDoc.async = false



    var url = "/Project/営業情報/保有リソース/xml/manPower_XML.asp";
    var url = url + (Request.QueryString.Count == 0 ? "" : "?" + Request.QueryString);
    var url = serverUrl + url;

    xmlDoc.load(url);

    Response.CharSet = "SHIFT_JIS";
    //Response.AddHeader("Access-Control-Allow-Origin", "*");
    Response.ContentType = "text/xml"
    xmlDoc.save(Response)

%>
