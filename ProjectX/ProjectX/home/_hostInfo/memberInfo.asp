<script language="javascript" runat="server" src='json2.js'></script>
<script language="javascript" runat="server">
    var result = "str";
    var hostInfo = {
        "name": "�e�X�g�@�f�[�^",
        "mail": "test@eandm.co.jp",
        "post": "",
        "sub": [],
        "Tag": []
    }
try{

    if (typeof (Session("mailAddress")) != "string") {

        //Session("ODBC") = "DRIVER={SQL Server};SERVER={NAKAMURA-RD\\SQLExpress};UID=webuser;PWD=emguser08;DATABASE=kansaDB";
        //Session("mailAddress") = "nakamura@eandm.co.jp";

        //hostInfo.Tag.push("F_TEST");

    }
    else {
        var ODBC = Session("ODBC");
        var mailAddr = Session("mailAddress");

        var Info = $memberInfo(mailAddr);

        for (var i = 0; i < Info.length; i++) {
            if (Info[i].mode == 0) {
                hostInfo.mail = Info[i].mail;
                hostInfo.name = Info[i].name;
                hostInfo.���� = Info[i].bName;
                hostInfo.post = Info[i].pName;
                hostInfo.bCode = Info[i].bCode;
                hostInfo.pCode = Info[i].pCode;
            }
            else {
                hostInfo.sub.push(Info[i]);
            }
        }

        hostInfo.Tag = $entryCheck(mailAddr);


    }
        } catch (e) {
            result = e.message;
        }
        result = JSON.stringify(hostInfo, null, 2);

        Response.ContentType = "application/json";
        Response.CharSet = "SHIFT_JIS";
	    Response.Write(result);

</script>
    <script language="javascript" runat="server">

        function $memberInfo(mailAddr) {
            try {
            var Tab = [];
            var DB = Server.CreateObject("ADODB.Connection")
            var RS = Server.CreateObject("ADODB.Recordset")
            DB.Open(Session("ODBC"))
            DB.DefaultDatabase = "kansaDB"
            var SQL = "";
            SQL += " SELECT";
            SQL += "    mail = MAST.���[���A�h���X,";
            SQL += "    name = MAST.�� + ' ' + MAST.��,";
            SQL += "    pCode = POST.postCode,";
            SQL += "    mode = POST.����,";
            SQL += "    bName = BMAST.������,";
            SQL += "    pName = PMAST.name,";
            SQL += "    bCode = BMAST.�����R�[�h";

            SQL += " FROM";
            SQL += "    EMG.dbo.�Ј���b�f�[�^ MAST";
            SQL += "        LEFT JOIN(SELECT * FROM EMG.dbo.�|�X�g���� WHERE GETDATE() BETWEEN startDate AND endDate) POST";
            SQL += "            ON MAST.�Ј�ID = POST.memberID";
            SQL += "        INNER JOIN EMG.dbo.�����}�X�^ BMAST";
            SQL += "            ON POST.�����R�[�h = BMAST.�����R�[�h";
            SQL += "        INNER JOIN EMG.dbo.�|�X�g�}�X�^ PMAST";
            SQL += "            ON PMAST.postCode = POST.postCode";
            SQL += " WHERE";
            SQL += "    MAST.���[���A�h���X = '" + mailAddr + "'";
            RS.Open(SQL, DB, 3, 3)
            while (!RS.EOF) {
                var mail = (RS.Fields("mail").Value == null ? "" : RS.Fields("mail").Value);
                Tab.push({ mail: mail , name: RS.Fields("name").Value, mode: RS.Fields("mode").Value, bName: RS.Fields("bName").Value, bCode: RS.Fields("bCode").Value, pName: RS.Fields("pName").Value, pCode: RS.Fields("pCode").Value });
                RS.MoveNext();
            }
            RS.Close()
            DB.Close()
            return (Tab);
            } catch (e) { Response.Write("[" + e.message) }
        }

        function $entryCheck(mailAddr) {
            var Auth = false
            try {
                var DB = Server.CreateObject("ADODB.Connection")
                var RS = Server.CreateObject("ADODB.Recordset")
                DB.Open(Session("ODBC"))
                DB.DefaultDatabase = "kansaDB"
                var Tab = [];
                var name, item, mode;
                var SQLTab = []
                var SQL

                SQL = " SELECT"
                SQL += "    name = '��',"
                SQL += "    mID  = DATA.memberID,"
                SQL += "    item = DATA.���ʒu,"
                SQL += "    mode = DATA.mode"
                SQL += " FROM"
                SQL += "    �y�[�W�Q�Ƌ���� DATA INNER JOIN EMG.dbo.�Ј���b�f�[�^ MAST"
                SQL += "        ON DATA.memberID = MAST.�Ј�ID"

                SQL += " WHERE"
                SQL += "    MAST.���[���A�h���X = '" + mailAddr + "'"
                SQL += "    AND"
                SQL += "    DATA.mode = 1"
                SQLTab.push(SQL)

                SQL = " SELECT"
                SQL += "    name = '�|�X�g',"
                SQL += "    mID  = DATA.memberID,"
                SQL += "    item = DATA.���ʒu,"
                SQL += "    mode = DATA.mode"
                SQL += " FROM"
                SQL += "    �y�[�W�Q�Ƌ���� DATA"
                SQL += "          INNER JOIN (SELECT * FROM EMG.dbo.�|�X�g���� WHERE GETDATE() BETWEEN startDate AND endDate) POST"
                SQL += "              ON DATA.memberID = POST.postCode"
                SQL += "          INNER JOIN EMG.dbo.�Ј���b�f�[�^ MAST"
                SQL += "              ON POST.memberID = MAST.�Ј�ID"
                SQL += " WHERE"
                SQL += "    MAST.���[���A�h���X = '" + mailAddr + "'"
                SQL += "    AND"
                SQL += "    DATA.mode = 1"
                SQLTab.push(SQL)

                SQL = SQLTab.join(" UNION ALL ")

                RS.Open(SQL, DB, 3, 3)
                while (!RS.EOF) {
                    name = RS.Fields("name").Value;
                    item = RS.Fields("item").Value;
                    mode = RS.Fields("mode").Value;
                    Tab.push(item);
                    RS.MoveNext();
                }
                RS.Close()
                DB.Close()

                return (Tab)
            } catch (e) { Response.Write("[" + e.message) }
        }

</script>
