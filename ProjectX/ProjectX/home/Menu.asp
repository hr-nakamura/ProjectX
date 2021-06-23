<%@ Language=JScript %>
<!--#include virtual="/Project/Auth/menu.inc"-->
<!--#include virtual="/Project/inc/cmn.inc"-->
<%
var memberID = Session("memberID")
var mailAddr = Session("mailAddress")
var mode	 = entryCheck(mailAddr,"F_部門収支")
//var subMenu  = menuAuthCheck(memberID,"部門収支_間接部門")			// 指定した人だけ
//var 課_Menu  = menuAuthCheck(memberID,"部門収支_課")				// 指定した人だけ

var subMenu  = entryCheck(mailAddr,"F_部門収支_間接部門")			// 指定した人だけ
var 課_Menu  = entryCheck(mailAddr,"F_部門収支_課")				// 指定した人だけ

var editMenu  = entryCheck(mailAddr,"F_組織データ編集")			// 指定した人だけ

%>
<%if(mode){%>

<TABLE WIDTH="100%" border="0" ID="Table1" cellpadding="10" mode="<%=mode%>">
	<TBODY>
	<TR><TD nowrap>
		<TABLE WIDTH="100%" border="0" ID="Table2" cellspacing="4">
		<TBODY>
		<TR><TD nowrap>
		<A url="/Project/部門収支/EMG収支計画.asp">ＥＭＧ収支計画</A>
		</TD></TR>
		<TR><TD nowrap><br></TD></TR>

		<TR><TD nowrap>
<!--		<img src="new.gif"/>	-->
		<A url="/Project/部門収支/統括収支計画.asp">統括収支計画</A>

		</TD></TR>
		<TR><TD nowrap><br></TD></TR>
		<TR><TD nowrap>
<!--		<img src="new.gif"/>	-->
		<A url="/Project/部門収支/部門収支計画.asp">部門収支計画</A>
		<TR><TD nowrap>
		<A url="/Project/計画入力/GRP予測入力.asp"><small>(予測データ設定)</small></A><BR>
		<A url="/Project/計画入力/付替処理/index_開発.asp"><small>(付替予測設定)</small></A>
		</TD></TR>

		 <%if(課_Menu){%>
			<TR><TD nowrap>
			<FIELDSET>
				<small>＝＝　開発部門（課）　＝＝</small><br>
				<A url="/Project/部門収支/グループ収支計画.asp">課 別収支</A><br>
			</FIELDSET>
			</TD></TR>
			<%}%>
		 <%if(subMenu){%>
			<TR><TD nowrap>
			<FIELDSET>
				<small>＝＝　間接部門　＝＝</small><br>
				<A url="/Project/部門収支/部門収支計画.asp?dispCmd=部門一覧&secMode=間接">部門収支計画</A><br>
<!--				<A url="/Project/部門収支/間接収支計画.asp">グループ別収支</A><br>	-->
				<A url="/Project/計画入力/間接予測入力.asp"><small>(予測データ設定)</small></A><BR>
				<A url="/Project/計画入力/付替処理/index_間接.asp"><small>(付替予測設定)</small></A><BR><BR>
				<A url="/Project/部門収支/グループ収支計画.asp?secMode=間接">課 別収支</A><br>
			</FIELDSET>
			</TD></TR>
			<%}%>
		 <%if(editMenu){%>
			<TR><TD nowrap>
			<FIELDSET>
				<small>＝＝　部門集計用　DB　＝＝</small><br>
				<A url="/Project/common_data/統括本部編集/main.asp">統括本部マスタ編集</A><br>
			</FIELDSET>
			</TD></TR>
			<%}%>
		 </TBODY>
		 </TABLE>

	</TD></TR>
	</TBODY>
  </TABLE>
<%}%>
<%
// 認証されたメンバーの情報
function menuAuthCheck_X(fName,memberID)
	{
	var Info = getFileData(fName)
	var Name = Info.Name
	var Buff = (Info.Auth).split(",")
	var Flag = false
	for( var x in Buff ){
		if( Buff[x] == memberID ){
			Flag = true
			break;
			}
		}
	return(Flag)
	}

function getFileData(fName)
	{
	var curDir = Server.MapPath(".")
	var fileName = curDir + "\\部門収支\\" + fName
   var fs = Server.CreateObject("Scripting.FileSystemObject")
	var fp
	var Tab = new Array()
	var Buff

   if(fs.FileExists(fileName) == true){
	  fp = fs.OpenTextFile(fileName,1,false,0)
		while(!fp.AtEndOfStream){
			Buff = fp.ReadLine()

			if(Buff.length > 0 && Buff.substr(0,1) != ";") Tab[Tab.length] = Buff.split("\t")[0]
			}
		fp.Close()
		}
	var Name = Tab[0]
	Tab.shift()
	var AuthStr = Tab.join(",")
	var Value = {Name:Name,Auth:AuthStr}
	return(Value)
	}

%>
