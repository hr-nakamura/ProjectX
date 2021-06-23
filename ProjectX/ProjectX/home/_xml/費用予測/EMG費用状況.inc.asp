<%
	Response.End();
	%>
<%
var limitYear = 2003
var dispCnt = 12
/*
   Session("memberName1") = "中村"
   Session("memberName2") = "博"
*/
//======  ======================

var year = String(Request.QueryString("year"))
if( year == "undefined" ){
   var d = new Date()
   var yy = d.getFullYear()
   var mm = d.getMonth()+1

   year = yy + (mm >= 10 ? 1 : 0)			  // 10月以降は次年度を表示
   }

if( year < limitYear ){
   Response.End()
   }

%>



<html>

<head>
<META http-equiv="Content-Type" content="text/html; charset=SHIFT_JIS">
<META http-equiv="X-UA-Compatible" content="IE=5" />


<title>費用状況</title>
</head>

<!--	<LINK rel="stylesheet" href="test.css" type="text/css">	-->
<STYLE TYPE="text/css">
TH{
   padding:2;
   }
TD{
   padding:2;
   white-space:nowrap;
   }
.table{
	font-size: x-small;
	background-color:'snow';
	}
.groupType{
   white-space:nowrap;
	background-color:'linen';
	}
.userType{
   white-space:nowrap;
	background-color:'mintcream';
	}
.xTotal{
   white-space:nowrap;
	background-color:'blanchedalmond';
	}
.secTotal{
   white-space:nowrap;
	background-color:'aliceblue';
	}
.allTotal{
   white-space:nowrap;
	background-color:'linen';
	}
.target{
	text-align:right;
   white-space:nowrap;
	color:darkgreen;
	background-color:snow;
	}
.actual{
	text-align:right;
   white-space:nowrap;
	color:black;
	background-color:snow;
	}
.yosoku{
	text-align:right;
   white-space:nowrap;
	color:blue;
	background-color:gainsboro;
	}
.quarter{
   white-space:nowrap;
	background-color:'navajowhite';
	}
.lastTarget{
	text-align:right;
   white-space:nowrap;
	background-color:springgreen;
	}
.mounth{
	text-align:center;
   white-space:nowrap;
	background-color:lavender;
	}
</STYLE>


<SCRIPT LANGUAGE="JavaScript">
var limitYear = <%=limitYear%>
var year	  = <%=year%>
var dispCnt   = <%=dispCnt%>
</SCRIPT>

<SCRIPT FOR="window" EVENT="onload" Language="JavaScript">
var yymm = (year-1)*100 + 10
mainTitle.innerHTML = String(year + "年度　費用状況")	//.big().big()
subTitle.innerHTML = "(" + strMonth(yymm) + "～" + strMonth(yymmAdd(yymm,dispCnt-1)) + ")"

if(year > limitYear ){
   prev.style.display=""
   }
next.style.display=""

window.focus()
</SCRIPT>

<SCRIPT FOR="window" EVENT="onunload" LANGUAGE="JavaScript">
</SCRIPT>
<SCRIPT FOR="prev" EVENT="onclick" LANGUAGE="JavaScript">
var value = parseInt(year) - 1
window.location.replace(window.location.pathname + "?year=" + value )
</SCRIPT>
<SCRIPT FOR="next" EVENT="onclick" LANGUAGE="JavaScript">
var value = parseInt(year) + 1
window.location.replace(window.location.pathname + "?year=" + value )
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
		 <table ALIGN="center" ID="Table1">
			<caption><SPAN id="mainTitle">　</SPAN></caption>
			<TR>
			   <td>
				  <TABLE ALIGN="center" ID="Table2">
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
<%
main(year,dispCnt)
%>
			   </td>
			</TR>
		 </table>

</body>
</html>


<%
function main(year,dispCnt)
	{
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
b_yymm = 201810
actualCnt = 3
	dispPlan( b_yymm,dispCnt,actualCnt)
	}

function dispPlan( b_yymm,dispCnt,actualCnt)
  {
//=== データ取得 =======================================================
   var Tab = getUser(b_yymm,dispCnt)						// 分類名作成
   getActualData(Tab,b_yymm,dispCnt,actualCnt)			// 実績データ取得
   getPlanData(Tab,b_yymm,dispCnt,actualCnt)				// 計画データ取得
	getPastData(Tab,b_yymm,dispCnt)							// 過去データ

// 実績と予算のマージ（実績の数値がない月は予算を使う）

   for(var item in Tab){
	  for(var kind in Tab[item]){
		 var x = "計画"
		 for(var m in Tab[item][kind][x]){
			if( m >= actualCnt){
			   Tab[item][kind]["実績"][m] = Tab[item][kind]["計画"][m]
			   }
			}
		 }
	  }
	  
	  EMGLog.Json("費用状況.json",Tab);
//=== データ表示 =======================================================
   dispUser(Tab,b_yymm,dispCnt,actualCnt)
   
// 販管費詳細データ表示
   dispSection(Tab,b_yymm,dispCnt,actualCnt)


   }

//================================================================

function dispUser(Tab,yymm,dispCnt,actualCnt)
   {
   var s_yymm = yymm;
   var e_yymm = yymmAdd(yymm,dispCnt - 1);
   var cur_yymm;

// 部門別集計データ表示
   tableBegin("width='100%' class='table' BORDER='1' CELLPADDING='2' CELLSPACING='0'");
   tableHeadBegin("");
   tableRowBegin("valign='bottom' bordercolor='black' bgcolor='#aac2ea'");
   tableHeadCell("width='100'","大分類");
   tableHeadCell("width='100'","項目");
   tableHeadCell("colspan='3'" + "width='" + (65*3) + "'",parseInt(s_yymm/100) + "年");
   tableHeadCell("colspan='9'" + "width='" + (65*9) + "'",parseInt(s_yymm/100)+1 + "年");

   tableRowEnd();
   tableHeadEnd();

// 全社データ計算=================================================
// 累計データ
   var rTab = new Object()
   makeArray(rTab,dispCnt)

// 合計データ
   var gTab = new Object()
   makeArray(gTab,dispCnt)

// 合計データ計算
   var iName = "売上原価,販管費,営業外費用".split(",")
   for(var iNum in iName){
	  var item = iName[iNum]
	  for(var kind in Tab[item]){
		 for(var x in Tab[item][kind]){
			for(var m in Tab[item][kind][x]){
			   gTab[x][m] += Tab[item][kind][x][m]
			   }
			}
		 }
	  }
// 累計データ計算
   for(var x in gTab){
	  var rValue = 0
	  for(var m in gTab[x]){
		 rValue += gTab[x][m]
		 rTab[[x]][m] = rValue
		 }
	  }

// 全社データ表示
   tableBodyBegin("");
   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='xTotal' rowspan='8'", "ＥＭＧ".big().bold());

   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "月" );
   for(i = 0; i < dispCnt; i++){
	  tableDataCell("class='mounth' width='65'",yymmAdd(s_yymm,i)%100 + "月");
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "前年度実績1" );
   for( var i = 0; i < dispCnt; i++){
	  className = "actual"
	  value = gTab["過去"][i]
	  dispStr = (value == 0 ? "" : formatNum(value/1000,0) )
	  tableDataCell("class='" + className + "'", dispStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "予　算" );
   for( var i = 0; i < dispCnt; i++){
	  className = "target"
	  value = gTab["計画"][i]
	  dispStr = (value == 0 ? "" : formatNum(value/1000,0) )
	  tableDataCell("class='" + className + "'", dispStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "実績・予算" );
   for( var i = 0; i < dispCnt; i++){
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  value = gTab["実績"][i]
	  dispStr = (value == 0 ? "" : formatNum(value/1000,0) )
	  tableDataCell("class='" + className + "'", dispStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "累計[予算] (A)" );
   for( var i = 0; i < dispCnt; i++){
	  className = "secTotal"
	  if( i == 11 ) className = "lastTarget"
	  value = rTab["計画"][i]
	  tableDataCell("ALIGN='RIGHT' class='" + className + "'", formatNum(value/1000,0) )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "累計[実予] (B)" );
   for( var i = 0; i < dispCnt; i++){
	  className = "secTotal"
	  value = rTab["実績"][i]
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  tableDataCell("ALIGN='RIGHT' class='" + className + "'", formatNum(value/1000,0) )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "率 (B/A)" );
   for( var i = 0; i < dispCnt; i++){
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  value = rTab["実績"][i] / rTab["計画"][i]
	  dispStr = (rTab["計画"][i] > 0 ? formatNum(value*100,1).bold() + " %" : "-")
	  tableDataCell("ALIGN='RIGHT' class='" + className + "' nowrap", dispStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' class='secTotal'" , "差 (A-B)" );
   for( var i = 0; i < dispCnt; i++){
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  value = -(rTab["実績"][i] - rTab["計画"][i])
	  dispStr = formatNum(value/1000,0)
	  dispStr = (value >= 0 ? dispStr.fontcolor("black") : dispStr.fontcolor("tomato") )
	  tableDataCell("nowrap class='" + className + "'", dispStr )
	  }
   tableRowEnd();
   tableBodyEnd();
// 全社データ表示終了 ==================


// 売上原価データ計算=================================================
// 累計データ
   var rTab = new Object()
   makeArray(rTab,dispCnt)

// 合計データ
   var gTab = new Object()
   makeArray(gTab,dispCnt)

// 合計データ計算
   var iName = "売上原価".split(",")
   for(var iNum in iName){
	  var item = iName[iNum]
	  for(var kind in Tab[item]){
		 for(var x in Tab[item][kind]){
			for(var m in Tab[item][kind][x]){
			   gTab[x][m] += Tab[item][kind][x][m]
			   }
			}
		 }
	  }
// 累計データ計算
   for(var x in gTab){
	  var rValue = 0
	  for(var m in gTab[x]){
		 rValue += gTab[x][m]
		 rTab[[x]][m] = rValue
		 }
	  }

// 全社データ表示
   tableBodyBegin("");
   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='groupType' rowspan='8'", "売上原価");

   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "月" );
   for(i = 0; i < dispCnt; i++){
	  tableDataCell("class='mounth' width='65'",yymmAdd(s_yymm,i)%100 + "月");
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "前年度実績2" );
   for( var i = 0; i < dispCnt; i++){
	  className = "actual"
	  value = gTab["過去"][i]
	  dispStr = (value == 0 ? "" : formatNum(value/1000,0) )
	  tableDataCell("class='" + className + "'", dispStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "予　算" );
   for( var i = 0; i < dispCnt; i++){
	  className = "target"
	  value = gTab["計画"][i]
	  dispStr = (value == 0 ? "" : formatNum(value/1000,0) )
	  tableDataCell("class='" + className + "'", dispStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "実績・予算" );
   for( var i = 0; i < dispCnt; i++){
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  value = gTab["実績"][i]
	  dispStr = (value == 0 ? "" : formatNum(value/1000,0) )
	  tableDataCell("class='" + className + "'", dispStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "累計[予算] (A)" );
   for( var i = 0; i < dispCnt; i++){
	  className = "secTotal"
	  value = rTab["計画"][i]
	  tableDataCell("ALIGN='RIGHT' nowrap class='" + className + "'", formatNum(value/1000,0) )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "累計[実予] (B)" );
   for( var i = 0; i < dispCnt; i++){
	  className = "secTotal"
	  value = rTab["実績"][i]
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  tableDataCell("ALIGN='RIGHT' class='" + className + "'", formatNum(value/1000,0) )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "率 (B/A)" );
   for( var i = 0; i < dispCnt; i++){
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  value = rTab["実績"][i] / rTab["計画"][i]
	  dispStr = (rTab["計画"][i] > 0 ? formatNum(value*100,1).bold() + " %" : "-")
	  tableDataCell("ALIGN='RIGHT' class='" + className + "' nowrap", dispStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "差 (A-B)" );
   for( var i = 0; i < dispCnt; i++){
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  value = -(rTab["実績"][i] - rTab["計画"][i])
	  dispStr = formatNum(value/1000,0)
	  dispStr = (value >= 0 ? dispStr.fontcolor("black") : dispStr.fontcolor("tomato") )
	  tableDataCell("nowrap class='" + className + "'", dispStr )
	  }
   tableRowEnd();
   tableBodyEnd();
// 売上原価データ表示終了 ==================

// 販管費データ計算=================================================
// 累計データ
   var rTab = new Object()
   makeArray(rTab,dispCnt)

// 合計データ
   var gTab = new Object()
   makeArray(gTab,dispCnt)

// 合計データ計算
   var iName = "販管費".split(",")
   for(var iNum in iName){
	  var item = iName[iNum]
	  for(var kind in Tab[item]){
		 for(var x in Tab[item][kind]){
			for(var m in Tab[item][kind][x]){
			   gTab[x][m] += Tab[item][kind][x][m]
			   }
			}
		 }
	  }
// 累計データ計算
   for(var x in gTab){
	  var rValue = 0
	  for(var m in gTab[x]){
		 rValue += gTab[x][m]
		 rTab[[x]][m] = rValue
		 }
	  }

// 全社データ表示
   tableBodyBegin("");
   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='groupType' rowspan='8'", "販管費");

   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "月" );
   for(i = 0; i < dispCnt; i++){
	  tableDataCell("class='mounth' width='65'",yymmAdd(s_yymm,i)%100 + "月");
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "前年度実績3" );
   for( var i = 0; i < dispCnt; i++){
	  className = "actual"
	  value = gTab["過去"][i]
	  dispStr = (value == 0 ? "" : formatNum(value/1000,0) )
	  tableDataCell("class='" + className + "'", dispStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "予　算" );
   for( var i = 0; i < dispCnt; i++){
	  className = "target"
	  value = gTab["計画"][i]
	  dispStr = (value == 0 ? "" : formatNum(value/1000,0) )
	  tableDataCell("class='" + className + "'", dispStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "実績・予算" );
   for( var i = 0; i < dispCnt; i++){
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  value = gTab["実績"][i]
	  dispStr = (value == 0 ? "" : formatNum(value/1000,0) )
	  tableDataCell("class='" + className + "'", dispStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "累計[予算] (A)" );
   for( var i = 0; i < dispCnt; i++){
	  className = "secTotal"
	  value = rTab["計画"][i]
	  tableDataCell("ALIGN='RIGHT' class='" + className + "'", formatNum(value/1000,0) )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "累計[実予] (B)" );
   for( var i = 0; i < dispCnt; i++){
	  className = "secTotal"
	  value = rTab["実績"][i]
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  tableDataCell("ALIGN='RIGHT' class='" + className + "'", formatNum(value/1000,0) )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "率 (B/A)" );
   for( var i = 0; i < dispCnt; i++){
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  value = rTab["実績"][i] / rTab["計画"][i]
	  dispStr = (rTab["計画"][i] > 0 ? formatNum(value*100,1).bold() + " %" : "-")
	  tableDataCell("ALIGN='RIGHT' class='" + className + "' nowrap", dispStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "差 (A-B)" );
   for( var i = 0; i < dispCnt; i++){
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  value = -(rTab["実績"][i] - rTab["計画"][i])
	  dispStr = formatNum(value/1000,0)
	  dispStr = (value >= 0 ? dispStr.fontcolor("black") : dispStr.fontcolor("tomato") )
	  tableDataCell("nowrap class='" + className + "'", dispStr )
	  }
   tableRowEnd();
   tableBodyEnd();
// 販管費データ表示終了 ==================

// 営業外費用データ計算=================================================
// 累計データ
   var rTab = new Object()
   makeArray(rTab,dispCnt)

// 合計データ
   var gTab = new Object()
   makeArray(gTab,dispCnt)

// 合計データ計算
   var iName = "営業外費用".split(",")
   for(var iNum in iName){
	  var item = iName[iNum]
	  for(var kind in Tab[item]){
		 for(var x in Tab[item][kind]){
			for(var m in Tab[item][kind][x]){
			   gTab[x][m] += Tab[item][kind][x][m]
			   }
			}
		 }
	  }
// 累計データ計算
   for(var x in gTab){
	  var rValue = 0
	  for(var m in gTab[x]){
		 rValue += gTab[x][m]
		 rTab[[x]][m] = rValue
		 }
	  }

// 全社データ表示
   tableBodyBegin("");
   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='groupType' rowspan='8'", "営業外費用");

   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "月" );
   for(i = 0; i < dispCnt; i++){
	  tableDataCell("class='mounth' width='65'",yymmAdd(s_yymm,i)%100 + "月");
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "前年度実績4" );
   for( var i = 0; i < dispCnt; i++){
	  className = "actual"
	  value = gTab["過去"][i]
	  dispStr = (value == 0 ? "" : formatNum(value/1000,0) )
	  tableDataCell("class='" + className + "'", dispStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "予　算" );
   for( var i = 0; i < dispCnt; i++){
	  className = "target"
	  value = gTab["計画"][i]
	  dispStr = (value == 0 ? "" : formatNum(value/1000,0) )
	  tableDataCell("class='" + className + "'", dispStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "実績・予算" );
   for( var i = 0; i < dispCnt; i++){
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  value = gTab["実績"][i]
	  dispStr = (value == 0 ? "" : formatNum(value/1000,0) )
	  tableDataCell("class='" + className + "'", dispStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "累計[予算] (A)" );
   for( var i = 0; i < dispCnt; i++){
	  className = "secTotal"
	  value = rTab["計画"][i]
	  tableDataCell("ALIGN='RIGHT' class='" + className + "'", formatNum(value/1000,0) )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "累計[実予] (B)" );
   for( var i = 0; i < dispCnt; i++){
	  className = "secTotal"
	  value = rTab["実績"][i]
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  tableDataCell("ALIGN='RIGHT' class='" + className + "'", formatNum(value/1000,0) )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "率 (B/A)" );
   for( var i = 0; i < dispCnt; i++){
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  value = rTab["実績"][i] / rTab["計画"][i]
	  dispStr = (rTab["計画"][i] > 0 ? formatNum(value*100,1).bold() + " %" : "-")
	  tableDataCell("ALIGN='RIGHT' class='" + className + "' nowrap", dispStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "差 (A-B)" );
   for( var i = 0; i < dispCnt; i++){
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  value = -(rTab["実績"][i] - rTab["計画"][i])
	  dispStr = formatNum(value/1000,0)
	  dispStr = (value >= 0 ? dispStr.fontcolor("black") : dispStr.fontcolor("tomato") )
	  tableDataCell("nowrap class='" + className + "'", dispStr )
	  }
   tableRowEnd();
   tableBodyEnd();
// 営業外費用データ表示終了 ==================

   tableEnd();
   }

function dispSection(Tab,s_yymm,dispCnt,actualCnt)
   {
   var sectionName = "販管費"
   var nameTab = "人件費,雑給<BR>(アルバイト),広告交際費,旅費交通費,通信費,荷造発送費,備品・マシン,マシン(固定資産),設備・リース料,家賃等,その他,ＥＭＧ間費用".split(",")
   var itemTab = "人件費,雑給,広告交際,交通費,通信費,発送費,備品,固定資産,設備費,家賃,その他,EMG間費用".split(",")
   var nameTab = "人件費,雑給<BR>(アルバイト),広告交際費,旅費交通費,通信費,荷造発送費,備品・マシン,設備・リース料,家賃等,その他,ＥＭＧ間費用".split(",")
   var itemTab = "人件費,雑給,広告交際,交通費,通信費,発送費,備品,設備費,家賃,その他,EMG間費用".split(",")
   
   tableBegin("width='100%' class='table' BORDER='1' CELLPADDING='2' CELLSPACING='0'");
   tableCaption("align='CENTER'", sectionName.big() );

   tableHeadBegin("");
   tableRowBegin("valign='bottom' bordercolor='black' bgcolor='#aac2ea'");
   tableHeadCell("width='100'","分　類");
   tableHeadCell("width='100'","項　目");
   tableHeadCell("colspan='3'" + "width='" + (65*3) + "'",parseInt(s_yymm/100) + "年");
   tableHeadCell("colspan='9'" + "width='" + (65*9) + "'",parseInt(s_yymm/100)+1 + "年");

   tableRowEnd();
   tableHeadEnd();

   tableBodyBegin("");


// 各分類データ表示
   var item = sectionName
   for( var kNum in itemTab){
	  var kind = itemTab[kNum]

	  var name = nameTab[kNum]
	  var gTab = Tab[item][kind]

// 累計データ計算
   // 累計データ
	  var rTab = new Object()
	  makeArray(rTab,dispCnt)

	  for(var x in gTab){
		 var rValue = 0
		 for(var m in gTab[x]){
			rValue += gTab[x][m]
			rTab[[x]][m] = rValue
			}
		 }

	  // 分類表示開始 ==================
	  tableRowBegin("");
	  var dispInfo
	  dispInfo	= "ID='onDisp1'"
	  dispInfo += "Group='" 	+ kind + "'"
	  dispInfo += "yymm='"		+ s_yymm + "'"
	  dispInfo += "dispCnt='"	+ dispCnt + "'"
	  dispInfo += "actualCnt='" + actualCnt + "'"
	  dispInfo += "style='cursor:hand;'"
	  dispInfo = ""					// 無効にする
	  tableDataCell("ALIGN='CENTER' nowrap class='groupType' rowspan='8'" + dispInfo,name);

	  tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "月" );
	  for(i = 0; i < dispCnt; i++){
		 tableDataCell("class='mounth' width='65'",yymmAdd(s_yymm,i)%100 + "月");
		 }
	  tableRowEnd();

	  tableRowBegin("");
	  tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "前年度実績5" );
	  for( var i = 0; i < dispCnt; i++){
		 className = "actual"
		 value = gTab["過去"][i]
		 dispStr = (value == 0 ? "" : formatNum(value/1000,0) )
		 tableDataCell("class='" + className + "'", dispStr )
		 }
	  tableRowEnd();

	  tableRowBegin("");
	  tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "予　算" );
	  for( var i = 0; i < dispCnt; i++){
		 className = "target"
		 value = gTab["計画"][i]
		 dispStr = (value == 0 ? "" : formatNum(value/1000,0) )
		 tableDataCell("class='" + className + "'", dispStr )
		 }
	  tableRowEnd();

	  tableRowBegin("");
	  tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "実績・予算" );
	  for( var i = 0; i < dispCnt; i++){
		 className = ( i < actualCnt ? "actual" : "yosoku")
		 value = gTab["実績"][i]
		 dispStr = (value == 0 ? "" : formatNum(value/1000,0) )
		 tableDataCell("class='" + className + "'", dispStr )
		 }
	  tableRowEnd();

	  tableRowBegin("");
	  tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "累計[予算] (A)" );
	  for( var i = 0; i < dispCnt; i++){
		 className = "secTotal"
		 value = rTab["計画"][i]
		 tableDataCell("ALIGN='RIGHT' class='" + className + "'", formatNum(value/1000,0) )
		 }
	  tableRowEnd();

	  tableRowBegin("");
	  tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "累計[実予] (B)" );
	  for( var i = 0; i < dispCnt; i++){
		 className = "secTotal"
		 value = rTab["実績"][i]
		 className = ( i < actualCnt ? "actual" : "yosoku")
		 tableDataCell("ALIGN='RIGHT' class='" + className + "'", formatNum(value/1000,0) )
		 }
	  tableRowEnd();

	  tableRowBegin("");
	  tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "率 (B/A)" );
	  for( var i = 0; i < dispCnt; i++){
		 className = ( i < actualCnt ? "actual" : "yosoku")
		 value = rTab["実績"][i] / rTab["計画"][i]
		 dispStr = (rTab["計画"][i] > 0 ? formatNum(value*100,1).bold() + " %" : "-")
		 tableDataCell("ALIGN='RIGHT' class='" + className + "' nowrap", dispStr )
		 }
	  tableRowEnd();

	  tableRowBegin("");
	  tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "差 (A-B)" );
	  for( var i = 0; i < dispCnt; i++){
		 className = ( i < actualCnt ? "actual" : "yosoku")
		 value = -(rTab["実績"][i] - rTab["計画"][i])
		 dispStr = formatNum(value/1000,0)
		 dispStr = (value >= 0 ? dispStr.fontcolor("black") : dispStr.fontcolor("tomato") )
		 tableDataCell("nowrap class='" + className + "'", dispStr )
		 }
	  tableRowEnd();
	  }
   // 表示終了 ==================
   tableBodyEnd();
   tableEnd();
   }
	  
function getUser(yymm,dispCnt)
   {
   var s_yymm = yymm;
   var e_yymm = yymmAdd(yymm,dispCnt - 1);
   var cur_yymm;

   var DB = Server.CreateObject("ADODB.Connection")
   DB.Open( Session("ODBC") )
   DB.DefaultDatabase = "kansaDB"
   var RS = Server.CreateObject("ADODB.Recordset")

//=================================================================
   SQL	= " SELECT"
   SQL += "    大項目 = ITEM.大項目,"
   SQL += "    分類   = ITEM.分類"
   SQL += " FROM"
   SQL += "    会計項目マスタ ITEM"
   SQL += " GROUP BY"
   SQL += "     ITEM.大項目,"
   SQL += "     ITEM.分類"

   RS.Open(SQL, DB, 0, 1)


   var Tab = new Object()
	Tab["販管費"] = new Object
//	Tab["販管費"]["固定資産"] = new Object
//	makeArray(Tab["販管費"]["固定資産"],dispCnt)
   var item,kind
   while( !RS.EOF ){
	  item = JsTrim(RS.Fields('大項目').Value)
	  kind = JsTrim(RS.Fields('分類').Value)
	  if(!IsArray(Tab[item])) Tab[item] = new Object
	  if(!IsArray(Tab[item][kind])){
			Tab[item][kind] = new Object
			makeArray(Tab[item][kind],dispCnt)
			}
	  RS.MoveNext();
	  }
   RS.Close()
   DB.Close()
   return(Tab)
   }
   

// 実績データ取得
function getActualData(Tab,yymm,dispCnt,actualCnt)
   {
	var sDate = parseInt(yymm/100) + "/" + (yymm%100) + "/1"
	var eDate = DateAdd("m",dispCnt,sDate)
	eDate = convertDate(DateAdd("d",-1,eDate) )

   var s_yymm = yymm;
   var e_yymm = yymmAdd(yymm,actualCnt - 1);
   var cur_yymm;

   var DB = Server.CreateObject("ADODB.Connection")
   DB.Open( Session("ODBC") )
   DB.DefaultDatabase = "kansaDB"
   var RS = Server.CreateObject("ADODB.Recordset")

//=================================================================
   SQL	= " SELECT"
   SQL += "     大項目 = ITEM.大項目,"
   SQL += "     分類   = ITEM.分類,"
   SQL += "     yymm   = DATA.yymm,"
   SQL += "     EMG    = DATA.Flag,"
   SQL += "     amount = Sum(DATA.金額)"
   SQL += "     FROM"
   SQL += "     	(会計項目マスタ ITEM INNER JOIN 会計月データ       DATA ON ITEM.KmkCode = DATA.科目 AND (ITEM.Flag = DATA.Flag))"
//	 SQL += "     	                     INNER JOIN (SELECT * FROM EMG.dbo.部署マスタ WHERE 開始 <= '" + eDate + "' and 終了 > '" + sDate + "' ) MAST ON DATA.部門    = MAST.ACCコード"

   SQL += "     WHERE"
//	 SQL += "     	MAST.ACCコード >= 0"
//	 SQL += "     	AND"
   SQL += "     	DATA.yymm BETWEEN " + s_yymm + " and " + e_yymm + ""
   SQL += "     GROUP BY"
   SQL += "     	ITEM.大項目,"
   SQL += "     	ITEM.分類,"
   SQL += "     	DATA.yymm,"
   SQL += "     	DATA.Flag"

   RS.Open(SQL, DB, 0, 1)

   var item,kind,c_yymm,amount
   while( !RS.EOF ){
	  item	 = JsTrim(RS.Fields('大項目').Value)
	  kind	 = JsTrim(RS.Fields('分類').Value)
	  c_yymm = RS.Fields('yymm').Value
	  amount = RS.Fields('amount').Value
		EMG    = RS.Fields('EMG').Value
		if( EMG == 1 ) amount = -amount
//***** 分類情報格納
	  n = yymmDiff( yymm, c_yymm )
		if( IsObject(Tab[item][kind]["実績"][n]) ){
		  Tab[item][kind]["実績"][n] += amount
			}
	  RS.MoveNext();
	  }
   RS.Close()
/*
   SQL = ""
   SQL += " SELECT"
   SQL += "    大項目 = '販管費',"
   SQL += "    分類   = '固定資産',"
   SQL += "    yymm   = DATA.yymm,"
   SQL += "    EMG    = DATA.Flag," 			 // EMG間費用
   SQL += "    amount = Sum(DATA.金額)"
   SQL += " FROM"
   SQL += "    会計月データ DATA INNER JOIN (SELECT * FROM EMG.dbo.部署マスタ WHERE 開始 <= '" + eDate + "' and 終了 > '" + sDate + "' ) MAST ON DATA.部門 = MAST.ACCコード"
   SQL += " WHERE"
   SQL += "    MAST.ACCコード >= 0"
   SQL += "    AND"
   SQL += "    DATA.yymm BETWEEN " + s_yymm + " AND " + e_yymm
   SQL += "    AND"
   SQL += "    DATA.科目 BETWEEN 211 AND 260"				// 大項目 = 固定資産
   SQL += " GROUP BY"
   SQL += "    DATA.yymm,"
   SQL += "    DATA.Flag"
   RS = DB.Execute(SQL)

   var Grp,kind,item,yymm,amount,Cnt,mode
   while(!RS.EOF){
	  item	  = RS.Fields("大項目").Value
	  kind	  = RS.Fields("分類").Value
	  c_yymm  = RS.Fields("yymm").Value
	  amount  = RS.Fields("amount").Value
		EMG 	= RS.Fields('EMG').Value
		if( EMG == 1 ) amount = -amount
	  n = yymmDiff( yymm, c_yymm )
	  Tab[item][kind]["実績"][n] += amount
	  RS.MoveNext();
	  }
   RS.Close()
*/
   DB.Close()

   }


// 過去のデータ
function getPastData(Tab,yymm,Cnt)
   {
/*
   // 過去分の初期化
   for( var item in Tab ){
	  for( var kind in Tab[item]){
		 for( var n in Tab[item][kind]["過去"]){
			Tab[item][kind]["過去"][n] = 0
			}
		 }
	  }
*/
	var sDate = parseInt(yymm/100) + "/" + (yymm%100) + "/1"
	var eDate = DateAdd("m",Cnt,sDate)
	eDate = convertDate(DateAdd("d",-1,eDate) )


   var s_yymm = yymmAdd(  yymm,-(Cnt))
   var e_yymm = yymmAdd(s_yymm, (Cnt) - 1)

   var DB = Server.CreateObject("ADODB.Connection")
   DB.Open( Session("ODBC") )
   DB.DefaultDatabase = "kansaDB"
   var RS = Server.CreateObject("ADODB.Recordset")

//=================================================================
   SQL	= " SELECT"
   SQL += "     大項目 = ITEM.大項目,"
   SQL += "     分類   = ITEM.分類,"
   SQL += "     yymm   = DATA.yymm,"
   SQL += "     EMG    = DATA.Flag,"
   SQL += "     amount = Sum(DATA.金額)"
   SQL += "     FROM"
   SQL += "     	(会計項目マスタ ITEM INNER JOIN 会計月データ       DATA ON ITEM.KmkCode = DATA.科目 AND (ITEM.Flag = DATA.Flag))"

//	 SQL += "     	                     INNER JOIN (SELECT * FROM EMG.dbo.部署マスタ WHERE 開始 <= '" + eDate + "' and 終了 > '" + sDate + "' ) MAST ON DATA.部門 = MAST.ACCコード"

   SQL += "     WHERE"
//	 SQL += "     	MAST.ACCコード >= 0"
//	 SQL += "     	AND"
   SQL += "     	DATA.yymm BETWEEN " + s_yymm + " and " + e_yymm + ""
   SQL += "     GROUP BY"
   SQL += "     	ITEM.大項目,"
   SQL += "     	ITEM.分類,"
   SQL += "     	DATA.yymm,"
   SQL += "     	DATA.Flag"

   RS.Open(SQL, DB, 0, 1)

   var item,kind,c_yymm,amount
   while( !RS.EOF ){
	  item	 = JsTrim(RS.Fields('大項目').Value)
	  kind	 = JsTrim(RS.Fields('分類').Value)
	  c_yymm = RS.Fields('yymm').Value
	  amount = RS.Fields('amount').Value
		EMG    = RS.Fields('EMG').Value
		if( EMG == 1 ) amount = -amount
	  n = yymmDiff( s_yymm, c_yymm )
	  if( IsObject(Tab[item][kind]["過去"][n]) ){
		  Tab[item][kind]["過去"][n] += amount
			}
	  RS.MoveNext();
	  }
   RS.Close()

/*
   SQL = ""
   SQL += " SELECT"
   SQL += "    大項目 = '販管費',"
   SQL += "    分類   = '固定資産',"
   SQL += "    yymm   = DATA.yymm,"
   SQL += "    EMG    = DATA.Flag," 			 // EMG間費用
   SQL += "    amount = Sum(DATA.金額)"
   SQL += " FROM"
   SQL += "    会計月データ DATA INNER JOIN (SELECT * FROM EMG.dbo.部署マスタ WHERE 開始 <= '" + eDate + "' and 終了 > '" + sDate + "' ) MAST ON DATA.部門 = MAST.ACCコード"
   SQL += " WHERE"
   SQL += "    MAST.ACCコード >= 0"
   SQL += "    AND"
   SQL += "    DATA.yymm BETWEEN " + s_yymm + " AND " + e_yymm
   SQL += "    AND"
   SQL += "    DATA.科目 BETWEEN 211 AND 260"				// 大項目 = 固定資産
   SQL += " GROUP BY"
   SQL += "    DATA.yymm,"
   SQL += "    DATA.Flag"
   RS = DB.Execute(SQL)

   var Grp,kind,item,yymm,amount,Cnt,mode
   while(!RS.EOF){
	  item	  = RS.Fields("大項目").Value
	  kind	  = RS.Fields("分類").Value
	  c_yymm  = RS.Fields("yymm").Value
	  amount  = RS.Fields("amount").Value
		EMG 	= RS.Fields('EMG').Value
		if( EMG == 1 ) amount = -amount
	  n = yymmDiff( s_yymm, c_yymm )
	  Tab[item][kind]["過去"][n] += amount
	  RS.MoveNext();
	  }
   RS.Close()
*/
   DB.Close()
   }


// 計画データ取得
function getPlanData(Tab,yymm,dispCnt,actualCnt)
   {
// 年間データを0に入れてそこから各月(1-10)を引いていく

   var year = parseInt(yymm/100) + 1
   
	var sDate = parseInt(yymm/100) + "/" + (yymm%100) + "/1"
	var eDate = DateAdd("m",dispCnt,sDate)
	eDate = convertDate(DateAdd("d",-1,eDate) )

   var s_yymm = yymmAdd(yymm,actualCnt);
   var e_yymm = yymmAdd(yymm,dispCnt - 1);
   var cur_yymm;

   var DB = Server.CreateObject("ADODB.Connection")
   DB.Open( Session("ODBC") )
   DB.DefaultDatabase = "kansaDB"
   var RS = Server.CreateObject("ADODB.Recordset")

//=================================================================
   SQL	= " SELECT"
   SQL += " 	item   = ITEM.大項目,"
   SQL += " 	kind   = ITEM.項目,"
   SQL += " 	yymm   = DATA.yymm,"
   SQL += " 	amount = Sum(DATA.数値)"
   SQL += " FROM"
   SQL += " 	(収支計画データ DATA INNER JOIN (SELECT * FROM EMG.dbo.部署マスタ WHERE 開始 <= '" + eDate + "' and 終了 > '" + sDate + "' ) MAST ON DATA.部署ID = MAST.部署コード)"
   SQL += " 	                     INNER JOIN 収支項目マスタ     ITEM ON DATA.項目ID = ITEM.ID"
   SQL += " WHERE"
   SQL += " 	DATA.種別 = 0"
   SQL += " 	AND"
   SQL += " 	MAST.ACCコード >= 0"
   SQL += " 	AND"
   SQL += " 	DATA.yymm BETWEEN " + yymm + " AND " + e_yymm
   SQL += " GROUP BY"
   SQL += " 	ITEM.大項目,"
   SQL += " 	ITEM.項目,"
   SQL += " 	DATA.yymm"

   RS.Open(SQL, DB, 0, 1)

	var item,kind,c_yymm,amount
	while( !RS.EOF ){
		item	 = JsTrim(RS.Fields('item').Value)
		kind	 = JsTrim(RS.Fields('kind').Value)
		c_yymm = RS.Fields('yymm').Value
		amount = RS.Fields('amount').Value

		if( item == "固定資産" && kind == "機器・ソフト" ){
//			item = "販管費"
//			kind = "固定資産"
			}
//pr(item + "][" + kind)
		n = yymmDiff( yymm, c_yymm )
		if( IsObject(Tab[item]) && IsObject(Tab[item][kind])){		// 期末期首棚卸を除外
			Tab[item][kind]["計画"][n] += amount * 1000
			}
		RS.MoveNext();
		}
	RS.Close()
	DB.Close()

	}

 
function makeArray(Tab,Cnt)
   {
   if(!IsArray(Tab["実績"])){
	  Tab["過去"] = new Array(Cnt)
	  Tab["計画"] = new Array(Cnt)
	  Tab["実績"] = new Array(Cnt)
	  for( var i = 0; i < Cnt; i++){
		 Tab["過去"][i] = 0
		 Tab["計画"][i] = 0
		 Tab["実績"][i] = 0
		 }
	  }
   }
   
%>

<%
function IsObject(o)
   {
   if( typeof(o) != "undefined" ) return(true)
   return(false)
   }


function countArray(Tab)
   {
   var cnt = 0
   for( var i in Tab){
	  cnt++
	  }
   return(cnt)
   }
   
function IsArray(Tab)
   {
   if( typeof(Tab) == "object" ) return(true)
   return(false)
   }

function dicInit(Tab)
   {
   var i
   var Dic = new ActiveXObject("Scripting.Dictionary")
   for(i = 0; i < Tab.length; i++){
	  Dic.Add(Tab[i],i)
	  }
   return(Dic)
   }
   
function dicGet(Dic,key)
   {
   var value = (Dic.Exists(key) ? Dic.Item(key) : -1)
   return(value)
   }

%>

<SCRIPT LANGUAGE="JavaScript" src="cmn.js"></SCRIPT>
<SCRIPT LANGUAGE="VBScript"   src="cmn.vbs"></SCRIPT>
