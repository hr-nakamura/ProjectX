<%
    Response.End();
%>
<%

	var actualStr = String(Request.QueryString("actual"))
	var actualMonth
	if(IsNumeric(actualStr)){
		actualMonth = actualStr
		if( actualMonth > 12 || actualMonth < 0 ) actualMonth = -1
		}
	else{
		actualMonth = -1
		}

	var fixStr = String(Request.QueryString("fix"))
	var fixLevel
	if(IsNumeric(fixStr)){
		fixLevel = (Math.floor(fixStr/10))*10
		if( fixLevel > 100 || fixLevel < 0 ) fixLevel = 70
		}
	else{
		fixLevel = 70
		}


//	70だけ表示したいときのための処理
//===========================================
/*
	var fix_level = "100,90,80,70"
	var fixWork = []
	for(var iNum = fixLevel; iNum <= 100; iNum += 10){
		fixWork[fixWork.length] = iNum
		}
	var fix_level = fixWork.join(",")
*/
var allGroup = true
var limitYear = 2003
var dispCnt = 12
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


<%
function main(year,dispCnt,fixLevel)
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
	
	if(actualMonth >= 0) {
	    actualCnt = actualMonth
	}
  
	var Tab = getUser(DB,b_yymm,dispCnt)
	var Tab = new Object;

	getSalesData(DB,Tab,b_yymm,dispCnt,actualCnt,fixLevel)			 // 予測・実績

	DB.Close()

	dispPlan(Tab,b_yymm,dispCnt,actualCnt)
	
	EMGLog.Json("売上予実_新規.json",Tab);

	}
%>

<%
//================================================================
function dispPlan(Tab,yymm,dispCnt,actualCnt)
	{
   var EMGTab = {EM:"","ACEL":"A","PSL":"P","-":"-"}

	var s_yymm = yymm;
	var e_yymm = yymmAdd(yymm,dispCnt - 1);
	var cur_yymm;

	var totalTab  = new Array(dispCnt)
	var totalTabG = new Array(dispCnt)
   

	tableBegin("width='100%' class='table' BORDER='1' CELLPADDING='2' CELLSPACING='0'");
/*
	tableHeadBegin("");
	tableRowBegin("valign='bottom' bordercolor='black' bgcolor='#aac2ea'");
	tableHeadCell("width='20%'","グループ名");
	tableHeadCell("width='20%'","客先名");
	tableHeadCell("width='90'","合　計");
	for(i = 0; i < dispCnt; i++) tableHeadCell("width='90'",yymmAdd(s_yymm,i)%100 + "月");
	tableRowEnd();
	tableHeadEnd();
*/

	tableHeadBegin("");
	tableRowBegin("valign='bottom' bordercolor='black' bgcolor='#aac2ea'");
	tableHeadCell("width='80px'","分類名");
	tableHeadCell("width='20%'","客先名");
	tableHeadCell("width='90'","　");
	tableHeadCell("colspan='3'" + "width='" + (65*3) + "'",parseInt(s_yymm/100) + "年");
	tableHeadCell("colspan='9'" + "width='" + (65*9) + "'",parseInt(s_yymm/100)+1 + "年");
	tableHeadCell("width='90'","　");
	tableHeadCell("width='20%' colspan='2'","客先名");
	tableHeadCell("width='80px'","分類名");
	tableRowEnd();
	tableHeadEnd();

	tableBodyBegin("");

	for(var i = 0; i < dispCnt; i++) totalTabG[i] = 0
	//	グループ単位
	for( var S_name in Tab){
		var userCnt = countArray(Tab[S_name])
		// 月の表示
		if( userCnt > 0 ){
			var rowSpanCnt = userCnt + 2
			var LineCnt = 0
			tableRowBegin("valign='bottom' bordercolor='gray' bgcolor='lavender'");
			tableDataCell("colspan='2'","　");
			tableDataCell("align='center'","合　計");
			for(i = 0; i < dispCnt; i++) tableDataCell("align='center'width='90'",yymmAdd(s_yymm,i)%100 + "月");
			tableDataCell("align='center'","合　計");
			tableDataCell("colspan='3'","　");
			tableRowEnd();

			// 客先単位
			for( var uName in Tab[S_name].uName){
			// 1行データ表示開始 ==================
				tableRowBegin("");
				if(LineCnt == 0){
					for(var i = 0; i < dispCnt; i++) totalTab[i] = 0

					dispInfo  = "ID='onDisp'"
					dispInfo += "gName='"	  + S_name + "'"
					dispInfo += "yymm='"	  + s_yymm + "'"
					dispInfo += "dispCnt='"   + dispCnt + "'"
					dispInfo += "actualCnt='" + actualCnt + "'"
//					dispInfo += "style='cursor:hand;'"
					tableDataCell("ALIGN='LEFT' VALIGN='BOTTOM' nowrap class='groupType' rowspan='" + rowSpanCnt + "'" + dispInfo, Tab[S_name].gName);
					}
				tableDataCell("ALIGN='LEFT' nowrap class='userType'" , uName);

				for( var i = 0,value = 0; i < dispCnt; i++) value += Tab[S_name].uName[uName]["data"][i]
				var totalDispStr = (value == 0 ? "" : formatNum(value,0) )
				tableDataCell("ALIGN='RIGHT' class='secTotal'" , totalDispStr );
				for( var i = 0; i < dispCnt; i++){
					memo = "[ " + strMonth(yymmAdd(yymm,i)) + " ] " + uName
					className = ( i < actualCnt ? "actual" : "yosoku")
					value = Tab[S_name].uName[uName]["data"][i]
					lineDispStr = (value == 0 ? "" : formatNum(value,0) )
					tableDataCell("class='" + className + "' title='" + memo + "'", lineDispStr )
					totalTab[i]  += value
					totalTabG[i] += value
					}
// 後ろの情報
				EMG = Tab[S_name].uName[uName]["EMG"]
				tableDataCell("ALIGN='RIGHT' class='secTotal'" , totalDispStr );
				tableDataCell("ALIGN='LEFT' nowrap class='userType'" , EMGTab[EMG] );
				tableDataCell("ALIGN='LEFT' nowrap class='userType'" , uName );
				if(LineCnt == 0){
					dispInfo  = "ID='onDisp'"
					dispInfo += "gName='"	  + S_name + "'"
					dispInfo += "yymm='"	  + s_yymm + "'"
					dispInfo += "dispCnt='"   + dispCnt + "'"
					dispInfo += "actualCnt='" + actualCnt + "'"
//					dispInfo += "style='cursor:hand;'"
					tableDataCell("ALIGN='LEFT' VALIGN='BOTTOM' nowrap class='groupType' rowspan='" + rowSpanCnt + "'" + dispInfo, Tab[S_name].gName);
					}
				tableRowEnd();
				// データ表示終了 ==================

				LineCnt++
				}

			tableRowBegin("");
			tableDataCell("ALIGN='CENTER' class='secTotal' colspan='1'" , "合　計" );

			for( var i = 0,value = 0; i < dispCnt; i++) value += totalTab[i]
			dispStr = (value == 0 ? "" : formatNum(value,0) )
			tableDataCell("ALIGN='RIGHT' class='quarter'" , dispStr );
			for( var i = 0; i < dispCnt; i++){
				memo = "[ " + strMonth(yymmAdd(yymm,i)) + " ] " + Tab[S_name].gName
				value = totalTab[i]
				tableDataCell("ALIGN='RIGHT' class='secTotal' title='" + memo + "'", formatNum(value,0) )
				}
			tableDataCell("ALIGN='RIGHT' class='quarter'" , dispStr );
			tableDataCell("ALIGN='CENTER' class='secTotal' colspan='2'" , "合　計" );
			tableRowEnd();

			tableRowBegin("");
			tableDataCell("ALIGN='CENTER' class='allTotal' colspan='1'" , "累　計" );
			tableDataCell("ALIGN='CENTER' class='allTotal' colspan='1'" , "　" );
			rTotal = 0
			for( var i = 0; i < dispCnt; i++){
				memo = "[ " + strMonth(yymmAdd(yymm,i)) + " ] " + Tab[S_name].gName
				rTotal += totalTab[i]
				tableDataCell("ALIGN='RIGHT' class='allTotal' title='" + memo + "'", formatNum(rTotal,0) )
				}
			tableDataCell("ALIGN='CENTER' class='allTotal' colspan='1'" , "" );
			tableDataCell("ALIGN='CENTER' class='allTotal' colspan='2'" , "累　計" );
			tableRowEnd();

			}// 客先終了
		}// グループ終了
	tableBodyEnd();


	tableFootBegin("")
	tableRowBegin("valign='bottom'  bordercolor='black' bgcolor='#aac2ea'");
	tableHeadCell("colspan='2'","　");
	tableHeadCell("","合　計");
	for(i = 0; i < dispCnt; i++) tableHeadCell("width='90'",yymmAdd(s_yymm,i)%100 + "月");
	tableHeadCell("","合　計");
	tableHeadCell("colspan='3'","　");
	tableRowEnd();

	tableRowBegin("");
	tableDataCell("ALIGN='CENTER' class='secTotal' COLSPAN='2' nowrap" , "総　合　計" );

	for( var i = 0,value = 0; i < dispCnt; i++) value += totalTabG[i]
	dispStr = (value == 0 ? "" : formatNum(value,0) )
	tableDataCell("ALIGN='RIGHT' class='quarter'" , dispStr );
	for( var i = 0; i < dispCnt; i++){
		value = totalTabG[i]
		tableDataCell("ALIGN='RIGHT' class='secTotal'", formatNum(value,0) )
		}
	tableDataCell("ALIGN='RIGHT' class='quarter'" , dispStr );
	tableDataCell("ALIGN='CENTER' class='secTotal' COLSPAN='3' nowrap" , "総　合　計" );
	tableRowEnd();

	tableRowBegin("");
	tableDataCell("ALIGN='CENTER' class='allTotal' COLSPAN='2' nowrap" , "総　累　計" );
	tableDataCell("ALIGN='CENTER' class='allTotal' COLSPAN='1'" , "　" );
	rTotal = 0
	for( var i = 0; i < dispCnt; i++){
		rTotal += totalTabG[i]
		tableDataCell("ALIGN='RIGHT' class='allTotal'", formatNum(rTotal,0) )
		}
	tableDataCell("ALIGN='CENTER' class='allTotal' COLSPAN='1'" , "　" );
	tableDataCell("ALIGN='CENTER' class='allTotal' COLSPAN='3' nowrap" , "総　累　計" );
	tableRowEnd();
	tableFootEnd()


	tableEnd();
	}

function countArray(Tab)
   {
   var cnt = 0
   for( var i in Tab){
	  for( var ii in Tab[i]) cnt++
	  }
   return(cnt)
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

//=================================================================
	SQL  = " SELECT"
	SQL += "     S_name = SM.統括+SM.本部+SM.部門"
	SQL += " FROM"
	SQL += "     統括本部マスタ SM"
	SQL += " WHERE"
	SQL += "     SM.開始 <  '" + e_yymm + "'"
	SQL += "     and"
	SQL += "     SM.終了 >= '" + s_yymm + "'"
	SQL += " ORDER BY"
	SQL += "     SM.直間,"
	SQL += "     S_name"
	RS.Open(SQL, DB, 0, 1)

	while( !RS.EOF ){
		S_name = RS.Fields('S_name').Value
		Tab[S_name] = init_Group(S_name)

		RS.MoveNext();
		}
	RS.Close()
// その他
   Tab["間接"] = init_Group("間接")
   return(Tab)
   }

function init_userName(dispCnt)
   {
   var Tab = new Array(dispCnt)
   for( var i = 0; i < dispCnt; i++){
	  Tab[i] = 0
	  }
   return(Tab)
   }
function init_Group(gName)
   {
   var Tab = new Object
   Tab["gName"] = gName
   Tab["uName"] = new Object
   return(Tab)
   }
function getSalesData(DB,Tab,yymm,dispCnt,actualCnt,fixLevel)
   {
   var s_yymm = yymm;
   var e_yymm = yymmAdd(yymm,dispCnt - 1);
   var cur_yymm;
   var RS = Server.CreateObject("ADODB.Recordset")



	var KTab = {"新規顧客":"","新規事業部":"","新規分野":"","継続案件":""}
//	var KTab = {"新規顧客":"","新規事業部":"","新規分野":""}
	for( var S_name in KTab ){
		if(!IsObject(Tab[S_name])) Tab[S_name] = init_Group(S_name)
		}


	SQL  = ""
	SQL += " SELECT"
	SQL += "   K_name  = PNUM.新規名,"
	SQL += "   S_name  = SM.統括+SM.本部+SM.部門,"
	SQL += "   gCode   = BUSYO.部署ID,"
	SQL += "   gName = (SELECT TOP 1 部署名 FROM EMG.dbo.部署マスタ WHERE 部署コード = BUSYO.部署ID ORDER BY 開始 desc),"
	SQL += "   uName   = PNUM.corpName,"
	SQL += "   level   = PNUM.fix_level,"
	SQL += "   EMG     = RTRIM(DATA.会社名),"
	SQL += "   yymm    = DATA.yymm,"
	SQL += "   kind    = '0',"
	SQL += "   amount  = sum(DATA.金額)"
	SQL += " FROM"
	SQL += "	  ((営業売上データ DATA LEFT JOIN 業務部署データ     BUSYO ON DATA.pNum    = BUSYO.pNum)"
	SQL += "		                    LEFT JOIN projectNum         PNUM  ON DATA.pNum    = PNUM.pNum)"
	SQL += "                            LEFT JOIN (SELECT * FROM 統括本部マスタ     WHERE 開始 <= '" + e_yymm + "' and 終了 > '" + s_yymm + "' AND 直間 IN(0,1) ) SM ON BUSYO.部署ID = SM.部署ID"
	SQL += "		                    LEFT JOIN EMG.dbo.部署マスタ BMAST ON BUSYO.部署ID = BMAST.部署コード"
	SQL += " WHERE"
	SQL += "	  DATA.付替 IN(0,1,2)"						// 付替データを有効とする
	SQL += "	  AND"
	SQL += "	  DATA.Flag = 0"
	SQL += "	  AND"
	SQL += "      (DATA.yymm BETWEEN " + s_yymm + " and " + e_yymm + ")"
	SQL += "	  AND"
	SQL += "	  (DATA.yymm Between BUSYO.開始 And BUSYO.終了)"
//	SQL += "	  AND"
//	SQL += "	  (DATA.yymm Between SM.開始 And SM.終了)"
	SQL += " GROUP BY"
	SQL += "      PNUM.新規名,"
	SQL += "      SM.統括+SM.本部+SM.部門,"
	SQL += "      BUSYO.部署ID,"
	SQL +=" 	  PNUM.corpName,"
	SQL += "	  PNUM.fix_level,"
	SQL += "      DATA.会社名,"
	SQL += "	  DATA.yymm"

	SQL +=" ORDER BY"
	SQL +=" 	  PNUM.corpName"

	RS.Open(SQL, DB, 0, 1)

	while( !RS.EOF ){
		S_name	= RS.Fields('K_name').Value
		gCode	= RS.Fields('gCode').Value
		gName	= RS.Fields('gName').Value
		uName	= RS.Fields('uName').Value
		c_yymm	= RS.Fields('yymm').Value
		level	= RS.Fields('level').Value
		kind	= RS.Fields('kind').Value
		amount	= RS.Fields('amount').Value
		EMG 	= RS.Fields('EMG').Value

		uName = (uName == null ? "客先名不明" : uName)

		if( S_name == null ){
			S_name = gName + "(" + gCode + ")"
			}

		if( !IsObject(KTab[S_name]) ) S_name = "指定なし"
		if(!IsObject(Tab[S_name])) Tab[S_name] = init_Group(S_name)

		m = yymmDiff(yymm,c_yymm)
//		if( ( m <  actualCnt && kind == 0 ) || ( m >= actualCnt && kind == 1 && level >= 70) ){
		if( ( m <  actualCnt && kind == 0 ) || ( m >= actualCnt && kind == 1 ) ){
			if( !IsObject(Tab[S_name].uName[uName]) ){
				Tab[S_name].uName[uName] = {EMG:EMG,data:""}
				Tab[S_name].uName[uName]["data"] = init_userName(dispCnt)
//			  Tab[gCode].uName[uName] = init_userName(dispCnt)
				}
			if( EMG != "-" ) Tab[S_name].uName[uName]["EMG"] = EMG
			Tab[S_name].uName[uName]["data"][m] += amount = parseInt(amount)
			}
		RS.MoveNext();
		}
	RS.Close()

	SQL  = ""
	SQL += " SELECT"
	SQL += "      K_name  = PNUM.新規名,"
	SQL += "      S_name  = SM.統括+SM.本部+SM.部門,"
	SQL += "      gCode  = BUSYO.部署ID,"
	SQL += "      gName = (SELECT TOP 1 部署名 FROM EMG.dbo.部署マスタ WHERE 部署コード = BUSYO.部署ID ORDER BY 開始 desc),"
	SQL += "      uName  = PNUM.corpName,"
	SQL += "	  level  = PNUM.fix_level,"
	SQL += "      EMG    = '-',"
	SQL += "	  yymm   = DATA.yymm,"
	SQL += "	  kind   = '1',"
	SQL += "	  amount = sum(DATA.sales) * 1000"
	SQL += " FROM"
	SQL += "	  ((営業予測データ DATA LEFT JOIN 業務部署データ     BUSYO ON DATA.pNum    = BUSYO.pNum)"
	SQL += "	                        LEFT JOIN projectNum         PNUM  ON DATA.pNum    = PNUM.pNum)"
	SQL += "                            LEFT JOIN (SELECT * FROM 統括本部マスタ     WHERE 開始 <= '" + e_yymm + "' and 終了 > '" + s_yymm + "' AND 直間 IN(0,1) ) SM ON BUSYO.部署ID = SM.部署ID"
	SQL += "	                        LEFT JOIN EMG.dbo.部署マスタ BMAST ON BUSYO.部署ID = BMAST.部署コード"
	
	SQL += " WHERE"
	SQL += "	  PNUM.stat IN(0,1,4,5) and PNUM.fix_level >= " + fixLevel
	SQL += "	  AND"
	SQL += "      (DATA.yymm BETWEEN " + s_yymm + " and " + e_yymm + ")"
	SQL += "	  AND"
	SQL += "	  (DATA.yymm Between BUSYO.開始 And BUSYO.終了)"
//	SQL += "	  AND"
//	SQL += "	  (DATA.yymm Between SM.開始 And SM.終了)"

	SQL += " GROUP BY"
	SQL += "      PNUM.新規名,"
	SQL += "      SM.統括+SM.本部+SM.部門,"
	SQL += "      BUSYO.部署ID,"
	SQL +=" 	  PNUM.corpName,"
	SQL += "      PNUM.fix_level,"
	SQL += "      EMG,"
	SQL += "      DATA.yymm"

	SQL +=" ORDER BY"
	SQL +=" 	  PNUM.corpName"

	RS.Open(SQL, DB, 0, 1)

	while( !RS.EOF ){
		S_name	= RS.Fields('K_name').Value
		gCode	= RS.Fields('gCode').Value
		gName	= RS.Fields('gName').Value
		uName	= RS.Fields('uName').Value
		c_yymm	= RS.Fields('yymm').Value
		level	= RS.Fields('level').Value
		kind	= RS.Fields('kind').Value
		amount	= RS.Fields('amount').Value
		EMG 	= RS.Fields('EMG').Value

		uName = (uName == null ? "客先名不明" : uName)

		if( S_name == null ){
//			S_name = gName + "(" + gCode + ")"
			S_name = "指定なし"
			}

		if(!IsObject(Tab[S_name])) Tab[S_name] = init_Group(S_name)

		m = yymmDiff(yymm,c_yymm)
//		if( ( m <  actualCnt && kind == 0 ) || ( m >= actualCnt && kind == 1 && level >= 70) ){
		if( ( m <  actualCnt && kind == 0 ) || ( m >= actualCnt && kind == 1 ) ){
			if( !IsObject(Tab[S_name].uName[uName]) ){
				Tab[S_name].uName[uName] = {EMG:EMG,data:""}
				Tab[S_name].uName[uName]["data"] = init_userName(dispCnt)
//			  Tab[gCode].uName[uName] = init_userName(dispCnt)
				}
			if( EMG != "-" ) Tab[S_name].uName[uName]["EMG"] = EMG
			Tab[S_name].uName[uName]["data"][m] += amount = parseInt(amount)
			}
		RS.MoveNext();
		}
	RS.Close()

	}


%>

<html>

<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=SHIFT_JIS">
<META http-equiv="X-UA-Compatible" content="IE=5" />

<title>売上予測・実績一覧（分類別）</title>

<LINK rel="stylesheet" href="main.css" type="text/css">
<STYLE TYPE="text/css">
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
</STYLE>

<SCRIPT LANGUAGE="JavaScript">
var limitYear = <%=limitYear%>
var year	  = <%=year%>
var dispCnt   = <%=dispCnt%>
var fixLevel	= <%=fixLevel%>
</SCRIPT>

<SCRIPT FOR="window" EVENT="onload" Language="JavaScript">
var yymm = (year-1)*100 + 10
mainTitle.innerHTML = String(year + "年度　売上実績+予測（新規別）").big()
subTitle.innerHTML = "(" + strMonth(yymm) + "～" + strMonth(yymmAdd(yymm,dispCnt-1)) + ")"

if(year > limitYear ){
   prev.style.display=""
   }
next.style.display=""

var o = document.getElementsByName("level")
for( var i = 0; i < o.length; i++ ){
	if(o[i].value == fixLevel) o[i].checked = true
	}

window.focus()
</SCRIPT>

<SCRIPT FOR="window" EVENT="onunload" LANGUAGE="JavaScript">
winClose()
</SCRIPT>


<SCRIPT FOR="level" EVENT="onclick" LANGUAGE="JavaScript">
mainTitle.style.color = "tomato"
//this.parentElement.style.color = "tomato"

fixLevel = this.value
var para = ""
para += "?year="   + year
para += "&fix="    + fixLevel
window.location.replace(window.location.pathname + para )
</SCRIPT>


<SCRIPT FOR="prev" EVENT="onclick" LANGUAGE="JavaScript">
mainTitle.style.color = "tomato"

year = parseInt(year) - 1
var para = ""
para += "?year="   + year
para += "&fix="    + fixLevel
window.location.replace(window.location.pathname + para )
</SCRIPT>
<SCRIPT FOR="next" EVENT="onclick" LANGUAGE="JavaScript">
mainTitle.style.color = "tomato"

year = parseInt(year) + 1
var para = ""
para += "?year="   + year
para += "&fix="    + fixLevel
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

<SCRIPT FOR="onDisp" EVENT="onclick" LANGUAGE="JavaScript">
//alert("更新中です、しばらくお待ちください" + "][" + this.gName)
winOpen(this.gName,this.yymm,this.dispCnt,this.actualCnt)
</SCRIPT>
<SCRIPT FOR="onDisp" EVENT="onmouseover" LANGUAGE="JavaScript">
this.style.cursor = "hand"
//this.style.color="red"
</SCRIPT>
<SCRIPT FOR="onDisp" EVENT="onmouseout" LANGUAGE="JavaScript">
this.style.cursor = ""
//this.style.color="black"
</SCRIPT>

<SCRIPT LANGUAGE="JavaScript">
var newWin = null;
function winOpen(kind,yymm,dispCnt,actualCnt)
   {
	var aspName = "グループ予実_分類.asp"
	var mode = "新規名"
   var para
   para  = "?mode="	     + mode
   para += "&kind=" 	 + kind
   para += "&yymm=" 	 + yymm
   para += "&dispCnt="	 + dispCnt
   para += "&actualCnt=" + actualCnt
   para += "&fix="		 + fixLevel
   newWin = window.open(aspName+para,"uriageWin","width=800,height=700,scrollbars,resizable,status=no");
   }
   
function winClose()
   {
   if(newWin != null && !newWin.closed) newWin.close();
   }
</SCRIPT>

<SCRIPT LANGUAGE="JavaScript" src="cmn.js"></SCRIPT>
<SCRIPT LANGUAGE="VBScript"   src="cmn.vbs"></SCRIPT>

</HEAD>

<body background="bg00.gif">

	<table ALIGN="center">
		<TR>
			<td>
			<fieldset>
			<legend></legend>
				<table>
				<caption ><SPAN style="white-space:nowrap" id="mainTitle">　</SPAN></caption>
				<tr>
					<td>
					<TABLE ALIGN="center" ID="Table2">
						<TR>
						<TD ALIGN="left"><INPUT type="radio" id="level" name="level" value="70">Ａ</TD>
						<TD ALIGN="left"><INPUT type="radio" id="level" name="level" value="50">Ｂ</TD>
						<TD ALIGN="left"><INPUT type="radio" id="level" name="level" value="30">Ｃ</TD>
						<TD ALIGN="left"><INPUT type="radio" id="level" name="level" value="10">Ｄ</TD>
						</TR>
					</TABLE>
					</td>
				</tr>
				<tr>
					<td>
					<TABLE ALIGN="center">
						<TR>
						<TD ALIGN="LEFT"><IMG SRC="arrow_l1.gif" id="prev" border="0" TITLE="前の期" STYLE="display=none"></TD>
						<TD ALIGN="CENTER"><SPAN ID="subTitle">　</SPAN></TD>
						<TD ALIGN="RIGHT"><IMG SRC="arrow_r1.gif" id="next" border="0" TITLE="次の期" STYLE="display=none"></TD>
						</TR>
					</TABLE>

					</td>
				</tr>
				</table>
			</fieldset>
			</td>
		</TR>
		<TR>
			<td>
			<%main(year,dispCnt,fixLevel)%>
			</td>
		</TR>
	</table>
	<table>
		<tr><td ALIGN='LEFT'>予測データの確度は<%=fixLevel%>%以上</td></tr>
		<tr><td ALIGN='LEFT'>客先名はプロジェクト引合表で登録した名前です</td></tr>
	</table>

</body>
</html>

