<%
    Response.End();
%>
<%
//	 Session("memberName1") = "º"
//	 Session("memberName2") = ""

//===========================================
	var TransferMode = ( Request.QueryString("TransferMode").Count == 0 ? 1 : Request.QueryString("TransferMode").Item )

	var fixStr = String(Request.QueryString("fix"))
	var fixLevel
	if(IsNumeric(fixStr)){
		fixLevel = (Math.floor(fixStr/10))*10
		if( fixLevel > 100 || fixLevel < 0 ) fixLevel = 70
		}
	else{
		fixLevel = 70
		}

//===========================================================================
var allGroup = true
var limitYear = 2003
var dispCnt = 12


	var year = String(Request.QueryString("year"))
	if( year == "undefined" ){
		var d = new Date()
		var yy = d.getFullYear()
		var mm = d.getMonth()+1

		year = yy + (mm >= 10 ? 1 : 0)			 // 10È~ÍNxð\¦
		}

	if( year < limitYear ){
		Response.End()
		}
%>
<%
//main(year,dispCnt,fixLevel)
//Response.End

%>
<html>
<head>
<META http-equiv="Content-Type" content="text/html; charset=SHIFT_JIS">
<META http-equiv="X-UA-Compatible" content="IE=5" />

	  <title>ãê</title>
   </head>
   <LINK rel="stylesheet" href="main.css" type="text/css">
	  <!--
<STYLE TYPE="text/css">
.table{
	font-size: x-small;
	background-color:'lightgrey';
	}
.groupType{
	nowrap;
	background-color:'linen';
	}
.userType{
	nowrap;
	background-color:'mintcream';
	}
.xTotal{
	nowrap;
	background-color:'blanchedalmond';
	}
.secTotal{
	nowrap;
	background-color:'aliceblue';
	}
.allTotal{
	nowrap;
	background-color:'linen';
	}
.target{
	text-align:right;
	nowrap;
	color:darkgreen;
	background-color:snow;
	}
.actual{
	text-align:right;
	nowrap;
	color:black;
	background-color:snow;
	}
.yosoku{
	text-align:right;
	nowrap;
	color:blue;
	background-color:gainsboro;
	}
.quarter{
	nowrap;
	background-color:'navajowhite';
	}
.lastTarget{
	text-align:right;
	nowrap;
	background-color:springgreen;
	}
.mounth{
	text-align:center;
	nowrap;
	background-color:lavender;
	}
</STYLE>
-->

<SCRIPT LANGUAGE="JavaScript">
var limitYear = "<%=limitYear%>"
var year	 = "<%=year%>"
var dispCnt  = "<%=dispCnt%>"
var fixLevel = "<%=fixLevel%>"
var TransferMode = "<%=TransferMode%>"
</SCRIPT>

<SCRIPT FOR="window" EVENT="onload" Language="JavaScript">
var yymm = (year-1)*100 + 10
mainTitle.innerHTML = String(year + "Nx@ãÚW@B¬óµ").big()
subTitle.innerHTML = "(" + strMonth(yymm) + "`" + strMonth(yymmAdd(yymm,dispCnt-1)) + ")"

if(year > limitYear ){
   prev.style.display=""
   }
next.style.display=""

var o = document.getElementsByName("level")
for( var i = 0; i < o.length; i++ ){
	if(o[i].value == fixLevel) o[i].checked = true
	}

var o = document.getElementsByName("Transfer")
for( var i = 0; i < o.length; i++ ){
	if(o[i].value == TransferMode) o[i].checked = true
	}


window.focus()
</SCRIPT>

<SCRIPT FOR="window" EVENT="onunload" LANGUAGE="JavaScript">
winClose()
</SCRIPT>


<SCRIPT FOR="Transfer" EVENT="onclick" LANGUAGE="JavaScript">
mainTitle.style.color = "tomato"
//this.parentElement.style.color = "tomato"

TransferMode = this.value
var para = ""
para += "?year="   + year
para += "&fix="    + fixLevel
para += "&TransferMode=" + TransferMode
window.location.replace(window.location.pathname + para )
</SCRIPT>

<SCRIPT FOR="level" EVENT="onclick" LANGUAGE="JavaScript">
mainTitle.style.color = "tomato"
//this.parentElement.style.color = "tomato"

fixLevel = this.value
var para = ""
para += "?year="   + year
para += "&fix="    + fixLevel
para += "&TransferMode=" + TransferMode
window.location.replace(window.location.pathname + para )
</SCRIPT>

<SCRIPT FOR="prev" EVENT="onclick" LANGUAGE="JavaScript">
mainTitle.style.color = "tomato"

year = parseInt(year) - 1
var para = ""
para += "?year="   + year
para += "&fix="    + fixLevel
para += "&TransferMode=" + TransferMode
window.location.replace(window.location.pathname + para )
</SCRIPT>
<SCRIPT FOR="next" EVENT="onclick" LANGUAGE="JavaScript">
mainTitle.style.color = "tomato"

year = parseInt(year) + 1
var para = ""
para += "?year="   + year
para += "&fix="    + fixLevel
para += "&TransferMode=" + TransferMode
window.location.replace(window.location.pathname + para )
</SCRIPT>

<SCRIPT FOR="prev" EVENT="onmouseover" LANGUAGE="JavaScript">
this.style.cursor = "hand"
</SCRIPT>
<SCRIPT FOR="prev" EVENT="onmouseleave" LANGUAGE="JavaScript">
this.style.cursor = ""
</SCRIPT>
<SCRIPT FOR="next" EVENT="onmouseover" LANGUAGE="JavaScript">
this.style.cursor = "hand"
</SCRIPT>
<SCRIPT FOR="next" EVENT="onmouseleave" LANGUAGE="JavaScript">
this.style.cursor = ""

</SCRIPT>


	  <body background="bg00.gif">
		 <table ALIGN="center">
			<caption><SPAN id="mainTitle">@</SPAN></caption>
		<TR>
			<td>
				<TABLE ALIGN="center" ID="Table2">
					<TR>
						<TD ALIGN="right">mx</TD>
						<TD ALIGN="left">
						<INPUT type="radio" id="level" name="level" value="70">`
						<INPUT type="radio" id="level" name="level" value="50">a
						<INPUT type="radio" id="level" name="level" value="30">b
						<INPUT type="radio" id="level" name="level" value="10">c
						</TD>
					</TR>
					<TR>
						<TD ALIGN="right">ãtÖ<BR><small>(væE\ª)</small></TD>
						<TD ALIGN="left">
						<INPUT type="radio" id="Transfer" name="Transfer" value="1"> è
						<INPUT type="radio" id="Transfer" name="Transfer" value="0">Èµ
						</TD>
					</TR>
				</TABLE>
			</td>
		</TR>
			<TR>
			   <td>
				  <TABLE ALIGN="center">
					 <TR>
						<TD ALIGN="LEFT"><IMG SRC="arrow_l1.gif" id="prev" border="0" TITLE="OÌú" STYLE="display=none"></TD>
						<TD ALIGN="CENTER"><SPAN ID="subTitle">@</SPAN></TD>
						<TD ALIGN="RIGHT"><IMG SRC="arrow_r1.gif" id="next" border="0" TITLE="Ìú" STYLE="display=none"></TD>
					 </TR>
				  </TABLE>
			   </td>
			</TR>
			<TR>
			   <td>
				<%main(year,dispCnt,fixLevel,TransferMode)%>
			   </td>
			</TR>
		 </table>
	  </body>
</html>
<%
function main(year,dispCnt,fixLevel,TransferMode)
	{
	var DB = Server.CreateObject("ADODB.Connection")
	DB.Open( Session("ODBC") )
	DB.DefaultDatabase = "kansaDB"

   	var d = new Date()
	var yy = d.getFullYear()
	var mm = d.getMonth()+1
	var dd = d.getDate()
	var yymm = yy * 100 + mm						// ¡Ìyymm

	var OKday = dayChk(d,adjustDayCnt)
	yymm = ( parseInt(dd) < parseInt(OKday) ? yymmAdd(yymm, -1) : yymmAdd(yymm, 0))			// mèúÌâ³
	
	var b_yymm = ((year-1)*100) + 10

   var actualCnt = yymmDiff( b_yymm, yymm )
   if(actualCnt >= 12) actualCnt = 12
//======  ======================

   var Tab = dispPlan( DB,b_yymm,dispCnt,actualCnt,fixLevel,TransferMode)

//======  =========================================================================
//	 p("<BR><HR size='4' width='50%' color='blue'>")
//======  =========================================================================
//	 Title = String(((Math.floor(b_yymm/100))+1) + "Nx@ã\ªÌÀ»¦").big()
//	 dispPlanX( Title,b_yymm,dispCnt,actualCnt)

	DB.Close()


//EMGLog.Json("ãÚW_å.json",Tab);
	
	}

function dispPlan( DB,b_yymm,dispCnt,actualCnt,fixLevel,TransferMode)
  {
//=== f[^æ¾ =======================================================
//		if( IsObject(Tab[S_name]) ){
//			for( var i = 0; i < dispCnt; i++ ){
//				Tab[S_name]["\À"][i] += ( IsObject(sTab[gCode]) ? (sTab[gCode].óæ[i] + sTab[gCode].x¥[i]) * 1000 : 0 )
//				}
//			}


   var Tab = getUser(DB,b_yymm,dispCnt)								// O[v¼ì¬


   getPastData(DB,Tab,yymmAdd(b_yymm,-12),1)						// ONxÌf[^

   getActualData(DB,Tab,b_yymm,dispCnt,actualCnt)					// ÀÑf[^æ¾

//dispXML("",Tab)

   getExpectData(DB,Tab,b_yymm,dispCnt,actualCnt,fixLevel)			// \ªf[^æ¾
   getTargetData(DB,Tab,b_yymm,dispCnt,0)							// ÚWf[^æ¾


	if( TransferMode == 1 ){

		var sTab = salesAdjustData(DB,b_yymm)

		for( var S_name in sTab["væ"] ){
//pr( "1[" + S_name + "][" + IsObject(Tab[S_name]) )
			if( IsObject(Tab[S_name]) ){
				for( var m = 0; m < dispCnt; m++ ){
					value = sTab["væ"][S_name].óæ[m] + sTab["væ"][S_name].x¥[m]
					Tab[S_name]["ÚW"][m] += value * 1000
					}
				}
			}
		var s_m = ( actualCnt >= 0 ? actualCnt : 0 )
		for( var S_name in sTab["\ª"] ){
//pr( "2[" + S_name + "][" + IsObject(Tab[S_name]) )
			if( IsObject(Tab[S_name]) ){
				for( var m = s_m; m < dispCnt; m++ ){
					value = sTab["\ª"][S_name].óæ[m] + sTab["\ª"][S_name].x¥[m]
					Tab[S_name]["\À"][m] += value * 1000
					}
				}
			}
		}

//=== f[^\¦ =======================================================
   tableBegin("width=100% align=center BORDER=0");

   tableBodyBegin("");

   tableRowBegin("");
   tableDataCellBegin("")
   dispUser(Tab,b_yymm,dispCnt,actualCnt)
   tableDataCellEnd()
   tableRowEnd();

   if( (dispCnt - actualCnt) > 0 ){
	  tableRowBegin("");
	  tableDataCell("ALIGN='LEFT'","\ªf[^ÌmxÍ" + fixLevel + "Èã".small())
	  tableRowEnd();
	  }

   tableBodyEnd();
   tableEnd()

	return(Tab)
   }

//================================================================

function dispUser(Tab,yymm,dispCnt,actualCnt)
   {
   var s_yymm = yymm;
   var e_yymm = yymmAdd(yymm,dispCnt - 1);
   var cur_yymm;
   var dspScale = 1000
   
// Ývf[^
   rTab = new Object
   rTab["ÚW"] = new Array(dispCnt)
   rTab["\À"] = new Array(dispCnt)
   rTab["ON"] = new Array(dispCnt)

// vf[^
   gTab = new Object
   gTab["ÚW"] = new Array(dispCnt)
   gTab["\À"] = new Array(dispCnt)
   gTab["ON"] = new Array(dispCnt)

// SÐf[^vZ=================================================
// vf[^ú»
   for( var m = 0; m < dispCnt; m++){
	  gTab["ÚW"][m] = 0
	  gTab["\À"][m] = 0
	  gTab["ON"][m] = 0
	  }
// vf[^vZ
   for( var S_name in Tab ){
	  for(var m = 0; m < dispCnt; m++){
		 gTab["ÚW"][m] += Tab[S_name]["ÚW"][m]
		 gTab["\À"][m] += Tab[S_name]["\À"][m]
		 gTab["ON"][m] += Tab[S_name]["ON"][m]
		 }
	  }
// Ývf[^vZ
   for(var kind in gTab){
	  var rValue = 0
	  for(var m in gTab[kind]){
		 rValue += gTab[kind][m]
		 rTab[kind][m] = rValue
		 }
	  }

// Wvf[^\¦
   tableBegin("width='100%' class='table' BORDER=1 CELLSPACING='0'");
//	 tableCaption("align='CENTER'","(" + strMonth(yymm) + "`" + strMonth(yymmAdd(yymm,dispCnt-1)) + ")" );

   tableHeadBegin("");
   tableRowBegin("valign='bottom' bordercolor='black' bgcolor='#aac2ea'");
   tableHeadCell("width='90'","O[v¼");
   tableHeadCell("width='80'","Ú");
   tableHeadCell("colspan='3'" + "width='" + (65*3) + "'",parseInt(s_yymm/100) + "N");
   tableHeadCell("colspan='9'" + "width='" + (65*9) + "'",parseInt(s_yymm/100)+1 + "N");

   tableRowEnd();
   tableHeadEnd();

// SÐf[^\¦
   tableBodyBegin("");
   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='xTotal' rowspan='9'", "dlf".big().bold());

   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "" );
   for(i = 0; i < dispCnt; i++){
	  tableDataCell("class='mounth' width='65'",yymmAdd(s_yymm,i)%100 + "");
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "Ú@W" );
   for( var i = 0; i < dispCnt; i++){
	  className = "target"
	  value = gTab["ÚW"][i]
	  dspStr = (value == 0 ? "" : formatNum(value/dspScale,0) )
	  tableDataCell("class='" + className + "'", dspStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "ÀÑE\ª" );
   for( var i = 0; i < dispCnt; i++){
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  value = gTab["\À"][i]
	  dspStr = (value == 0 ? "" : formatNum(value/dspScale,0) )
	  tableDataCell("class='" + className + "'", dspStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "ONxÀÑ*" );
   for( var i = 0; i < dispCnt; i++){
	  className = "actual"
	  value = gTab["ON"][i]
	  dspStr = (value > 0 ? formatNum(value/dspScale,0) : "-")
	  tableDataCell("ALIGN='RIGHT' class='" + className + "' nowrap", dspStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "Ýv[ÚW] (A)" );
   for( var i = 0; i < dispCnt; i++){
	  className = ( (i%3) == 2 ? "secTotal" : "secTotal")
	  value = rTab["ÚW"][i]
	  if( i == 11 ) className = "lastTarget"
	  dspStr = formatNum(value/dspScale,0).fontcolor("darkgreen")
	  tableDataCell("ALIGN='RIGHT' class='" + className + "'", dspStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "Ýv[À\] (B)" );
   for( var i = 0; i < dispCnt; i++){
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  value = rTab["\À"][i]
	  dspStr = formatNum(value/dspScale,0).fontcolor("black")
	  tableDataCell("ALIGN='RIGHT' class='" + className + "'", dspStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' class='secTotal'" , "Ýv[OÀ]*" );
   var rTotal = 0
   for( var i = 0; i < dispCnt; i++){
	  className = "secTotal"
	  value = rTab["ON"][i]
	  dspStr = (value > 0 ? formatNum(value/dspScale,0) : "-")
	  tableDataCell("ALIGN='RIGHT' class='" + className + "' nowrap", dspStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' class='secTotal'" , "¦ (B/A)" );
   for( var i = 0; i < dispCnt; i++){
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  value = rTab["\À"][i] / rTab["ÚW"][i]
	  dspStr = (rTab["ÚW"][i] > 0 ? formatNum(value*100,1).bold() + " %" : "-")
	  tableDataCell("ALIGN='RIGHT' class='" + className + "' nowrap", dspStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' class='secTotal'" , "· (B-A)" );
   for( var i = 0; i < dispCnt; i++){
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  value = rTab["\À"][i] - rTab["ÚW"][i]
	  dspStr = formatNum(value/dspScale,0)
	  dspStr = (value >= 0 ? dspStr.fontcolor("black") : dspStr.fontcolor("tomato") )
	  tableDataCell("nowrap class='" + className + "'", dspStr )
	  }
   tableRowEnd();
   tableBodyEnd();
// SÐf[^\¦I¹ ==================


// J­f[^\¦
   for( var S_name in Tab){
	  if( S_name == "SÌ" ) continue;
	  tableBodyBegin("");
	  tableRowBegin("");
	  value = Tab[S_name]["¼O"]
	  tableDataCell("ALIGN='LEFT' nowrap class='groupType' rowspan='7'", value);

	  tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "" );
	  for(i = 0; i < dispCnt; i++){
		 tableDataCell("class='mounth' width='65'",yymmAdd(s_yymm,i)%100 + "");
		 }
	  tableRowEnd();

	  tableRowBegin("");
	  tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "Ú@W" );
	  for( var i = 0; i < dispCnt; i++){
		 className = "target"
		 value = Tab[S_name]["ÚW"][i]
		 dspStr = (value == 0 ? "" : formatNum(value/dspScale,0) )
		 tableDataCell("class='" + className + "'", dspStr )
		 }
	  tableRowEnd();

	  tableRowBegin("");
	  tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "ÀÑE\ª" );
	  for( var i = 0; i < dispCnt; i++){
		 className = ( i < actualCnt ? "actual" : "yosoku")
		 value = Tab[S_name]["\À"][i]
		 dspStr = (value == 0 ? "" : formatNum(value/dspScale,0) )
		 tableDataCell("class='" + className + "'", dspStr )
		 }
	  tableRowEnd();

	  //==========================================
	  // ÝvÌvZ
	  for(var kind in Tab[S_name]){
		 var rValue = 0
		 for(var m in Tab[S_name][kind]){
			rValue += Tab[S_name][kind][m]
			rTab[kind][m] = rValue
			}
		 }

	  tableRowBegin("");
	  tableDataCell("ALIGN='CENTER' class='secTotal'" , "Ýv[ÚW] (A)" );
	  for( var i = 0; i < dispCnt; i++){
		 className = ( (i%3) == 2 ? "secTotal" : "secTotal")
		 value = rTab["ÚW"][i]
		 if( i == 11 ) className = "lastTarget"
		 dspStr = formatNum(value/dspScale,0).fontcolor("darkgreen")
		 tableDataCell("ALIGN='RIGHT' class='" + className + "'", dspStr )
		 }
	  tableRowEnd();

	  tableRowBegin("");
	  tableDataCell("ALIGN='CENTER' class='secTotal'" , "Ýv[À\] (B)" );
	  for( var i = 0; i < dispCnt; i++){
		 className = ( i < actualCnt ? "actual" : "yosoku")
		 value = rTab["\À"][i]
		 dspStr = formatNum(value/dspScale,0).fontcolor("black")
		 tableDataCell("ALIGN='RIGHT' class='" + className + "'", dspStr )
		 }
	  tableRowEnd();

	  tableRowBegin("");
	  tableDataCell("ALIGN='CENTER' class='secTotal'" , "¦ (B/A)" );
	  for( var i = 0; i < dispCnt; i++){
		 className = ( i < actualCnt ? "actual" : "yosoku")
		 value = rTab["\À"][i] / rTab["ÚW"][i]
		 dspStr = (rTab["ÚW"][i] > 0 ? formatNum(value*100,1).bold() + " %" : "-")
		 tableDataCell("ALIGN='RIGHT' class='" + className + "' nowrap", dspStr )
		 }
	  tableRowEnd();

	  tableRowBegin("");
	  tableDataCell("ALIGN='CENTER' class='secTotal'" , "· (B-A)" );
	  for( var i = 0; i < dispCnt; i++){
		 className = ( i < actualCnt ? "actual" : "yosoku")
		 value = rTab["\À"][i] - rTab["ÚW"][i]
		 dspStr = formatNum(value/dspScale,0)
		 dspStr = (value >= 0 ? dspStr.fontcolor("black") : dspStr.fontcolor("tomato") )
		 tableDataCell("nowrap class='" + className + "'", dspStr )
		 }
	  tableRowEnd();
	  tableBodyEnd();
	  }
   tableEnd();

// J­f[^\¦I¹ ==================

   }


function getUser(DB,yymm,dispCnt)
	{
	var s_yymm = yymm;
	var e_yymm = yymmAdd(yymm,dispCnt - 1);
	var x_yymm = yymmAdd(e_yymm,1)				  // Ì
	var sDate = parseInt(s_yymm / 100) + "/" + (s_yymm%100) + "/1"
	var eDate = parseInt(x_yymm / 100) + "/" + (x_yymm%100) + "/1"

	var RS = Server.CreateObject("ADODB.Recordset")

	var gCode,gName,value,uName
	var Tab = new Object

	var S_name = "SÌ"
   Tab[S_name] = makeGroup(S_name,dispCnt)
//=================================================================
	SQL  = " SELECT"
	SQL += "     ¼Ô   = SM.¼Ô,"
	SQL += "     S_name = SM.+SM.å"
	SQL += " FROM"
	SQL += "     (SELECT * FROM {}X^ WHERE NOT(Jn > '" + e_yymm + "' OR I¹ < '" + s_yymm + "') AND ¼Ô IN(0,1) ) SM"

	SQL += " WHERE"
	SQL += "     SM.O[v = ''"
/*
	SQL += "     SM.Jn <=  '" + e_yymm + "'"
	SQL += "     and"
	SQL += "     SM.I¹ >= '" + s_yymm + "'"
	SQL += "     AND"
	SQL += "     ¼Ô IN(0,1)"
*/
//	SQL += " GROUP BY"
//	SQL += "     SM.¼Ô,"
//	SQL += "     SM.+SM.å"
	SQL += " ORDER BY"
	SQL += "     ¼Ô,"
	SQL += "     S_name"
//EMGLog.Write("x.txt",SQL)
	RS.Open(SQL, DB, 0, 1)

	while( !RS.EOF ){
		S_name = RS.Fields('S_name').Value
		Tab[S_name] = makeGroup(S_name,dispCnt)

		RS.MoveNext();
		}
	RS.Close()
   return(Tab)
   }
   
function makeGroup(gName,dispCnt)
	{
	Tab = new Object
	Tab["¼O"] = gName
	Tab["ÚW"] = new Array(dispCnt)
	Tab["\À"] = new Array(dispCnt)
	Tab["ON"] = new Array(dispCnt)
	for( var i = 0; i < dispCnt; i++){
		Tab["ÚW"][i] = 0
		Tab["\À"][i] = 0
		Tab["ON"][i] = 0
		}
	return(Tab)
	}

// ãÀÑf[^æ¾
function getActualData(DB,Tab,yymm,dispCnt,actualCnt)
	{
	if( actualCnt < 0 ) return

	var s_yymm = yymm;
	var e_yymm = yymmAdd(yymm,actualCnt-1);
	var cur_yymm;

	var RS = Server.CreateObject("ADODB.Recordset")

	SQL = ""
	SQL += " SELECT"
	SQL += "    S_name = SM.+SM.{+SM.å,"
	SQL += "    gCode  = BUSYO.ID,"
	SQL += "    gName = (SELECT TOP 1 ¼ FROM EMG.dbo.}X^ WHERE R[h = BUSYO.ID ORDER BY Jn desc),"
	SQL += "    yymm   = DATA.yymm,"
	SQL += "    amount = Sum(DATA.àz)"
	SQL += " FROM"
	SQL += " 	cÆãf[^ DATA LEFT JOIN Æ±f[^ BUSYO ON DATA.pNum    = BUSYO.pNum"
	SQL += "	                    LEFT JOIN (SELECT * FROM {}X^ WHERE NOT(Jn > '" + e_yymm + "' OR I¹ < '" + s_yymm + "') AND ¼Ô IN(0,1,2) ) SM"
	SQL += "                            ON BUSYO.ID = SM.ID"
//	SQL += "	                    LEFT JOIN {}X^ SM    ON BUSYO.ID = SM.ID"
	SQL += " WHERE"
	SQL += "	DATA.tÖ IN(0,1,2)"
	SQL += "	AND"
	SQL += "    DATA.Flag = 0"
	SQL += "    AND"
	SQL += "    (DATA.yymm Between BUSYO.Jn And BUSYO.I¹)"
//	SQL += "	AND"
//	SQL += "	(DATA.yymm Between SM.Jn And SM.I¹)"
	SQL += " GROUP BY"
	SQL += "    SM.+SM.{+SM.å,"
	SQL += "    BUSYO.ID,"
	SQL += "    DATA.yymm"
	SQL += " HAVING"
	SQL += "    DATA.yymm Between '" + s_yymm + "' And '" + e_yymm + "'"
	SQL += " ORDER BY"
	SQL += "    S_name,"
	SQL += "    DATA.yymm"
	RS = DB.Execute(SQL)
	var m,pNum,amount,gName,c_yymm
	while(!RS.EOF){
		S_name	= RS.Fields('S_name').Value
		c_yymm	= RS.Fields('yymm').Value
		amount	= RS.Fields('amount').Value
		gCode	= RS.Fields('gCode').Value
		gName	= RS.Fields('gName').Value
		if( S_name == null ){
			S_name = gName + "(" + gCode + ")"
			}

		m = yymmDiff(yymm,c_yymm)
		if( !IsObject(Tab[S_name]) ){
			S_name = gName + "(" + gCode + ")"
			if( !IsObject(Tab[S_name]) ) Tab[S_name] = makeGroup(S_name,dispCnt)
//			Tab[S_name] = makeGroup(S_name,dispCnt)
//			EMGLog.Write("naka.txt",gCode)
			}
		Tab[S_name]["\À"][m] += amount
		RS.MoveNext()
		}
	RS.Close()

//Response.End


	}

// ã\ªf[^æ¾
function getExpectData(DB,Tab,yymm,dispCnt,actualCnt,fixLevel)
	{
	var sTab = salesAdjustData(DB,yymm,"\ª")
	var fixWork = []
	for(var iNum = fixLevel; iNum <= 100; iNum += 10){
		fixWork[fixWork.length] = iNum
		}
	var fix_level = fixWork.join(",")

	var yosoku_level  = 70

	if( actualCnt < 0 ) actualCnt = 0
	var s_yymm = yymmAdd(yymm,actualCnt);
	var e_yymm = yymmAdd(yymm,dispCnt - 1);
	var cur_yymm;

	var RS = Server.CreateObject("ADODB.Recordset")

//=================================================================
	SQL = ""
	SQL += " SELECT"
	SQL += "    S_name = SM.+SM.{+SM.å,"
	SQL += "    gCode  = BUSYO.ID,"
	SQL += "    gName = (SELECT TOP 1 ¼ FROM EMG.dbo.}X^ WHERE R[h = BUSYO.ID ORDER BY Jn desc),"
	SQL += "    yymm   = DATA.yymm,"
	SQL += "    amount = Sum(DATA.sales)"
	SQL += " FROM"
	SQL += " 	(cÆ\ªf[^ DATA LEFT JOIN Æ±f[^ BUSYO ON DATA.pNum    = BUSYO.pNum)"
	SQL += "                         LEFT JOIN projectNum     PNUM  ON DATA.pNum    = PNUM.pNum"
	SQL += "		                 LEFT JOIN  (SELECT * FROM {}X^ WHERE NOT(Jn > '" + e_yymm + "' OR I¹ < '" + s_yymm + "') AND ¼Ô IN(0,1) ) SM    ON BUSYO.ID = SM.ID"
//	SQL += "		                 LEFT JOIN  {}X^ SM    ON BUSYO.ID = SM.ID"
	SQL += " WHERE"
	SQL += "    PNUM.stat IN(0,1,4,5)"
	SQL += "    and"
	SQL += "    PNUM.fix_level IN(" + fix_level + ")"
	SQL += "    and"
	SQL += "    (DATA.yymm Between BUSYO.Jn And BUSYO.I¹)"
//	SQL += "	AND"
//	SQL += "	(DATA.yymm Between SM.Jn And SM.I¹)"
	SQL += " GROUP BY"
	SQL += "    SM.+SM.{+SM.å,"
	SQL += "    BUSYO.ID,"
	SQL += "    DATA.yymm"
	SQL += " HAVING"
	SQL += "    DATA.yymm Between '" + s_yymm + "' And '" + e_yymm + "'"
	SQL += " ORDER BY"
	SQL += "    S_name,"
	SQL += "    DATA.yymm"

//EMGLog.Write("naka.txt",SQL)

	RS = DB.Execute(SQL)
	var m,pNum,amount,gName,c_yymm
	while(!RS.EOF){
		S_name	= RS.Fields('S_name').Value
		c_yymm	= RS.Fields('yymm').Value
		amount	= RS.Fields('amount').Value
		gCode	= RS.Fields('gCode').Value
		gName	= RS.Fields('gName').Value
		if( S_name == null ){
			S_name = gName + "(" + gCode + ")"
			}
		m = yymmDiff(yymm,c_yymm)
		if( !IsObject(Tab[S_name]) ){
			S_name = gName + "(" + gCode + ")"
			if( !IsObject(Tab[S_name]) ) Tab[S_name] = makeGroup(S_name,dispCnt)
//			EMGLog.Write("naka.txt",gName + "(" + gCode + ")")
			}
		Tab[S_name]["\À"][m] += amount * 1000
		RS.MoveNext()
		}
	RS.Close()
	}

// ãÚWf[^
function getTargetData(DB,Tab,yymm,dispCnt,actualCnt)
	{
	var sTab = salesAdjustData(DB,yymm,"væ")

	var s_yymm = yymmAdd(yymm,actualCnt);
	var e_yymm = yymmAdd(yymm,dispCnt - 1);
	var cur_yymm;

	var RS = Server.CreateObject("ADODB.Recordset")

	SQL = ""
	SQL += " SELECT"
	SQL += "    S_name = SM.+SM.{+SM.å,"
	SQL += "    gCode  = DATA.ID,"
	SQL += "    gName = (SELECT TOP 1 ¼ FROM EMG.dbo.}X^ WHERE R[h = DATA.ID ORDER BY Jn desc),"
	SQL += "    yymm   = DATA.yymm,"
	SQL += "    amount = Sum(DATA.l)"
	SQL += " FROM"
	SQL += " 	ûxvæf[^ DATA"
	SQL += "		           LEFT JOIN (SELECT * FROM {}X^ WHERE NOT(Jn > '" + e_yymm + "' OR I¹ < '" + s_yymm + "') AND ¼Ô IN(0,1) ) SM    ON DATA.ID = SM.ID"
//	SQL += "		           LEFT JOIN {}X^     SM    ON DATA.ID = SM.ID"
	SQL += " WHERE"
	SQL += "    DATA.ÚID = 3"						// ã
	SQL += "    AND"
	SQL += "    DATA.íÊ = 0"						// væ
	SQL += "    AND"
	SQL += "    DATA.yymm Between '" + s_yymm + "' And '" + e_yymm + "'"
//	SQL += "	AND"
//	SQL += "	(DATA.yymm Between SM.Jn And SM.I¹)"
	SQL += " GROUP BY"
	SQL += "    SM.+SM.{+SM.å,"
	SQL += "    DATA.ID,"
	SQL += "    DATA.yymm"
	SQL += " ORDER BY"
	SQL += "    S_name,"
	SQL += "    DATA.yymm"
	RS = DB.Execute(SQL)
	var m,pNum,amount,gName,c_yymm
	while(!RS.EOF){
		S_name	= RS.Fields('S_name').Value
		c_yymm	= RS.Fields('yymm').Value
		amount	= RS.Fields('amount').Value
		gCode	= RS.Fields('gCode').Value
		gName	= RS.Fields('gName').Value

		if( S_name == null ){
			S_name = gName + "(" + gCode + ")"
			}

		m = yymmDiff(yymm,c_yymm)
		if( !IsObject(Tab[S_name]) ){
			S_name = gName + "(" + gCode + ")"
			if( !IsObject(Tab[S_name]) ) Tab[S_name] = makeGroup(S_name,dispCnt)
//			Tab[S_name] = makeGroup(S_name,dispCnt)
//			EMGLog.Write("naka.txt","ERROR"+gName + "(" + gCode + ")")
			}
		Tab[S_name]["ÚW"][m] += amount * 1000
		RS.MoveNext()
		}
	RS.Close()

	}


// ONxÌãf[^
function getPastData(DB,Tab,yymm,Cnt)
	{
	var s_yymm = yymm
	var e_yymm = yymmAdd( s_yymm, (Cnt * 12) - 1)

	var RS = Server.CreateObject("ADODB.Recordset")

	SQL  = " SELECT"
	SQL += " 	mm     = yymm % 100,"
	SQL += " 	amount = sum(àz)"
	SQL += " FROM"
	SQL += " 	cÆãf[^"
	SQL += " WHERE"
	SQL += "    yymm BETWEEN " + s_yymm + " AND " + e_yymm + ""
	SQL += "    AND"
	SQL += "    Flag = 0"
	SQL += " GROUP BY"
	SQL += " 	yymm % 100"
	SQL += " ORDER BY"
	SQL += " 	yymm % 100"
	RS = DB.Execute(SQL)

	var n,c_mm,amount
	var S_name = "SÌ"
	while( !RS.EOF ){
		c_mm  = RS.Fields('mm').Value
		amount= RS.Fields('amount').Value
		n = (c_mm < 10 ? (c_mm + 12) - 10 : c_mm - 10)

		if( !IsObject(Tab[S_name]) ){
			S_name = gName + "(" + gCode + ")"
			if( !IsObject(Tab[S_name]) ) Tab[S_name] = makeGroup(S_name,dispCnt)
//			Tab[S_name] = makeGroup(S_name,dispCnt)
//			EMGLog.Write("naka.txt",gCode)
			}
		Tab[S_name]["ON"][n] = amount
	  
		RS.MoveNext();
		}
	RS.Close()

	return(Tab)
	}



function salesAdjustData(DB,yymm)
	{
	var mCnt = 12
	var s_yymm = yymm
	var e_yymm = yymmAdd(s_yymm,(mCnt-1))
	var SQLTab = []
	var SQL
	var Tab = {væ:{},\ª:{}}
	SQL = ""
	SQL += " SELECT"
	SQL += "    kind   = 'x¥',"
	SQL += "    mode   = DATA.íÊ,"						// 0:væ,1:\ª
	SQL += "    S_name = SM.+SM.{+SM.å,"
	SQL += "    gCode  = DATA.x¥,"
	SQL += "    gName  = (SELECT TOP 1 ¼ FROM EMG.dbo.}X^ WHERE R[h = DATA.x¥ ORDER BY Jn desc),"
	SQL += "    yymm   = DATA.yymm,"
	SQL += "    value  = Sum(DATA.tÖàz)"
	SQL += " FROM"
	SQL += " 	tÖvæf[^ DATA"
	SQL += "		           LEFT JOIN (SELECT * FROM {}X^ WHERE NOT(Jn > '" + e_yymm + "' OR I¹ < '" + s_yymm + "') AND ¼Ô IN(0,1) ) SM    ON DATA.x¥ = SM.ID"
	SQL += " WHERE"
	SQL += "    DATA.yymm BETWEEN '" + s_yymm + "' AND '" + e_yymm + "'"
	SQL += "    AND"
	SQL += "    DATA.mode=0"							// 0:ã,1:ïp
	SQL += "    AND"
	SQL += "    DATA.íÊ IN(0,1)"						// 0:væ,1:\ª
	SQL += " GROUP BY"
	SQL += "    DATA.íÊ,"								// 0:væ,1:\ª
	SQL += "    SM.+SM.{+SM.å,"
	SQL += "    DATA.x¥,"
	SQL += "    DATA.yymm"
	SQL += " ORDER BY"
	SQL += "    S_name,"
	SQL += "    DATA.yymm"
	RS = DB.Execute(SQL)
	var oName,iName,value,c_yymm,n,modeName
	while( !RS.EOF ){
		kind   = RS.Fields("kind").Value
		mode   = RS.Fields("mode").Value
		c_yymm = RS.Fields("yymm").Value
		S_name = RS.Fields("S_name").Value
		gName  = RS.Fields("gName").Value
		gCode  = RS.Fields("gCode").Value
		value  = RS.Fields("value").Value
		modeName = (mode == 0 ? "væ" : "\ª" )
		n = yymmDiff(s_yymm,c_yymm)

		if( S_name == null ) S_name = gName + "(" + gCode + ")"

		if( !IsObject(Tab[modeName][S_name]) ) Tab[modeName][S_name] = {óæ:[0,0,0,0,0,0,0,0,0,0,0,0],x¥:[0,0,0,0,0,0,0,0,0,0,0,0]}
		if( kind == "óæ" ) Tab[modeName][S_name].óæ[n] += value
		if( kind == "x¥" ) Tab[modeName][S_name].x¥[n] -= value
//pr("[" + iCode + "][" + oCode + "][" + value + "]")
		RS.MoveNext()
		}
	RS.Close()

	SQL = ""
	SQL += " SELECT"
	SQL += "    kind   = 'óæ',"
	SQL += "    mode   = DATA.íÊ,"						// 0:væ,1:\ª
	SQL += "    S_name = SM.+SM.{+SM.å,"
	SQL += "    gCode  = DATA.óæ,"
	SQL += "    gName  = (SELECT TOP 1 ¼ FROM EMG.dbo.}X^ WHERE R[h = DATA.óæ ORDER BY Jn desc),"
	SQL += "    yymm   = DATA.yymm,"
	SQL += "    value  = Sum(DATA.tÖàz)"
	SQL += " FROM"
	SQL += " 	tÖvæf[^ DATA"
	SQL += "		           LEFT JOIN (SELECT * FROM {}X^ WHERE NOT(Jn > '" + e_yymm + "' OR I¹ < '" + s_yymm + "') AND ¼Ô IN(0,1) ) SM    ON DATA.óæ = SM.ID"
	SQL += " WHERE"
	SQL += "    DATA.yymm BETWEEN '" + s_yymm + "' AND '" + e_yymm + "'"
	SQL += "    AND"
	SQL += "    DATA.mode=0"							// 0:ã,1:ïp
	SQL += "    AND"
	SQL += "    DATA.íÊ IN(0,1)"						// 0:væ,1:\ª
	SQL += " GROUP BY"
	SQL += "    DATA.íÊ,"								// 0:væ,1:\ª
	SQL += "    SM.+SM.{+SM.å,"
	SQL += "    DATA.óæ,"
	SQL += "    DATA.yymm"
	SQL += " ORDER BY"
	SQL += "    S_name,"
	SQL += "    DATA.yymm"


//EMGLog.Write("x.txt",SQL)	
//pr(SQL)
	RS = DB.Execute(SQL)
	var oName,iName,value,c_yymm,n,modeName
	while( !RS.EOF ){
		kind   = RS.Fields("kind").Value
		mode   = RS.Fields("mode").Value
		c_yymm = RS.Fields("yymm").Value
		S_name = RS.Fields("S_name").Value
		gName  = RS.Fields("gName").Value
		gCode  = RS.Fields("gCode").Value
		value  = RS.Fields("value").Value
		modeName = (mode == 0 ? "væ" : "\ª" )
		n = yymmDiff(s_yymm,c_yymm)

		if( S_name == null ) S_name = gName + "(" + gCode + ")"

		if( !IsObject(Tab[modeName][S_name]) ) Tab[modeName][S_name] = {óæ:[0,0,0,0,0,0,0,0,0,0,0,0],x¥:[0,0,0,0,0,0,0,0,0,0,0,0]}
		if( kind == "óæ" ) Tab[modeName][S_name].óæ[n] += value
		if( kind == "x¥" ) Tab[modeName][S_name].x¥[n] -= value
//pr("[" + iCode + "][" + oCode + "][" + value + "]")
		RS.MoveNext()
		}
	RS.Close()

	return(Tab)
	}
%>
<%
function IsObject(o)
   {
   if( typeof(o) != "undefined" ) return(true)
   return(false)
   }
%>
<SCRIPT FOR="onDisp1" EVENT="onmouseover" LANGUAGE="JavaScript">
this.style.color="red"
</SCRIPT>
<SCRIPT FOR="onDisp1" EVENT="onmouseout" LANGUAGE="JavaScript">
this.style.color="black"
</SCRIPT>
<SCRIPT FOR="onDisp2" EVENT="onmouseover" LANGUAGE="JavaScript">
this.style.color="red"
</SCRIPT>
<SCRIPT FOR="onDisp2" EVENT="onmouseout" LANGUAGE="JavaScript">
this.style.color="black"
</SCRIPT>
<SCRIPT FOR="onDisp1" EVENT="onclick" LANGUAGE="JavaScript">
var para
para  = "?Group="	  + this.Group
para += "&yymm="	  + this.yymm
para += "&dispCnt="   + this.dispCnt
para += "&actualCnt=" + this.actualCnt
winOpen("O[vÚW.asp" + para);
</SCRIPT>
<SCRIPT FOR="onDisp2" EVENT="onclick" LANGUAGE="JavaScript">
var para
para  = "?Group="	  + this.Group
para += "&yymm="	  + this.yymm
para += "&dispCnt="   + this.dispCnt
para += "&actualCnt=" + this.actualCnt
winOpen("O[v\À.asp" + para);
</SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
var newWin = null;
function winOpen(aspName)
   {
   newWin = window.open(aspName,"uriageWin","width=900,height=600,scrollbars,resizable,status=no");
   }
   
function winClose()
   {
   if(newWin != null && !newWin.closed) newWin.close();
   }
</SCRIPT>
<SCRIPT LANGUAGE="JavaScript" src="cmn.js"></SCRIPT>
<SCRIPT LANGUAGE="VBScript"   src="cmn.vbs"></SCRIPT>
