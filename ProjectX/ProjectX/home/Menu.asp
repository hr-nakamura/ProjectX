<%@ Language=JScript %>
<!--#include virtual="/Project/Auth/menu.inc"-->
<!--#include virtual="/Project/inc/cmn.inc"-->
<%
var memberID = Session("memberID")
var mailAddr = Session("mailAddress")
var mode	 = entryCheck(mailAddr,"F_������x")
//var subMenu  = menuAuthCheck(memberID,"������x_�Ԑڕ���")			// �w�肵���l����
//var ��_Menu  = menuAuthCheck(memberID,"������x_��")				// �w�肵���l����

var subMenu  = entryCheck(mailAddr,"F_������x_�Ԑڕ���")			// �w�肵���l����
var ��_Menu  = entryCheck(mailAddr,"F_������x_��")				// �w�肵���l����

var editMenu  = entryCheck(mailAddr,"F_�g�D�f�[�^�ҏW")			// �w�肵���l����

%>
<%if(mode){%>

<TABLE WIDTH="100%" border="0" ID="Table1" cellpadding="10" mode="<%=mode%>">
	<TBODY>
	<TR><TD nowrap>
		<TABLE WIDTH="100%" border="0" ID="Table2" cellspacing="4">
		<TBODY>
		<TR><TD nowrap>
		<A url="/Project/������x/EMG���x�v��.asp">�d�l�f���x�v��</A>
		</TD></TR>
		<TR><TD nowrap><br></TD></TR>

		<TR><TD nowrap>
<!--		<img src="new.gif"/>	-->
		<A url="/Project/������x/�������x�v��.asp">�������x�v��</A>

		</TD></TR>
		<TR><TD nowrap><br></TD></TR>
		<TR><TD nowrap>
<!--		<img src="new.gif"/>	-->
		<A url="/Project/������x/������x�v��.asp">������x�v��</A>
		<TR><TD nowrap>
		<A url="/Project/�v�����/GRP�\������.asp"><small>(�\���f�[�^�ݒ�)</small></A><BR>
		<A url="/Project/�v�����/�t�֏���/index_�J��.asp"><small>(�t�֗\���ݒ�)</small></A>
		</TD></TR>

		 <%if(��_Menu){%>
			<TR><TD nowrap>
			<FIELDSET>
				<small>�����@�J������i�ہj�@����</small><br>
				<A url="/Project/������x/�O���[�v���x�v��.asp">�� �ʎ��x</A><br>
			</FIELDSET>
			</TD></TR>
			<%}%>
		 <%if(subMenu){%>
			<TR><TD nowrap>
			<FIELDSET>
				<small>�����@�Ԑڕ���@����</small><br>
				<A url="/Project/������x/������x�v��.asp?dispCmd=����ꗗ&secMode=�Ԑ�">������x�v��</A><br>
<!--				<A url="/Project/������x/�Ԑڎ��x�v��.asp">�O���[�v�ʎ��x</A><br>	-->
				<A url="/Project/�v�����/�Ԑڗ\������.asp"><small>(�\���f�[�^�ݒ�)</small></A><BR>
				<A url="/Project/�v�����/�t�֏���/index_�Ԑ�.asp"><small>(�t�֗\���ݒ�)</small></A><BR><BR>
				<A url="/Project/������x/�O���[�v���x�v��.asp?secMode=�Ԑ�">�� �ʎ��x</A><br>
			</FIELDSET>
			</TD></TR>
			<%}%>
		 <%if(editMenu){%>
			<TR><TD nowrap>
			<FIELDSET>
				<small>�����@����W�v�p�@DB�@����</small><br>
				<A url="/Project/common_data/�����{���ҏW/main.asp">�����{���}�X�^�ҏW</A><br>
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
// �F�؂��ꂽ�����o�[�̏��
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
	var fileName = curDir + "\\������x\\" + fName
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
