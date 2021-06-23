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


//	70�����\���������Ƃ��̂��߂̏���
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

   year = yy + (mm >= 10 ? 1 : 0)			  // 10���ȍ~�͎��N�x��\��
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
	var yymm = yy * 100 + mm						// ������yymm

	var OKday = dayChk(d,adjustDayCnt)
	yymm = ( parseInt(dd) < parseInt(OKday) ? yymmAdd(yymm, -1) : yymmAdd(yymm, 0))			// �m����̕␳

	var b_yymm = ((year-1)*100) + 10

	var actualCnt = yymmDiff( b_yymm, yymm )
	
	if(actualMonth >= 0) {
	    actualCnt = actualMonth
	}
  
	var Tab = getUser(DB,b_yymm,dispCnt)
	var Tab = new Object;

	getSalesData(DB,Tab,b_yymm,dispCnt,actualCnt,fixLevel)			 // �\���E����

	DB.Close()

	dispPlan(Tab,b_yymm,dispCnt,actualCnt)
	
	EMGLog.Json("����\��_�V�K.json",Tab);

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
	tableHeadCell("width='20%'","�O���[�v��");
	tableHeadCell("width='20%'","�q�於");
	tableHeadCell("width='90'","���@�v");
	for(i = 0; i < dispCnt; i++) tableHeadCell("width='90'",yymmAdd(s_yymm,i)%100 + "��");
	tableRowEnd();
	tableHeadEnd();
*/

	tableHeadBegin("");
	tableRowBegin("valign='bottom' bordercolor='black' bgcolor='#aac2ea'");
	tableHeadCell("width='80px'","���ޖ�");
	tableHeadCell("width='20%'","�q�於");
	tableHeadCell("width='90'","�@");
	tableHeadCell("colspan='3'" + "width='" + (65*3) + "'",parseInt(s_yymm/100) + "�N");
	tableHeadCell("colspan='9'" + "width='" + (65*9) + "'",parseInt(s_yymm/100)+1 + "�N");
	tableHeadCell("width='90'","�@");
	tableHeadCell("width='20%' colspan='2'","�q�於");
	tableHeadCell("width='80px'","���ޖ�");
	tableRowEnd();
	tableHeadEnd();

	tableBodyBegin("");

	for(var i = 0; i < dispCnt; i++) totalTabG[i] = 0
	//	�O���[�v�P��
	for( var S_name in Tab){
		var userCnt = countArray(Tab[S_name])
		// ���̕\��
		if( userCnt > 0 ){
			var rowSpanCnt = userCnt + 2
			var LineCnt = 0
			tableRowBegin("valign='bottom' bordercolor='gray' bgcolor='lavender'");
			tableDataCell("colspan='2'","�@");
			tableDataCell("align='center'","���@�v");
			for(i = 0; i < dispCnt; i++) tableDataCell("align='center'width='90'",yymmAdd(s_yymm,i)%100 + "��");
			tableDataCell("align='center'","���@�v");
			tableDataCell("colspan='3'","�@");
			tableRowEnd();

			// �q��P��
			for( var uName in Tab[S_name].uName){
			// 1�s�f�[�^�\���J�n ==================
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
// ���̏��
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
				// �f�[�^�\���I�� ==================

				LineCnt++
				}

			tableRowBegin("");
			tableDataCell("ALIGN='CENTER' class='secTotal' colspan='1'" , "���@�v" );

			for( var i = 0,value = 0; i < dispCnt; i++) value += totalTab[i]
			dispStr = (value == 0 ? "" : formatNum(value,0) )
			tableDataCell("ALIGN='RIGHT' class='quarter'" , dispStr );
			for( var i = 0; i < dispCnt; i++){
				memo = "[ " + strMonth(yymmAdd(yymm,i)) + " ] " + Tab[S_name].gName
				value = totalTab[i]
				tableDataCell("ALIGN='RIGHT' class='secTotal' title='" + memo + "'", formatNum(value,0) )
				}
			tableDataCell("ALIGN='RIGHT' class='quarter'" , dispStr );
			tableDataCell("ALIGN='CENTER' class='secTotal' colspan='2'" , "���@�v" );
			tableRowEnd();

			tableRowBegin("");
			tableDataCell("ALIGN='CENTER' class='allTotal' colspan='1'" , "�݁@�v" );
			tableDataCell("ALIGN='CENTER' class='allTotal' colspan='1'" , "�@" );
			rTotal = 0
			for( var i = 0; i < dispCnt; i++){
				memo = "[ " + strMonth(yymmAdd(yymm,i)) + " ] " + Tab[S_name].gName
				rTotal += totalTab[i]
				tableDataCell("ALIGN='RIGHT' class='allTotal' title='" + memo + "'", formatNum(rTotal,0) )
				}
			tableDataCell("ALIGN='CENTER' class='allTotal' colspan='1'" , "" );
			tableDataCell("ALIGN='CENTER' class='allTotal' colspan='2'" , "�݁@�v" );
			tableRowEnd();

			}// �q��I��
		}// �O���[�v�I��
	tableBodyEnd();


	tableFootBegin("")
	tableRowBegin("valign='bottom'  bordercolor='black' bgcolor='#aac2ea'");
	tableHeadCell("colspan='2'","�@");
	tableHeadCell("","���@�v");
	for(i = 0; i < dispCnt; i++) tableHeadCell("width='90'",yymmAdd(s_yymm,i)%100 + "��");
	tableHeadCell("","���@�v");
	tableHeadCell("colspan='3'","�@");
	tableRowEnd();

	tableRowBegin("");
	tableDataCell("ALIGN='CENTER' class='secTotal' COLSPAN='2' nowrap" , "���@���@�v" );

	for( var i = 0,value = 0; i < dispCnt; i++) value += totalTabG[i]
	dispStr = (value == 0 ? "" : formatNum(value,0) )
	tableDataCell("ALIGN='RIGHT' class='quarter'" , dispStr );
	for( var i = 0; i < dispCnt; i++){
		value = totalTabG[i]
		tableDataCell("ALIGN='RIGHT' class='secTotal'", formatNum(value,0) )
		}
	tableDataCell("ALIGN='RIGHT' class='quarter'" , dispStr );
	tableDataCell("ALIGN='CENTER' class='secTotal' COLSPAN='3' nowrap" , "���@���@�v" );
	tableRowEnd();

	tableRowBegin("");
	tableDataCell("ALIGN='CENTER' class='allTotal' COLSPAN='2' nowrap" , "���@�݁@�v" );
	tableDataCell("ALIGN='CENTER' class='allTotal' COLSPAN='1'" , "�@" );
	rTotal = 0
	for( var i = 0; i < dispCnt; i++){
		rTotal += totalTabG[i]
		tableDataCell("ALIGN='RIGHT' class='allTotal'", formatNum(rTotal,0) )
		}
	tableDataCell("ALIGN='CENTER' class='allTotal' COLSPAN='1'" , "�@" );
	tableDataCell("ALIGN='CENTER' class='allTotal' COLSPAN='3' nowrap" , "���@�݁@�v" );
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
	var x_yymm = yymmAdd(e_yymm,1)				  // ���̌�
	var sDate = parseInt(s_yymm / 100) + "/" + (s_yymm%100) + "/1"
	var eDate = parseInt(x_yymm / 100) + "/" + (x_yymm%100) + "/1"

	var RS = Server.CreateObject("ADODB.Recordset")

	var gCode,gName,value,uName
	var Tab = new Object

//=================================================================
	SQL  = " SELECT"
	SQL += "     S_name = SM.����+SM.�{��+SM.����"
	SQL += " FROM"
	SQL += "     �����{���}�X�^ SM"
	SQL += " WHERE"
	SQL += "     SM.�J�n <  '" + e_yymm + "'"
	SQL += "     and"
	SQL += "     SM.�I�� >= '" + s_yymm + "'"
	SQL += " ORDER BY"
	SQL += "     SM.����,"
	SQL += "     S_name"
	RS.Open(SQL, DB, 0, 1)

	while( !RS.EOF ){
		S_name = RS.Fields('S_name').Value
		Tab[S_name] = init_Group(S_name)

		RS.MoveNext();
		}
	RS.Close()
// ���̑�
   Tab["�Ԑ�"] = init_Group("�Ԑ�")
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



	var KTab = {"�V�K�ڋq":"","�V�K���ƕ�":"","�V�K����":"","�p���Č�":""}
//	var KTab = {"�V�K�ڋq":"","�V�K���ƕ�":"","�V�K����":""}
	for( var S_name in KTab ){
		if(!IsObject(Tab[S_name])) Tab[S_name] = init_Group(S_name)
		}


	SQL  = ""
	SQL += " SELECT"
	SQL += "   K_name  = PNUM.�V�K��,"
	SQL += "   S_name  = SM.����+SM.�{��+SM.����,"
	SQL += "   gCode   = BUSYO.����ID,"
	SQL += "   gName = (SELECT TOP 1 ������ FROM EMG.dbo.�����}�X�^ WHERE �����R�[�h = BUSYO.����ID ORDER BY �J�n desc),"
	SQL += "   uName   = PNUM.corpName,"
	SQL += "   level   = PNUM.fix_level,"
	SQL += "   EMG     = RTRIM(DATA.��Ж�),"
	SQL += "   yymm    = DATA.yymm,"
	SQL += "   kind    = '0',"
	SQL += "   amount  = sum(DATA.���z)"
	SQL += " FROM"
	SQL += "	  ((�c�Ɣ���f�[�^ DATA LEFT JOIN �Ɩ������f�[�^     BUSYO ON DATA.pNum    = BUSYO.pNum)"
	SQL += "		                    LEFT JOIN projectNum         PNUM  ON DATA.pNum    = PNUM.pNum)"
	SQL += "                            LEFT JOIN (SELECT * FROM �����{���}�X�^     WHERE �J�n <= '" + e_yymm + "' and �I�� > '" + s_yymm + "' AND ���� IN(0,1) ) SM ON BUSYO.����ID = SM.����ID"
	SQL += "		                    LEFT JOIN EMG.dbo.�����}�X�^ BMAST ON BUSYO.����ID = BMAST.�����R�[�h"
	SQL += " WHERE"
	SQL += "	  DATA.�t�� IN(0,1,2)"						// �t�փf�[�^��L���Ƃ���
	SQL += "	  AND"
	SQL += "	  DATA.Flag = 0"
	SQL += "	  AND"
	SQL += "      (DATA.yymm BETWEEN " + s_yymm + " and " + e_yymm + ")"
	SQL += "	  AND"
	SQL += "	  (DATA.yymm Between BUSYO.�J�n And BUSYO.�I��)"
//	SQL += "	  AND"
//	SQL += "	  (DATA.yymm Between SM.�J�n And SM.�I��)"
	SQL += " GROUP BY"
	SQL += "      PNUM.�V�K��,"
	SQL += "      SM.����+SM.�{��+SM.����,"
	SQL += "      BUSYO.����ID,"
	SQL +=" 	  PNUM.corpName,"
	SQL += "	  PNUM.fix_level,"
	SQL += "      DATA.��Ж�,"
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

		uName = (uName == null ? "�q�於�s��" : uName)

		if( S_name == null ){
			S_name = gName + "(" + gCode + ")"
			}

		if( !IsObject(KTab[S_name]) ) S_name = "�w��Ȃ�"
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
	SQL += "      K_name  = PNUM.�V�K��,"
	SQL += "      S_name  = SM.����+SM.�{��+SM.����,"
	SQL += "      gCode  = BUSYO.����ID,"
	SQL += "      gName = (SELECT TOP 1 ������ FROM EMG.dbo.�����}�X�^ WHERE �����R�[�h = BUSYO.����ID ORDER BY �J�n desc),"
	SQL += "      uName  = PNUM.corpName,"
	SQL += "	  level  = PNUM.fix_level,"
	SQL += "      EMG    = '-',"
	SQL += "	  yymm   = DATA.yymm,"
	SQL += "	  kind   = '1',"
	SQL += "	  amount = sum(DATA.sales) * 1000"
	SQL += " FROM"
	SQL += "	  ((�c�Ɨ\���f�[�^ DATA LEFT JOIN �Ɩ������f�[�^     BUSYO ON DATA.pNum    = BUSYO.pNum)"
	SQL += "	                        LEFT JOIN projectNum         PNUM  ON DATA.pNum    = PNUM.pNum)"
	SQL += "                            LEFT JOIN (SELECT * FROM �����{���}�X�^     WHERE �J�n <= '" + e_yymm + "' and �I�� > '" + s_yymm + "' AND ���� IN(0,1) ) SM ON BUSYO.����ID = SM.����ID"
	SQL += "	                        LEFT JOIN EMG.dbo.�����}�X�^ BMAST ON BUSYO.����ID = BMAST.�����R�[�h"
	
	SQL += " WHERE"
	SQL += "	  PNUM.stat IN(0,1,4,5) and PNUM.fix_level >= " + fixLevel
	SQL += "	  AND"
	SQL += "      (DATA.yymm BETWEEN " + s_yymm + " and " + e_yymm + ")"
	SQL += "	  AND"
	SQL += "	  (DATA.yymm Between BUSYO.�J�n And BUSYO.�I��)"
//	SQL += "	  AND"
//	SQL += "	  (DATA.yymm Between SM.�J�n And SM.�I��)"

	SQL += " GROUP BY"
	SQL += "      PNUM.�V�K��,"
	SQL += "      SM.����+SM.�{��+SM.����,"
	SQL += "      BUSYO.����ID,"
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

		uName = (uName == null ? "�q�於�s��" : uName)

		if( S_name == null ){
//			S_name = gName + "(" + gCode + ")"
			S_name = "�w��Ȃ�"
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

<title>����\���E���шꗗ�i���ޕʁj</title>

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
mainTitle.innerHTML = String(year + "�N�x�@�������+�\���i�V�K�ʁj").big()
subTitle.innerHTML = "(" + strMonth(yymm) + "�`" + strMonth(yymmAdd(yymm,dispCnt-1)) + ")"

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
//alert("�X�V���ł��A���΂炭���҂���������" + "][" + this.gName)
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
	var aspName = "�O���[�v�\��_����.asp"
	var mode = "�V�K��"
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
				<caption ><SPAN style="white-space:nowrap" id="mainTitle">�@</SPAN></caption>
				<tr>
					<td>
					<TABLE ALIGN="center" ID="Table2">
						<TR>
						<TD ALIGN="left"><INPUT type="radio" id="level" name="level" value="70">�`</TD>
						<TD ALIGN="left"><INPUT type="radio" id="level" name="level" value="50">�a</TD>
						<TD ALIGN="left"><INPUT type="radio" id="level" name="level" value="30">�b</TD>
						<TD ALIGN="left"><INPUT type="radio" id="level" name="level" value="10">�c</TD>
						</TR>
					</TABLE>
					</td>
				</tr>
				<tr>
					<td>
					<TABLE ALIGN="center">
						<TR>
						<TD ALIGN="LEFT"><IMG SRC="arrow_l1.gif" id="prev" border="0" TITLE="�O�̊�" STYLE="display=none"></TD>
						<TD ALIGN="CENTER"><SPAN ID="subTitle">�@</SPAN></TD>
						<TD ALIGN="RIGHT"><IMG SRC="arrow_r1.gif" id="next" border="0" TITLE="���̊�" STYLE="display=none"></TD>
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
		<tr><td ALIGN='LEFT'>�\���f�[�^�̊m�x��<%=fixLevel%>%�ȏ�</td></tr>
		<tr><td ALIGN='LEFT'>�q�於�̓v���W�F�N�g�����\�œo�^�������O�ł�</td></tr>
	</table>

</body>
</html>

