<%
	Response.End();
	%>
<%
var limitYear = 2003
var dispCnt = 12
/*
   Session("memberName1") = "����"
   Session("memberName2") = "��"
*/
//======  ======================

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



<html>

<head>
<META http-equiv="Content-Type" content="text/html; charset=SHIFT_JIS">
<META http-equiv="X-UA-Compatible" content="IE=5" />


<title>��p��</title>
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
mainTitle.innerHTML = String(year + "�N�x�@��p��")	//.big().big()
subTitle.innerHTML = "(" + strMonth(yymm) + "�`" + strMonth(yymmAdd(yymm,dispCnt-1)) + ")"

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
			<caption><SPAN id="mainTitle">�@</SPAN></caption>
			<TR>
			   <td>
				  <TABLE ALIGN="center" ID="Table2">
					 <TR>
						<TD ALIGN="LEFT"><IMG SRC="arrow_l1.gif" id="prev" border="0" TITLE="�O�̊�" STYLE="display=none"></TD>
						<TD ALIGN="CENTER"><SPAN ID="subTitle">�@</SPAN></TD>
						<TD ALIGN="RIGHT"><IMG SRC="arrow_r1.gif" id="next" border="0" TITLE="���̊�" STYLE="display=none"></TD>
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
	var yymm = yy * 100 + mm						// ������yymm

	var OKday = dayChk(d,adjustDayCnt)
	yymm = ( parseInt(dd) < parseInt(OKday) ? yymmAdd(yymm, -1) : yymmAdd(yymm, 0))			// �m����̕␳

	var b_yymm = ((year-1)*100) + 10

	var actualCnt = yymmDiff( b_yymm, yymm )
	if(actualCnt >= 12) actualCnt = 12
b_yymm = 201810
actualCnt = 3
	dispPlan( b_yymm,dispCnt,actualCnt)
	}

function dispPlan( b_yymm,dispCnt,actualCnt)
  {
//=== �f�[�^�擾 =======================================================
   var Tab = getUser(b_yymm,dispCnt)						// ���ޖ��쐬
   getActualData(Tab,b_yymm,dispCnt,actualCnt)			// ���уf�[�^�擾
   getPlanData(Tab,b_yymm,dispCnt,actualCnt)				// �v��f�[�^�擾
	getPastData(Tab,b_yymm,dispCnt)							// �ߋ��f�[�^

// ���тƗ\�Z�̃}�[�W�i���т̐��l���Ȃ����͗\�Z���g���j

   for(var item in Tab){
	  for(var kind in Tab[item]){
		 var x = "�v��"
		 for(var m in Tab[item][kind][x]){
			if( m >= actualCnt){
			   Tab[item][kind]["����"][m] = Tab[item][kind]["�v��"][m]
			   }
			}
		 }
	  }
	  
	  EMGLog.Json("��p��.json",Tab);
//=== �f�[�^�\�� =======================================================
   dispUser(Tab,b_yymm,dispCnt,actualCnt)
   
// �̊ǔ�ڍ׃f�[�^�\��
   dispSection(Tab,b_yymm,dispCnt,actualCnt)


   }

//================================================================

function dispUser(Tab,yymm,dispCnt,actualCnt)
   {
   var s_yymm = yymm;
   var e_yymm = yymmAdd(yymm,dispCnt - 1);
   var cur_yymm;

// ����ʏW�v�f�[�^�\��
   tableBegin("width='100%' class='table' BORDER='1' CELLPADDING='2' CELLSPACING='0'");
   tableHeadBegin("");
   tableRowBegin("valign='bottom' bordercolor='black' bgcolor='#aac2ea'");
   tableHeadCell("width='100'","�啪��");
   tableHeadCell("width='100'","����");
   tableHeadCell("colspan='3'" + "width='" + (65*3) + "'",parseInt(s_yymm/100) + "�N");
   tableHeadCell("colspan='9'" + "width='" + (65*9) + "'",parseInt(s_yymm/100)+1 + "�N");

   tableRowEnd();
   tableHeadEnd();

// �S�Ѓf�[�^�v�Z=================================================
// �݌v�f�[�^
   var rTab = new Object()
   makeArray(rTab,dispCnt)

// ���v�f�[�^
   var gTab = new Object()
   makeArray(gTab,dispCnt)

// ���v�f�[�^�v�Z
   var iName = "���㌴��,�̊ǔ�,�c�ƊO��p".split(",")
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
// �݌v�f�[�^�v�Z
   for(var x in gTab){
	  var rValue = 0
	  for(var m in gTab[x]){
		 rValue += gTab[x][m]
		 rTab[[x]][m] = rValue
		 }
	  }

// �S�Ѓf�[�^�\��
   tableBodyBegin("");
   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='xTotal' rowspan='8'", "�d�l�f".big().bold());

   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "��" );
   for(i = 0; i < dispCnt; i++){
	  tableDataCell("class='mounth' width='65'",yymmAdd(s_yymm,i)%100 + "��");
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "�O�N�x����1" );
   for( var i = 0; i < dispCnt; i++){
	  className = "actual"
	  value = gTab["�ߋ�"][i]
	  dispStr = (value == 0 ? "" : formatNum(value/1000,0) )
	  tableDataCell("class='" + className + "'", dispStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "�\�@�Z" );
   for( var i = 0; i < dispCnt; i++){
	  className = "target"
	  value = gTab["�v��"][i]
	  dispStr = (value == 0 ? "" : formatNum(value/1000,0) )
	  tableDataCell("class='" + className + "'", dispStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "���сE�\�Z" );
   for( var i = 0; i < dispCnt; i++){
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  value = gTab["����"][i]
	  dispStr = (value == 0 ? "" : formatNum(value/1000,0) )
	  tableDataCell("class='" + className + "'", dispStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "�݌v[�\�Z] (A)" );
   for( var i = 0; i < dispCnt; i++){
	  className = "secTotal"
	  if( i == 11 ) className = "lastTarget"
	  value = rTab["�v��"][i]
	  tableDataCell("ALIGN='RIGHT' class='" + className + "'", formatNum(value/1000,0) )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "�݌v[���\] (B)" );
   for( var i = 0; i < dispCnt; i++){
	  className = "secTotal"
	  value = rTab["����"][i]
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  tableDataCell("ALIGN='RIGHT' class='" + className + "'", formatNum(value/1000,0) )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "�� (B/A)" );
   for( var i = 0; i < dispCnt; i++){
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  value = rTab["����"][i] / rTab["�v��"][i]
	  dispStr = (rTab["�v��"][i] > 0 ? formatNum(value*100,1).bold() + " %" : "-")
	  tableDataCell("ALIGN='RIGHT' class='" + className + "' nowrap", dispStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' class='secTotal'" , "�� (A-B)" );
   for( var i = 0; i < dispCnt; i++){
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  value = -(rTab["����"][i] - rTab["�v��"][i])
	  dispStr = formatNum(value/1000,0)
	  dispStr = (value >= 0 ? dispStr.fontcolor("black") : dispStr.fontcolor("tomato") )
	  tableDataCell("nowrap class='" + className + "'", dispStr )
	  }
   tableRowEnd();
   tableBodyEnd();
// �S�Ѓf�[�^�\���I�� ==================


// ���㌴���f�[�^�v�Z=================================================
// �݌v�f�[�^
   var rTab = new Object()
   makeArray(rTab,dispCnt)

// ���v�f�[�^
   var gTab = new Object()
   makeArray(gTab,dispCnt)

// ���v�f�[�^�v�Z
   var iName = "���㌴��".split(",")
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
// �݌v�f�[�^�v�Z
   for(var x in gTab){
	  var rValue = 0
	  for(var m in gTab[x]){
		 rValue += gTab[x][m]
		 rTab[[x]][m] = rValue
		 }
	  }

// �S�Ѓf�[�^�\��
   tableBodyBegin("");
   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='groupType' rowspan='8'", "���㌴��");

   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "��" );
   for(i = 0; i < dispCnt; i++){
	  tableDataCell("class='mounth' width='65'",yymmAdd(s_yymm,i)%100 + "��");
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "�O�N�x����2" );
   for( var i = 0; i < dispCnt; i++){
	  className = "actual"
	  value = gTab["�ߋ�"][i]
	  dispStr = (value == 0 ? "" : formatNum(value/1000,0) )
	  tableDataCell("class='" + className + "'", dispStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "�\�@�Z" );
   for( var i = 0; i < dispCnt; i++){
	  className = "target"
	  value = gTab["�v��"][i]
	  dispStr = (value == 0 ? "" : formatNum(value/1000,0) )
	  tableDataCell("class='" + className + "'", dispStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "���сE�\�Z" );
   for( var i = 0; i < dispCnt; i++){
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  value = gTab["����"][i]
	  dispStr = (value == 0 ? "" : formatNum(value/1000,0) )
	  tableDataCell("class='" + className + "'", dispStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "�݌v[�\�Z] (A)" );
   for( var i = 0; i < dispCnt; i++){
	  className = "secTotal"
	  value = rTab["�v��"][i]
	  tableDataCell("ALIGN='RIGHT' nowrap class='" + className + "'", formatNum(value/1000,0) )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "�݌v[���\] (B)" );
   for( var i = 0; i < dispCnt; i++){
	  className = "secTotal"
	  value = rTab["����"][i]
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  tableDataCell("ALIGN='RIGHT' class='" + className + "'", formatNum(value/1000,0) )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "�� (B/A)" );
   for( var i = 0; i < dispCnt; i++){
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  value = rTab["����"][i] / rTab["�v��"][i]
	  dispStr = (rTab["�v��"][i] > 0 ? formatNum(value*100,1).bold() + " %" : "-")
	  tableDataCell("ALIGN='RIGHT' class='" + className + "' nowrap", dispStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "�� (A-B)" );
   for( var i = 0; i < dispCnt; i++){
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  value = -(rTab["����"][i] - rTab["�v��"][i])
	  dispStr = formatNum(value/1000,0)
	  dispStr = (value >= 0 ? dispStr.fontcolor("black") : dispStr.fontcolor("tomato") )
	  tableDataCell("nowrap class='" + className + "'", dispStr )
	  }
   tableRowEnd();
   tableBodyEnd();
// ���㌴���f�[�^�\���I�� ==================

// �̊ǔ�f�[�^�v�Z=================================================
// �݌v�f�[�^
   var rTab = new Object()
   makeArray(rTab,dispCnt)

// ���v�f�[�^
   var gTab = new Object()
   makeArray(gTab,dispCnt)

// ���v�f�[�^�v�Z
   var iName = "�̊ǔ�".split(",")
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
// �݌v�f�[�^�v�Z
   for(var x in gTab){
	  var rValue = 0
	  for(var m in gTab[x]){
		 rValue += gTab[x][m]
		 rTab[[x]][m] = rValue
		 }
	  }

// �S�Ѓf�[�^�\��
   tableBodyBegin("");
   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='groupType' rowspan='8'", "�̊ǔ�");

   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "��" );
   for(i = 0; i < dispCnt; i++){
	  tableDataCell("class='mounth' width='65'",yymmAdd(s_yymm,i)%100 + "��");
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "�O�N�x����3" );
   for( var i = 0; i < dispCnt; i++){
	  className = "actual"
	  value = gTab["�ߋ�"][i]
	  dispStr = (value == 0 ? "" : formatNum(value/1000,0) )
	  tableDataCell("class='" + className + "'", dispStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "�\�@�Z" );
   for( var i = 0; i < dispCnt; i++){
	  className = "target"
	  value = gTab["�v��"][i]
	  dispStr = (value == 0 ? "" : formatNum(value/1000,0) )
	  tableDataCell("class='" + className + "'", dispStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "���сE�\�Z" );
   for( var i = 0; i < dispCnt; i++){
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  value = gTab["����"][i]
	  dispStr = (value == 0 ? "" : formatNum(value/1000,0) )
	  tableDataCell("class='" + className + "'", dispStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "�݌v[�\�Z] (A)" );
   for( var i = 0; i < dispCnt; i++){
	  className = "secTotal"
	  value = rTab["�v��"][i]
	  tableDataCell("ALIGN='RIGHT' class='" + className + "'", formatNum(value/1000,0) )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "�݌v[���\] (B)" );
   for( var i = 0; i < dispCnt; i++){
	  className = "secTotal"
	  value = rTab["����"][i]
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  tableDataCell("ALIGN='RIGHT' class='" + className + "'", formatNum(value/1000,0) )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "�� (B/A)" );
   for( var i = 0; i < dispCnt; i++){
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  value = rTab["����"][i] / rTab["�v��"][i]
	  dispStr = (rTab["�v��"][i] > 0 ? formatNum(value*100,1).bold() + " %" : "-")
	  tableDataCell("ALIGN='RIGHT' class='" + className + "' nowrap", dispStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "�� (A-B)" );
   for( var i = 0; i < dispCnt; i++){
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  value = -(rTab["����"][i] - rTab["�v��"][i])
	  dispStr = formatNum(value/1000,0)
	  dispStr = (value >= 0 ? dispStr.fontcolor("black") : dispStr.fontcolor("tomato") )
	  tableDataCell("nowrap class='" + className + "'", dispStr )
	  }
   tableRowEnd();
   tableBodyEnd();
// �̊ǔ�f�[�^�\���I�� ==================

// �c�ƊO��p�f�[�^�v�Z=================================================
// �݌v�f�[�^
   var rTab = new Object()
   makeArray(rTab,dispCnt)

// ���v�f�[�^
   var gTab = new Object()
   makeArray(gTab,dispCnt)

// ���v�f�[�^�v�Z
   var iName = "�c�ƊO��p".split(",")
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
// �݌v�f�[�^�v�Z
   for(var x in gTab){
	  var rValue = 0
	  for(var m in gTab[x]){
		 rValue += gTab[x][m]
		 rTab[[x]][m] = rValue
		 }
	  }

// �S�Ѓf�[�^�\��
   tableBodyBegin("");
   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='groupType' rowspan='8'", "�c�ƊO��p");

   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "��" );
   for(i = 0; i < dispCnt; i++){
	  tableDataCell("class='mounth' width='65'",yymmAdd(s_yymm,i)%100 + "��");
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "�O�N�x����4" );
   for( var i = 0; i < dispCnt; i++){
	  className = "actual"
	  value = gTab["�ߋ�"][i]
	  dispStr = (value == 0 ? "" : formatNum(value/1000,0) )
	  tableDataCell("class='" + className + "'", dispStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "�\�@�Z" );
   for( var i = 0; i < dispCnt; i++){
	  className = "target"
	  value = gTab["�v��"][i]
	  dispStr = (value == 0 ? "" : formatNum(value/1000,0) )
	  tableDataCell("class='" + className + "'", dispStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "���сE�\�Z" );
   for( var i = 0; i < dispCnt; i++){
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  value = gTab["����"][i]
	  dispStr = (value == 0 ? "" : formatNum(value/1000,0) )
	  tableDataCell("class='" + className + "'", dispStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "�݌v[�\�Z] (A)" );
   for( var i = 0; i < dispCnt; i++){
	  className = "secTotal"
	  value = rTab["�v��"][i]
	  tableDataCell("ALIGN='RIGHT' class='" + className + "'", formatNum(value/1000,0) )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "�݌v[���\] (B)" );
   for( var i = 0; i < dispCnt; i++){
	  className = "secTotal"
	  value = rTab["����"][i]
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  tableDataCell("ALIGN='RIGHT' class='" + className + "'", formatNum(value/1000,0) )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "�� (B/A)" );
   for( var i = 0; i < dispCnt; i++){
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  value = rTab["����"][i] / rTab["�v��"][i]
	  dispStr = (rTab["�v��"][i] > 0 ? formatNum(value*100,1).bold() + " %" : "-")
	  tableDataCell("ALIGN='RIGHT' class='" + className + "' nowrap", dispStr )
	  }
   tableRowEnd();

   tableRowBegin("");
   tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "�� (A-B)" );
   for( var i = 0; i < dispCnt; i++){
	  className = ( i < actualCnt ? "actual" : "yosoku")
	  value = -(rTab["����"][i] - rTab["�v��"][i])
	  dispStr = formatNum(value/1000,0)
	  dispStr = (value >= 0 ? dispStr.fontcolor("black") : dispStr.fontcolor("tomato") )
	  tableDataCell("nowrap class='" + className + "'", dispStr )
	  }
   tableRowEnd();
   tableBodyEnd();
// �c�ƊO��p�f�[�^�\���I�� ==================

   tableEnd();
   }

function dispSection(Tab,s_yymm,dispCnt,actualCnt)
   {
   var sectionName = "�̊ǔ�"
   var nameTab = "�l����,�G��<BR>(�A���o�C�g),�L�����۔�,�����ʔ�,�ʐM��,�ב�������,���i�E�}�V��,�}�V��(�Œ莑�Y),�ݔ��E���[�X��,�ƒ���,���̑�,�d�l�f�Ԕ�p".split(",")
   var itemTab = "�l����,�G��,�L������,��ʔ�,�ʐM��,������,���i,�Œ莑�Y,�ݔ���,�ƒ�,���̑�,EMG�Ԕ�p".split(",")
   var nameTab = "�l����,�G��<BR>(�A���o�C�g),�L�����۔�,�����ʔ�,�ʐM��,�ב�������,���i�E�}�V��,�ݔ��E���[�X��,�ƒ���,���̑�,�d�l�f�Ԕ�p".split(",")
   var itemTab = "�l����,�G��,�L������,��ʔ�,�ʐM��,������,���i,�ݔ���,�ƒ�,���̑�,EMG�Ԕ�p".split(",")
   
   tableBegin("width='100%' class='table' BORDER='1' CELLPADDING='2' CELLSPACING='0'");
   tableCaption("align='CENTER'", sectionName.big() );

   tableHeadBegin("");
   tableRowBegin("valign='bottom' bordercolor='black' bgcolor='#aac2ea'");
   tableHeadCell("width='100'","���@��");
   tableHeadCell("width='100'","���@��");
   tableHeadCell("colspan='3'" + "width='" + (65*3) + "'",parseInt(s_yymm/100) + "�N");
   tableHeadCell("colspan='9'" + "width='" + (65*9) + "'",parseInt(s_yymm/100)+1 + "�N");

   tableRowEnd();
   tableHeadEnd();

   tableBodyBegin("");


// �e���ރf�[�^�\��
   var item = sectionName
   for( var kNum in itemTab){
	  var kind = itemTab[kNum]

	  var name = nameTab[kNum]
	  var gTab = Tab[item][kind]

// �݌v�f�[�^�v�Z
   // �݌v�f�[�^
	  var rTab = new Object()
	  makeArray(rTab,dispCnt)

	  for(var x in gTab){
		 var rValue = 0
		 for(var m in gTab[x]){
			rValue += gTab[x][m]
			rTab[[x]][m] = rValue
			}
		 }

	  // ���ޕ\���J�n ==================
	  tableRowBegin("");
	  var dispInfo
	  dispInfo	= "ID='onDisp1'"
	  dispInfo += "Group='" 	+ kind + "'"
	  dispInfo += "yymm='"		+ s_yymm + "'"
	  dispInfo += "dispCnt='"	+ dispCnt + "'"
	  dispInfo += "actualCnt='" + actualCnt + "'"
	  dispInfo += "style='cursor:hand;'"
	  dispInfo = ""					// �����ɂ���
	  tableDataCell("ALIGN='CENTER' nowrap class='groupType' rowspan='8'" + dispInfo,name);

	  tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "��" );
	  for(i = 0; i < dispCnt; i++){
		 tableDataCell("class='mounth' width='65'",yymmAdd(s_yymm,i)%100 + "��");
		 }
	  tableRowEnd();

	  tableRowBegin("");
	  tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "�O�N�x����5" );
	  for( var i = 0; i < dispCnt; i++){
		 className = "actual"
		 value = gTab["�ߋ�"][i]
		 dispStr = (value == 0 ? "" : formatNum(value/1000,0) )
		 tableDataCell("class='" + className + "'", dispStr )
		 }
	  tableRowEnd();

	  tableRowBegin("");
	  tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "�\�@�Z" );
	  for( var i = 0; i < dispCnt; i++){
		 className = "target"
		 value = gTab["�v��"][i]
		 dispStr = (value == 0 ? "" : formatNum(value/1000,0) )
		 tableDataCell("class='" + className + "'", dispStr )
		 }
	  tableRowEnd();

	  tableRowBegin("");
	  tableDataCell("ALIGN='CENTER' nowrap class='userType'" , "���сE�\�Z" );
	  for( var i = 0; i < dispCnt; i++){
		 className = ( i < actualCnt ? "actual" : "yosoku")
		 value = gTab["����"][i]
		 dispStr = (value == 0 ? "" : formatNum(value/1000,0) )
		 tableDataCell("class='" + className + "'", dispStr )
		 }
	  tableRowEnd();

	  tableRowBegin("");
	  tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "�݌v[�\�Z] (A)" );
	  for( var i = 0; i < dispCnt; i++){
		 className = "secTotal"
		 value = rTab["�v��"][i]
		 tableDataCell("ALIGN='RIGHT' class='" + className + "'", formatNum(value/1000,0) )
		 }
	  tableRowEnd();

	  tableRowBegin("");
	  tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "�݌v[���\] (B)" );
	  for( var i = 0; i < dispCnt; i++){
		 className = "secTotal"
		 value = rTab["����"][i]
		 className = ( i < actualCnt ? "actual" : "yosoku")
		 tableDataCell("ALIGN='RIGHT' class='" + className + "'", formatNum(value/1000,0) )
		 }
	  tableRowEnd();

	  tableRowBegin("");
	  tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "�� (B/A)" );
	  for( var i = 0; i < dispCnt; i++){
		 className = ( i < actualCnt ? "actual" : "yosoku")
		 value = rTab["����"][i] / rTab["�v��"][i]
		 dispStr = (rTab["�v��"][i] > 0 ? formatNum(value*100,1).bold() + " %" : "-")
		 tableDataCell("ALIGN='RIGHT' class='" + className + "' nowrap", dispStr )
		 }
	  tableRowEnd();

	  tableRowBegin("");
	  tableDataCell("ALIGN='CENTER' nowrap class='secTotal'" , "�� (A-B)" );
	  for( var i = 0; i < dispCnt; i++){
		 className = ( i < actualCnt ? "actual" : "yosoku")
		 value = -(rTab["����"][i] - rTab["�v��"][i])
		 dispStr = formatNum(value/1000,0)
		 dispStr = (value >= 0 ? dispStr.fontcolor("black") : dispStr.fontcolor("tomato") )
		 tableDataCell("nowrap class='" + className + "'", dispStr )
		 }
	  tableRowEnd();
	  }
   // �\���I�� ==================
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
   SQL += "    �區�� = ITEM.�區��,"
   SQL += "    ����   = ITEM.����"
   SQL += " FROM"
   SQL += "    ��v���ڃ}�X�^ ITEM"
   SQL += " GROUP BY"
   SQL += "     ITEM.�區��,"
   SQL += "     ITEM.����"

   RS.Open(SQL, DB, 0, 1)


   var Tab = new Object()
	Tab["�̊ǔ�"] = new Object
//	Tab["�̊ǔ�"]["�Œ莑�Y"] = new Object
//	makeArray(Tab["�̊ǔ�"]["�Œ莑�Y"],dispCnt)
   var item,kind
   while( !RS.EOF ){
	  item = JsTrim(RS.Fields('�區��').Value)
	  kind = JsTrim(RS.Fields('����').Value)
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
   

// ���уf�[�^�擾
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
   SQL += "     �區�� = ITEM.�區��,"
   SQL += "     ����   = ITEM.����,"
   SQL += "     yymm   = DATA.yymm,"
   SQL += "     EMG    = DATA.Flag,"
   SQL += "     amount = Sum(DATA.���z)"
   SQL += "     FROM"
   SQL += "     	(��v���ڃ}�X�^ ITEM INNER JOIN ��v���f�[�^       DATA ON ITEM.KmkCode = DATA.�Ȗ� AND (ITEM.Flag = DATA.Flag))"
//	 SQL += "     	                     INNER JOIN (SELECT * FROM EMG.dbo.�����}�X�^ WHERE �J�n <= '" + eDate + "' and �I�� > '" + sDate + "' ) MAST ON DATA.����    = MAST.ACC�R�[�h"

   SQL += "     WHERE"
//	 SQL += "     	MAST.ACC�R�[�h >= 0"
//	 SQL += "     	AND"
   SQL += "     	DATA.yymm BETWEEN " + s_yymm + " and " + e_yymm + ""
   SQL += "     GROUP BY"
   SQL += "     	ITEM.�區��,"
   SQL += "     	ITEM.����,"
   SQL += "     	DATA.yymm,"
   SQL += "     	DATA.Flag"

   RS.Open(SQL, DB, 0, 1)

   var item,kind,c_yymm,amount
   while( !RS.EOF ){
	  item	 = JsTrim(RS.Fields('�區��').Value)
	  kind	 = JsTrim(RS.Fields('����').Value)
	  c_yymm = RS.Fields('yymm').Value
	  amount = RS.Fields('amount').Value
		EMG    = RS.Fields('EMG').Value
		if( EMG == 1 ) amount = -amount
//***** ���ޏ��i�[
	  n = yymmDiff( yymm, c_yymm )
		if( IsObject(Tab[item][kind]["����"][n]) ){
		  Tab[item][kind]["����"][n] += amount
			}
	  RS.MoveNext();
	  }
   RS.Close()
/*
   SQL = ""
   SQL += " SELECT"
   SQL += "    �區�� = '�̊ǔ�',"
   SQL += "    ����   = '�Œ莑�Y',"
   SQL += "    yymm   = DATA.yymm,"
   SQL += "    EMG    = DATA.Flag," 			 // EMG�Ԕ�p
   SQL += "    amount = Sum(DATA.���z)"
   SQL += " FROM"
   SQL += "    ��v���f�[�^ DATA INNER JOIN (SELECT * FROM EMG.dbo.�����}�X�^ WHERE �J�n <= '" + eDate + "' and �I�� > '" + sDate + "' ) MAST ON DATA.���� = MAST.ACC�R�[�h"
   SQL += " WHERE"
   SQL += "    MAST.ACC�R�[�h >= 0"
   SQL += "    AND"
   SQL += "    DATA.yymm BETWEEN " + s_yymm + " AND " + e_yymm
   SQL += "    AND"
   SQL += "    DATA.�Ȗ� BETWEEN 211 AND 260"				// �區�� = �Œ莑�Y
   SQL += " GROUP BY"
   SQL += "    DATA.yymm,"
   SQL += "    DATA.Flag"
   RS = DB.Execute(SQL)

   var Grp,kind,item,yymm,amount,Cnt,mode
   while(!RS.EOF){
	  item	  = RS.Fields("�區��").Value
	  kind	  = RS.Fields("����").Value
	  c_yymm  = RS.Fields("yymm").Value
	  amount  = RS.Fields("amount").Value
		EMG 	= RS.Fields('EMG').Value
		if( EMG == 1 ) amount = -amount
	  n = yymmDiff( yymm, c_yymm )
	  Tab[item][kind]["����"][n] += amount
	  RS.MoveNext();
	  }
   RS.Close()
*/
   DB.Close()

   }


// �ߋ��̃f�[�^
function getPastData(Tab,yymm,Cnt)
   {
/*
   // �ߋ����̏�����
   for( var item in Tab ){
	  for( var kind in Tab[item]){
		 for( var n in Tab[item][kind]["�ߋ�"]){
			Tab[item][kind]["�ߋ�"][n] = 0
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
   SQL += "     �區�� = ITEM.�區��,"
   SQL += "     ����   = ITEM.����,"
   SQL += "     yymm   = DATA.yymm,"
   SQL += "     EMG    = DATA.Flag,"
   SQL += "     amount = Sum(DATA.���z)"
   SQL += "     FROM"
   SQL += "     	(��v���ڃ}�X�^ ITEM INNER JOIN ��v���f�[�^       DATA ON ITEM.KmkCode = DATA.�Ȗ� AND (ITEM.Flag = DATA.Flag))"

//	 SQL += "     	                     INNER JOIN (SELECT * FROM EMG.dbo.�����}�X�^ WHERE �J�n <= '" + eDate + "' and �I�� > '" + sDate + "' ) MAST ON DATA.���� = MAST.ACC�R�[�h"

   SQL += "     WHERE"
//	 SQL += "     	MAST.ACC�R�[�h >= 0"
//	 SQL += "     	AND"
   SQL += "     	DATA.yymm BETWEEN " + s_yymm + " and " + e_yymm + ""
   SQL += "     GROUP BY"
   SQL += "     	ITEM.�區��,"
   SQL += "     	ITEM.����,"
   SQL += "     	DATA.yymm,"
   SQL += "     	DATA.Flag"

   RS.Open(SQL, DB, 0, 1)

   var item,kind,c_yymm,amount
   while( !RS.EOF ){
	  item	 = JsTrim(RS.Fields('�區��').Value)
	  kind	 = JsTrim(RS.Fields('����').Value)
	  c_yymm = RS.Fields('yymm').Value
	  amount = RS.Fields('amount').Value
		EMG    = RS.Fields('EMG').Value
		if( EMG == 1 ) amount = -amount
	  n = yymmDiff( s_yymm, c_yymm )
	  if( IsObject(Tab[item][kind]["�ߋ�"][n]) ){
		  Tab[item][kind]["�ߋ�"][n] += amount
			}
	  RS.MoveNext();
	  }
   RS.Close()

/*
   SQL = ""
   SQL += " SELECT"
   SQL += "    �區�� = '�̊ǔ�',"
   SQL += "    ����   = '�Œ莑�Y',"
   SQL += "    yymm   = DATA.yymm,"
   SQL += "    EMG    = DATA.Flag," 			 // EMG�Ԕ�p
   SQL += "    amount = Sum(DATA.���z)"
   SQL += " FROM"
   SQL += "    ��v���f�[�^ DATA INNER JOIN (SELECT * FROM EMG.dbo.�����}�X�^ WHERE �J�n <= '" + eDate + "' and �I�� > '" + sDate + "' ) MAST ON DATA.���� = MAST.ACC�R�[�h"
   SQL += " WHERE"
   SQL += "    MAST.ACC�R�[�h >= 0"
   SQL += "    AND"
   SQL += "    DATA.yymm BETWEEN " + s_yymm + " AND " + e_yymm
   SQL += "    AND"
   SQL += "    DATA.�Ȗ� BETWEEN 211 AND 260"				// �區�� = �Œ莑�Y
   SQL += " GROUP BY"
   SQL += "    DATA.yymm,"
   SQL += "    DATA.Flag"
   RS = DB.Execute(SQL)

   var Grp,kind,item,yymm,amount,Cnt,mode
   while(!RS.EOF){
	  item	  = RS.Fields("�區��").Value
	  kind	  = RS.Fields("����").Value
	  c_yymm  = RS.Fields("yymm").Value
	  amount  = RS.Fields("amount").Value
		EMG 	= RS.Fields('EMG').Value
		if( EMG == 1 ) amount = -amount
	  n = yymmDiff( s_yymm, c_yymm )
	  Tab[item][kind]["�ߋ�"][n] += amount
	  RS.MoveNext();
	  }
   RS.Close()
*/
   DB.Close()
   }


// �v��f�[�^�擾
function getPlanData(Tab,yymm,dispCnt,actualCnt)
   {
// �N�ԃf�[�^��0�ɓ���Ă�������e��(1-10)�������Ă���

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
   SQL += " 	item   = ITEM.�區��,"
   SQL += " 	kind   = ITEM.����,"
   SQL += " 	yymm   = DATA.yymm,"
   SQL += " 	amount = Sum(DATA.���l)"
   SQL += " FROM"
   SQL += " 	(���x�v��f�[�^ DATA INNER JOIN (SELECT * FROM EMG.dbo.�����}�X�^ WHERE �J�n <= '" + eDate + "' and �I�� > '" + sDate + "' ) MAST ON DATA.����ID = MAST.�����R�[�h)"
   SQL += " 	                     INNER JOIN ���x���ڃ}�X�^     ITEM ON DATA.����ID = ITEM.ID"
   SQL += " WHERE"
   SQL += " 	DATA.��� = 0"
   SQL += " 	AND"
   SQL += " 	MAST.ACC�R�[�h >= 0"
   SQL += " 	AND"
   SQL += " 	DATA.yymm BETWEEN " + yymm + " AND " + e_yymm
   SQL += " GROUP BY"
   SQL += " 	ITEM.�區��,"
   SQL += " 	ITEM.����,"
   SQL += " 	DATA.yymm"

   RS.Open(SQL, DB, 0, 1)

	var item,kind,c_yymm,amount
	while( !RS.EOF ){
		item	 = JsTrim(RS.Fields('item').Value)
		kind	 = JsTrim(RS.Fields('kind').Value)
		c_yymm = RS.Fields('yymm').Value
		amount = RS.Fields('amount').Value

		if( item == "�Œ莑�Y" && kind == "�@��E�\�t�g" ){
//			item = "�̊ǔ�"
//			kind = "�Œ莑�Y"
			}
//pr(item + "][" + kind)
		n = yymmDiff( yymm, c_yymm )
		if( IsObject(Tab[item]) && IsObject(Tab[item][kind])){		// ��������I�������O
			Tab[item][kind]["�v��"][n] += amount * 1000
			}
		RS.MoveNext();
		}
	RS.Close()
	DB.Close()

	}

 
function makeArray(Tab,Cnt)
   {
   if(!IsArray(Tab["����"])){
	  Tab["�ߋ�"] = new Array(Cnt)
	  Tab["�v��"] = new Array(Cnt)
	  Tab["����"] = new Array(Cnt)
	  for( var i = 0; i < Cnt; i++){
		 Tab["�ߋ�"][i] = 0
		 Tab["�v��"][i] = 0
		 Tab["����"][i] = 0
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
