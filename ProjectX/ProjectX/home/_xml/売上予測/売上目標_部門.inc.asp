<%
    Response.End();
%>
<%
//	 Session("memberName1") = "中村"
//	 Session("memberName2") = "博"

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

		year = yy + (mm >= 10 ? 1 : 0)			 // 10月以降は次年度を表示
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

	  <title>売上一覧</title>
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
mainTitle.innerHTML = String(year + "年度　売上目標　達成状況").big()
subTitle.innerHTML = "(" + strMonth(yymm) + "～" + strMonth(yymmAdd(yymm,dispCnt-1)) + ")"

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
			<caption><SPAN id="mainTitle">　</SPAN></caption>
		<TR>
			<td>
				<TABLE ALIGN="center" ID="Table2">
					<TR>
						<TD ALIGN="right">確度</TD>
						<TD ALIGN="left">
						<INPUT type="radio" id="level" name="level" value="70">Ａ
						<INPUT type="radio" id="level" name="level" value="50">Ｂ
						<INPUT type="radio" id="level" name="level" value="30">Ｃ
						<INPUT type="radio" id="level" name="level" value="10">Ｄ
						</TD>
					</TR>
					<TR>
						<TD ALIGN="right">売上付替<BR><small>(計画・予測)</small></TD>
						<TD ALIGN="left">
						<INPUT type="radio" id="Transfer" name="Transfer" value="1">あり
						<INPUT type="radio" id="Transfer" name="Transfer" value="0">なし
						</TD>
					</TR>
				</TABLE>
			</td>
		</TR>
			<TR>
			   <td>
				  <TABLE ALIGN="center">
					 <TR>
						<TD ALIGN="LEFT"><IMG SRC="arrow_l1.gif" id="prev" border="0" TITLE="前の期" STYLE="display=none"></TD>
						<TD ALIGN="CENTER"><SPAN ID="subTitle">　</SPAN></TD>
						<TD ALIGN="RIGHT"><IMG SRC="arrow_r1.gif" id="next" border="0" TITLE="次の期" STYLE="display=none"></TD>
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
	var yymm = yy * 100 + mm						// 今月のyymm

	var OKday = dayChk(d,adjustDayCnt)
	yymm = ( parseInt(dd) < parseInt(OKday) ? yymmAdd(yymm, -1) : yymmAdd(yymm, 0))			// 確定日の補正
	
	var b_yymm = ((year-1)*100) + 10

   var actualCnt = yymmDiff( b_yymm, yymm )
   if(actualCnt >= 12) actualCnt = 12
//======  ======================

   var Tab = dispPlan( DB,b_yymm,dispCnt,actualCnt,fixLevel,TransferMode)

//======  =========================================================================
//	 p("<BR><HR size='4' width='50%' color='blue'>")
//======  =========================================================================
//	 Title = String(((Math.floor(b_yymm/100))+1) + "年度　売上予測の実現率").big()
//	 dispPlanX( Title,b_yymm,dispCnt,actualCnt)

	DB.Close()


//EMGLog.Json("売上目標_部門.json",Tab);
	
	}

function dispPlan( DB,b_yymm,dispCnt,actualCnt,fixLevel,TransferMode)
  {
//=== データ取得 =======================================================
//		if( IsObject(Tab[S_name]) ){
//			for( var i = 0; i < dispCnt; i++ ){
//				Tab[S_name]["予実"][i] += ( IsObject(sTab[gCode]) ? (sTab[gCode].受取[i] + sTab[gCode].支払[i]) * 1000 : 0 )
//				}
//			}


   var Tab = getUser(DB,b_yymm,dispCnt)								// グループ名作成


   getPastData(DB,Tab,yymmAdd(b_yymm,-12),1)						// 前年度のデータ

   getActualData(DB,Tab,b_yymm,dispCnt,actualCnt)					// 実績データ取得

//dispXML("",Tab)

   getExpectData(DB,Tab,b_yymm,dispCnt,actualCnt,fixLevel)			// 予測データ取得
   getTargetData(DB,Tab,b_yymm,dispCnt,0)							// 目標データ取得


	if( TransferMode == 1 ){

		var sTab = salesAdjustData(DB,b_yymm)

		for( var S_name in sTab["計画"] ){
//pr( "1[" + S_name + "][" + IsObject(Tab[S_name]) )
			if( IsObject(Tab[S_name]) ){
				for( var m = 0; m < dispCnt; m++ ){
					value = sTab["計画"][S_name].受取[m] + sTab["計画"][S_name].支払[m]
					Tab[S_name]["目標"][m] += value * 1000
					}
				}
			}
		var s_m = ( actualCnt >= 0 ? actualCnt : 0 )
		for( var S_name in sTab["予測"] ){
//pr( "2[" + S_name + "][" + IsObject(Tab[S_name]) )
			if( IsObject(Tab[S_name]) ){
				for( var m = s_m; m < dispCnt; m++ ){
					value = sTab["予測"][S_name].受取[m] + sTab["予測"][S_name].支払[m]
					Tab[S_name]["予実"][m] += value * 1000
					}
				}
			}
		}

//=== データ表示 =======================================================
   tableBegin("width=100% align=center BORDER=0");

   tableBodyBegin("");

   tableRowBegin("");
   tableDataCellBegin("")
   dispUser(Tab,b_yymm,dispCnt,actualCnt)
   tableDataCellEnd()
   tableRowEnd();

   if( (dispCnt - actualCnt) > 0 ){
	  tableRowBegin("");
	  tableDataCell("ALIGN='LEFT'","予測データの確度は" + fixLevel + "％以上".small())
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
   
// 累計データ
   rTab = new Object
   rTab["目標"] = new Array(dispCnt)
   rTab["予実"] = new Array(dispCnt)
   rTab["前年"] = new Array(dispCnt)

// 合計データ
   gTab = new Object
   gTab["目標"] = new Array(dispCnt)
   gTab["予実"] = new Array(dispCnt)
   gTab["前年"] = new Array(dispCnt)

// 全社データ計算=================================================
// 合計データ初期化
   for( var m = 0; m < dispCnt; m++){
	  gTab["目標"][m] = 0
	  gTab["予実"][m] = 0
	  gTab["前年"][m] = 0
	  }
// 合計データ計算
   for( var S_name in Tab ){
	  for(var m = 0; m < dispCnt; m++){
		 gTab["目標"][m] += Tab[S_name]["目標"][m]
		 gTab["予実"][m] += Tab[S_name]["予実"][m]
		 gTab["前年"][m] += Tab[S_name]["前年"][m]
		 }
	  }
// 累計データ計算
   for(var kind in gTab){
	  var rValue = 0
	  for(var m in gTab[kind]){
		 rValue += gTab[kind][m]
		 rTab[kind][m] = rValue
		 }
	  }

// 集計データ表示
   tableBegin("width='100%' class='table' BORDER=1 CELLSPACING='0'");
//	 tableCaption("align='CENTER'","(" + strMonth(yymm) + "～" + strMonth(yymmAdd(yymm,dispCnt-1)) + ")" );

   tableHeadBegin("");
   tableRowBegin("valign='bottom' bordercolor='black' bgcolor='#aac2ea'");
   tableHeadCell("width='90'","グループ名");
   tableHeadCell("width='80'","項目");
   tableHeadCell("colspan='3'" + "width='" + (65*3) + "'",parseInt(s_yymm/100) + "年");
   tableHeadCell("colspan='9'" + "width='" + (65*9) + "'",parseInt(s_yymm/100)+1 + "年");

   tableRowEnd();
   tableHeadEnd();

// 全社データ表示
   tableBodyBegin("");
   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='xTotal' rowspan='9'", "ＥＭＧ".big().bold());

   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "月" );
   for(i = 0; i < dispCnt; i++){
	  tableDataCell("class='mounth' width='65'",yymmAdd(s_yymm,i)%100 + "月");
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "目　標" );
   for( var i = 0; i < dispCnt; i++){
	  className = "target"
	  value = gTab["目標"][i]
	  dspStr = (value == 0 ? "" : formatNum(value/dspScale,0) )
	  tableDataCell("class='" + className + "'", dspStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "実績・予測" );
   for( var i = 0; i < dispCnt; i++){
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  value = gTab["予実"][i]
	  dspStr = (value == 0 ? "" : formatNum(value/dspScale,0) )
	  tableDataCell("class='" + className + "'", dspStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "前年度実績*" );
   for( var i = 0; i < dispCnt; i++){
	  className = "actual"
	  value = gTab["前年"][i]
	  dspStr = (value > 0 ? formatNum(value/dspScale,0) : "-")
	  tableDataCell("ALIGN='RIGHT' class='" + className + "' nowrap", dspStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "累計[目標] (A)" );
   for( var i = 0; i < dispCnt; i++){
	  className = ( (i%3) == 2 ? "secTotal" : "secTotal")
	  value = rTab["目標"][i]
	  if( i == 11 ) className = "lastTarget"
	  dspStr = formatNum(value/dspScale,0).fontcolor("darkgreen")
	  tableDataCell("ALIGN='RIGHT' class='" + className + "'", dspStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "累計[実予] (B)" );
   for( var i = 0; i < dispCnt; i++){
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  value = rTab["予実"][i]
	  dspStr = formatNum(value/dspScale,0).fontcolor("black")
	  tableDataCell("ALIGN='RIGHT' class='" + className + "'", dspStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' class='secTotal'" , "累計[前実]*" );
   var rTotal = 0
   for( var i = 0; i < dispCnt; i++){
	  className = "secTotal"
	  value = rTab["前年"][i]
	  dspStr = (value > 0 ? formatNum(value/dspScale,0) : "-")
	  tableDataCell("ALIGN='RIGHT' class='" + className + "' nowrap", dspStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' class='secTotal'" , "率 (B/A)" );
   for( var i = 0; i < dispCnt; i++){
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  value = rTab["予実"][i] / rTab["目標"][i]
	  dspStr = (rTab["目標"][i] > 0 ? formatNum(value*100,1).bold() + " %" : "-")
	  tableDataCell("ALIGN='RIGHT' class='" + className + "' nowrap", dspStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' class='secTotal'" , "差 (B-A)" );
   for( var i = 0; i < dispCnt; i++){
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  value = rTab["予実"][i] - rTab["目標"][i]
	  dspStr = formatNum(value/dspScale,0)
	  dspStr = (value >= 0 ? dspStr.fontcolor("black") : dspStr.fontcolor("tomato") )
	  tableDataCell("nowrap class='" + className + "'", dspStr )
	  }
   tableRowEnd();
   tableBodyEnd();
// 全社データ表示終了 ==================


// 開発データ表示
   for( var S_name in Tab){
	  if( S_name == "全体" ) continue;
	  tableBodyBegin("");
	  tableRowBegin("");
	  value = Tab[S_name]["名前"]
	  tableDataCell("ALIGN='LEFT' nowrap class='groupType' rowspan='7'", value);

	  tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "月" );
	  for(i = 0; i < dispCnt; i++){
		 tableDataCell("class='mounth' width='65'",yymmAdd(s_yymm,i)%100 + "月");
		 }
	  tableRowEnd();

	  tableRowBegin("");
	  tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "目　標" );
	  for( var i = 0; i < dispCnt; i++){
		 className = "target"
		 value = Tab[S_name]["目標"][i]
		 dspStr = (value == 0 ? "" : formatNum(value/dspScale,0) )
		 tableDataCell("class='" + className + "'", dspStr )
		 }
	  tableRowEnd();

	  tableRowBegin("");
	  tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "実績・予測" );
	  for( var i = 0; i < dispCnt; i++){
		 className = ( i < actualCnt ? "actual" : "yosoku")
		 value = Tab[S_name]["予実"][i]
		 dspStr = (value == 0 ? "" : formatNum(value/dspScale,0) )
		 tableDataCell("class='" + className + "'", dspStr )
		 }
	  tableRowEnd();

	  //==========================================
	  // 累計の計算
	  for(var kind in Tab[S_name]){
		 var rValue = 0
		 for(var m in Tab[S_name][kind]){
			rValue += Tab[S_name][kind][m]
			rTab[kind][m] = rValue
			}
		 }

	  tableRowBegin("");
	  tableDataCell("ALIGN='CENTER' class='secTotal'" , "累計[目標] (A)" );
	  for( var i = 0; i < dispCnt; i++){
		 className = ( (i%3) == 2 ? "secTotal" : "secTotal")
		 value = rTab["目標"][i]
		 if( i == 11 ) className = "lastTarget"
		 dspStr = formatNum(value/dspScale,0).fontcolor("darkgreen")
		 tableDataCell("ALIGN='RIGHT' class='" + className + "'", dspStr )
		 }
	  tableRowEnd();

	  tableRowBegin("");
	  tableDataCell("ALIGN='CENTER' class='secTotal'" , "累計[実予] (B)" );
	  for( var i = 0; i < dispCnt; i++){
		 className = ( i < actualCnt ? "actual" : "yosoku")
		 value = rTab["予実"][i]
		 dspStr = formatNum(value/dspScale,0).fontcolor("black")
		 tableDataCell("ALIGN='RIGHT' class='" + className + "'", dspStr )
		 }
	  tableRowEnd();

	  tableRowBegin("");
	  tableDataCell("ALIGN='CENTER' class='secTotal'" , "率 (B/A)" );
	  for( var i = 0; i < dispCnt; i++){
		 className = ( i < actualCnt ? "actual" : "yosoku")
		 value = rTab["予実"][i] / rTab["目標"][i]
		 dspStr = (rTab["目標"][i] > 0 ? formatNum(value*100,1).bold() + " %" : "-")
		 tableDataCell("ALIGN='RIGHT' class='" + className + "' nowrap", dspStr )
		 }
	  tableRowEnd();

	  tableRowBegin("");
	  tableDataCell("ALIGN='CENTER' class='secTotal'" , "差 (B-A)" );
	  for( var i = 0; i < dispCnt; i++){
		 className = ( i < actualCnt ? "actual" : "yosoku")
		 value = rTab["予実"][i] - rTab["目標"][i]
		 dspStr = formatNum(value/dspScale,0)
		 dspStr = (value >= 0 ? dspStr.fontcolor("black") : dspStr.fontcolor("tomato") )
		 tableDataCell("nowrap class='" + className + "'", dspStr )
		 }
	  tableRowEnd();
	  tableBodyEnd();
	  }
   tableEnd();

// 開発データ表示終了 ==================

   }


function getUser(DB,yymm,dispCnt)
	{
	var s_yymm = yymm;
	var e_yymm = yymmAdd(yymm,dispCnt - 1);
	var x_yymm = yymmAdd(e_yymm,1)				  // 次の月
	var sDate = parseInt(s_yymm / 100) + "/" + (s_yymm%100) + "/1"
	var eDate = parseInt(x_yymm / 100) + "/" + (x_yymm%100) + "/1"

	var RS = Server.CreateObject("ADODB.Recordset")

	var gCode,gName,value,uName
	var Tab = new Object

	var S_name = "全体"
   Tab[S_name] = makeGroup(S_name,dispCnt)
//=================================================================
	SQL  = " SELECT"
	SQL += "     直間   = SM.直間,"
	SQL += "     S_name = SM.統括+SM.部門"
	SQL += " FROM"
	SQL += "     (SELECT * FROM 統括本部マスタ WHERE NOT(開始 > '" + e_yymm + "' OR 終了 < '" + s_yymm + "') AND 直間 IN(0,1) ) SM"

	SQL += " WHERE"
	SQL += "     SM.グループ = ''"
/*
	SQL += "     SM.開始 <=  '" + e_yymm + "'"
	SQL += "     and"
	SQL += "     SM.終了 >= '" + s_yymm + "'"
	SQL += "     AND"
	SQL += "     直間 IN(0,1)"
*/
//	SQL += " GROUP BY"
//	SQL += "     SM.直間,"
//	SQL += "     SM.統括+SM.部門"
	SQL += " ORDER BY"
	SQL += "     直間,"
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
	Tab["名前"] = gName
	Tab["目標"] = new Array(dispCnt)
	Tab["予実"] = new Array(dispCnt)
	Tab["前年"] = new Array(dispCnt)
	for( var i = 0; i < dispCnt; i++){
		Tab["目標"][i] = 0
		Tab["予実"][i] = 0
		Tab["前年"][i] = 0
		}
	return(Tab)
	}

// 売上実績データ取得
function getActualData(DB,Tab,yymm,dispCnt,actualCnt)
	{
	if( actualCnt < 0 ) return

	var s_yymm = yymm;
	var e_yymm = yymmAdd(yymm,actualCnt-1);
	var cur_yymm;

	var RS = Server.CreateObject("ADODB.Recordset")

	SQL = ""
	SQL += " SELECT"
	SQL += "    S_name = SM.統括+SM.本部+SM.部門,"
	SQL += "    gCode  = BUSYO.部署ID,"
	SQL += "    gName = (SELECT TOP 1 部署名 FROM EMG.dbo.部署マスタ WHERE 部署コード = BUSYO.部署ID ORDER BY 開始 desc),"
	SQL += "    yymm   = DATA.yymm,"
	SQL += "    amount = Sum(DATA.金額)"
	SQL += " FROM"
	SQL += " 	営業売上データ DATA LEFT JOIN 業務部署データ BUSYO ON DATA.pNum    = BUSYO.pNum"
	SQL += "	                    LEFT JOIN (SELECT * FROM 統括本部マスタ WHERE NOT(開始 > '" + e_yymm + "' OR 終了 < '" + s_yymm + "') AND 直間 IN(0,1,2) ) SM"
	SQL += "                            ON BUSYO.部署ID = SM.部署ID"
//	SQL += "	                    LEFT JOIN 統括本部マスタ SM    ON BUSYO.部署ID = SM.部署ID"
	SQL += " WHERE"
	SQL += "	DATA.付替 IN(0,1,2)"
	SQL += "	AND"
	SQL += "    DATA.Flag = 0"
	SQL += "    AND"
	SQL += "    (DATA.yymm Between BUSYO.開始 And BUSYO.終了)"
//	SQL += "	AND"
//	SQL += "	(DATA.yymm Between SM.開始 And SM.終了)"
	SQL += " GROUP BY"
	SQL += "    SM.統括+SM.本部+SM.部門,"
	SQL += "    BUSYO.部署ID,"
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
		Tab[S_name]["予実"][m] += amount
		RS.MoveNext()
		}
	RS.Close()

//Response.End


	}

// 売上予測データ取得
function getExpectData(DB,Tab,yymm,dispCnt,actualCnt,fixLevel)
	{
	var sTab = salesAdjustData(DB,yymm,"予測")
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
	SQL += "    S_name = SM.統括+SM.本部+SM.部門,"
	SQL += "    gCode  = BUSYO.部署ID,"
	SQL += "    gName = (SELECT TOP 1 部署名 FROM EMG.dbo.部署マスタ WHERE 部署コード = BUSYO.部署ID ORDER BY 開始 desc),"
	SQL += "    yymm   = DATA.yymm,"
	SQL += "    amount = Sum(DATA.sales)"
	SQL += " FROM"
	SQL += " 	(営業予測データ DATA LEFT JOIN 業務部署データ BUSYO ON DATA.pNum    = BUSYO.pNum)"
	SQL += "                         LEFT JOIN projectNum     PNUM  ON DATA.pNum    = PNUM.pNum"
	SQL += "		                 LEFT JOIN  (SELECT * FROM 統括本部マスタ WHERE NOT(開始 > '" + e_yymm + "' OR 終了 < '" + s_yymm + "') AND 直間 IN(0,1) ) SM    ON BUSYO.部署ID = SM.部署ID"
//	SQL += "		                 LEFT JOIN  統括本部マスタ SM    ON BUSYO.部署ID = SM.部署ID"
	SQL += " WHERE"
	SQL += "    PNUM.stat IN(0,1,4,5)"
	SQL += "    and"
	SQL += "    PNUM.fix_level IN(" + fix_level + ")"
	SQL += "    and"
	SQL += "    (DATA.yymm Between BUSYO.開始 And BUSYO.終了)"
//	SQL += "	AND"
//	SQL += "	(DATA.yymm Between SM.開始 And SM.終了)"
	SQL += " GROUP BY"
	SQL += "    SM.統括+SM.本部+SM.部門,"
	SQL += "    BUSYO.部署ID,"
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
		Tab[S_name]["予実"][m] += amount * 1000
		RS.MoveNext()
		}
	RS.Close()
	}

// 売上目標データ
function getTargetData(DB,Tab,yymm,dispCnt,actualCnt)
	{
	var sTab = salesAdjustData(DB,yymm,"計画")

	var s_yymm = yymmAdd(yymm,actualCnt);
	var e_yymm = yymmAdd(yymm,dispCnt - 1);
	var cur_yymm;

	var RS = Server.CreateObject("ADODB.Recordset")

	SQL = ""
	SQL += " SELECT"
	SQL += "    S_name = SM.統括+SM.本部+SM.部門,"
	SQL += "    gCode  = DATA.部署ID,"
	SQL += "    gName = (SELECT TOP 1 部署名 FROM EMG.dbo.部署マスタ WHERE 部署コード = DATA.部署ID ORDER BY 開始 desc),"
	SQL += "    yymm   = DATA.yymm,"
	SQL += "    amount = Sum(DATA.数値)"
	SQL += " FROM"
	SQL += " 	収支計画データ DATA"
	SQL += "		           LEFT JOIN (SELECT * FROM 統括本部マスタ WHERE NOT(開始 > '" + e_yymm + "' OR 終了 < '" + s_yymm + "') AND 直間 IN(0,1) ) SM    ON DATA.部署ID = SM.部署ID"
//	SQL += "		           LEFT JOIN 統括本部マスタ     SM    ON DATA.部署ID = SM.部署ID"
	SQL += " WHERE"
	SQL += "    DATA.項目ID = 3"						// 売上
	SQL += "    AND"
	SQL += "    DATA.種別 = 0"						// 計画
	SQL += "    AND"
	SQL += "    DATA.yymm Between '" + s_yymm + "' And '" + e_yymm + "'"
//	SQL += "	AND"
//	SQL += "	(DATA.yymm Between SM.開始 And SM.終了)"
	SQL += " GROUP BY"
	SQL += "    SM.統括+SM.本部+SM.部門,"
	SQL += "    DATA.部署ID,"
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
		Tab[S_name]["目標"][m] += amount * 1000
		RS.MoveNext()
		}
	RS.Close()

	}


// 前年度の売上データ
function getPastData(DB,Tab,yymm,Cnt)
	{
	var s_yymm = yymm
	var e_yymm = yymmAdd( s_yymm, (Cnt * 12) - 1)

	var RS = Server.CreateObject("ADODB.Recordset")

	SQL  = " SELECT"
	SQL += " 	mm     = yymm % 100,"
	SQL += " 	amount = sum(金額)"
	SQL += " FROM"
	SQL += " 	営業売上データ"
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
	var S_name = "全体"
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
		Tab[S_name]["前年"][n] = amount
	  
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
	var Tab = {計画:{},予測:{}}
	SQL = ""
	SQL += " SELECT"
	SQL += "    kind   = '支払',"
	SQL += "    mode   = DATA.種別,"						// 0:計画,1:予測
	SQL += "    S_name = SM.統括+SM.本部+SM.部門,"
	SQL += "    gCode  = DATA.支払部署,"
	SQL += "    gName  = (SELECT TOP 1 部署名 FROM EMG.dbo.部署マスタ WHERE 部署コード = DATA.支払部署 ORDER BY 開始 desc),"
	SQL += "    yymm   = DATA.yymm,"
	SQL += "    value  = Sum(DATA.付替金額)"
	SQL += " FROM"
	SQL += " 	付替計画データ DATA"
	SQL += "		           LEFT JOIN (SELECT * FROM 統括本部マスタ WHERE NOT(開始 > '" + e_yymm + "' OR 終了 < '" + s_yymm + "') AND 直間 IN(0,1) ) SM    ON DATA.支払部署 = SM.部署ID"
	SQL += " WHERE"
	SQL += "    DATA.yymm BETWEEN '" + s_yymm + "' AND '" + e_yymm + "'"
	SQL += "    AND"
	SQL += "    DATA.mode=0"							// 0:売上,1:費用
	SQL += "    AND"
	SQL += "    DATA.種別 IN(0,1)"						// 0:計画,1:予測
	SQL += " GROUP BY"
	SQL += "    DATA.種別,"								// 0:計画,1:予測
	SQL += "    SM.統括+SM.本部+SM.部門,"
	SQL += "    DATA.支払部署,"
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
		modeName = (mode == 0 ? "計画" : "予測" )
		n = yymmDiff(s_yymm,c_yymm)

		if( S_name == null ) S_name = gName + "(" + gCode + ")"

		if( !IsObject(Tab[modeName][S_name]) ) Tab[modeName][S_name] = {受取:[0,0,0,0,0,0,0,0,0,0,0,0],支払:[0,0,0,0,0,0,0,0,0,0,0,0]}
		if( kind == "受取" ) Tab[modeName][S_name].受取[n] += value
		if( kind == "支払" ) Tab[modeName][S_name].支払[n] -= value
//pr("[" + iCode + "][" + oCode + "][" + value + "]")
		RS.MoveNext()
		}
	RS.Close()

	SQL = ""
	SQL += " SELECT"
	SQL += "    kind   = '受取',"
	SQL += "    mode   = DATA.種別,"						// 0:計画,1:予測
	SQL += "    S_name = SM.統括+SM.本部+SM.部門,"
	SQL += "    gCode  = DATA.受取部署,"
	SQL += "    gName  = (SELECT TOP 1 部署名 FROM EMG.dbo.部署マスタ WHERE 部署コード = DATA.受取部署 ORDER BY 開始 desc),"
	SQL += "    yymm   = DATA.yymm,"
	SQL += "    value  = Sum(DATA.付替金額)"
	SQL += " FROM"
	SQL += " 	付替計画データ DATA"
	SQL += "		           LEFT JOIN (SELECT * FROM 統括本部マスタ WHERE NOT(開始 > '" + e_yymm + "' OR 終了 < '" + s_yymm + "') AND 直間 IN(0,1) ) SM    ON DATA.受取部署 = SM.部署ID"
	SQL += " WHERE"
	SQL += "    DATA.yymm BETWEEN '" + s_yymm + "' AND '" + e_yymm + "'"
	SQL += "    AND"
	SQL += "    DATA.mode=0"							// 0:売上,1:費用
	SQL += "    AND"
	SQL += "    DATA.種別 IN(0,1)"						// 0:計画,1:予測
	SQL += " GROUP BY"
	SQL += "    DATA.種別,"								// 0:計画,1:予測
	SQL += "    SM.統括+SM.本部+SM.部門,"
	SQL += "    DATA.受取部署,"
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
		modeName = (mode == 0 ? "計画" : "予測" )
		n = yymmDiff(s_yymm,c_yymm)

		if( S_name == null ) S_name = gName + "(" + gCode + ")"

		if( !IsObject(Tab[modeName][S_name]) ) Tab[modeName][S_name] = {受取:[0,0,0,0,0,0,0,0,0,0,0,0],支払:[0,0,0,0,0,0,0,0,0,0,0,0]}
		if( kind == "受取" ) Tab[modeName][S_name].受取[n] += value
		if( kind == "支払" ) Tab[modeName][S_name].支払[n] -= value
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
winOpen("グループ目標.asp" + para);
</SCRIPT>
<SCRIPT FOR="onDisp2" EVENT="onclick" LANGUAGE="JavaScript">
var para
para  = "?Group="	  + this.Group
para += "&yymm="	  + this.yymm
para += "&dispCnt="   + this.dispCnt
para += "&actualCnt=" + this.actualCnt
winOpen("グループ予実.asp" + para);
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
