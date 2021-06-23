<%@ Language=JavaScript %>
<!--#include virtual = "/Project/home/_inc/cmn.inc"-->
<!--#include virtual = "/Project/home/_inc/�m����t.inc"-->
<!--#include virtual = "/Project/home/_inc/json.inc"-->
<%
    var para = {};
    try {

        var eMsg = "OK";

        para.year = $queryString("year", 2018);
        para.actual = $queryString("actual", 12);
        para.fix = $queryString("fix", 70);
        //$JsonOut(para);

        year = 2019;


        //===========================================================================
        var Tab = getJSONData();
        var xmlDoc = makeXMLDoc(Tab, para.year);

        Response.CharSet = "SHIFT_JIS";
        //Response.AddHeader("Access-Control-Allow-Origin", "*");
        Response.ContentType = "text/xml"
        xmlDoc.save(Response)

    } catch (e) {
        pr(e.message + "][" + path);
    }
%>
<%
    function getJSONData() {
        try {
            var year = 2019;
            var b_yymm = 201810;
            var dispCnt = 12;
            var actualCnt = 12;
            var fixLevel = 70;
            var TransferMode = 0;

            var DB = Server.CreateObject("ADODB.Connection")
            DB.Open(Session("ODBC"))
            DB.DefaultDatabase = "kansaDB"

            var Tab = getUser(DB, b_yymm, dispCnt)								// �O���[�v���쐬

            getPastData(DB, Tab, yymmAdd(b_yymm, -12), 1)						// �O�N�x�̃f�[�^
            
            getActualData(DB, Tab, b_yymm, dispCnt, actualCnt)					// ���уf�[�^�擾
            
           //dispXML("",Tab)
            getExpectData(DB, Tab, b_yymm, dispCnt, actualCnt, fixLevel)			// �\���f�[�^�擾
            getTargetData(DB, Tab, b_yymm, dispCnt, 0)							// �ڕW�f�[�^�擾
            
            
            if (TransferMode == 1) {
                var sTab = salesAdjustData(DB, b_yymm)
                for (var S_name in sTab["�v��"]) {
                     //pr( "1[" + S_name + "][" + IsObject(Tab[S_name]) )
                    if (IsObject(Tab[S_name])) {
                        for (var m = 0; m < dispCnt; m++) {
                            value = sTab["�v��"][S_name].���[m] + sTab["�v��"][S_name].�x��[m]
                            Tab[S_name]["�ڕW"][m] += value * 1000
                        }
                    }
                }
                var s_m = (actualCnt >= 0 ? actualCnt : 0)
                    for (var S_name in sTab["�\��"]) {
                        //pr( "2[" + S_name + "][" + IsObject(Tab[S_name]) )
                        if (IsObject(Tab[S_name])) {
                            for (var m = s_m; m < dispCnt; m++) {
                                value = sTab["�\��"][S_name].���[m] + sTab["�\��"][S_name].�x��[m]
                                Tab[S_name]["�\��"][m] += value * 1000
                            }
                        }
                    }
                }
            DB.Close();
//========================================
            // �݌v�f�[�^�v�Z
            var dispCnt = 12;
            for (var S_name in Tab) {
                if (S_name == "�S��") continue;
                for (var m = 0; m < dispCnt; m++) {
                    Tab["�S��"]["�ڕW"][m] += Tab[S_name]["�ڕW"][m]
                    Tab["�S��"]["�\��"][m] += Tab[S_name]["�\��"][m]
                    Tab["�S��"]["�O�N"][m] += Tab[S_name]["�O�N"][m]
                }
            }

            for (var S_name in Tab) {
                Tab[S_name]["�݌v_�ڕW"] = new Array(Tab[S_name]["�ڕW"][0], 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
                Tab[S_name]["�݌v_�\��"] = new Array(Tab[S_name]["�\��"][0], 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
                Tab[S_name]["�݌v_�O�N"] = new Array(Tab[S_name]["�O�N"][0], 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
                for (var m = 1; m < dispCnt; m++) {
                    Tab[S_name]["�݌v_�ڕW"][m] = Tab[S_name]["�݌v_�ڕW"][m - 1] + Tab[S_name]["�ڕW"][m]
                    Tab[S_name]["�݌v_�\��"][m] = Tab[S_name]["�݌v_�\��"][m - 1] + Tab[S_name]["�\��"][m]
                    Tab[S_name]["�݌v_�O�N"][m] = Tab[S_name]["�݌v_�O�N"][m - 1] + Tab[S_name]["�O�N"][m]
                }
            }
        }
        catch (e) {
            Tab["error"] = e.message;
        }

//=========================================================================
        var mainTab = {
            �N�x: year,
            �J�n��: b_yymm,
            �\������: dispCnt,
            ���ь���: actualCnt,
            �m�x: fixLevel,
            �t��: TransferMode,
            data: Tab
        };

        return (mainTab);
    }
%>

<%
    function makeXMLDoc(Tab,year) {
        var xmlDoc = Server.CreateObject("Microsoft.XMLDom")
        xmlDoc.async = false

        var main1 = xmlDoc.createProcessingInstruction("xml", "version='1.0' encoding='Shift_JIS'")
        xmlDoc.appendChild(main1)

        var rootNode = xmlDoc.createElement("root")
        xmlDoc.appendChild(rootNode)

        try {
            setInfoNode(rootNode, Tab);

            makeXMLData(rootNode, Tab.data);
        }
        catch (e) {
            var commentNode = xmlDoc.createComment("ERROR:" + e.message);
            xmlDoc.insertBefore(commentNode, rootNode);
        }

        var commentNode = xmlDoc.createComment(year);
        xmlDoc.insertBefore(commentNode, rootNode);

        return (xmlDoc);
    }
    function setInfoNode(rootNode, Tab) {
        var xmlDoc = rootNode.ownerDocument;
        var infoNode = xmlDoc.createElement("�\�����");
        rootNode.appendChild(infoNode);
        for (var item in Tab) {
            if (item == "data") continue;
            var node = xmlDoc.createElement(item);
            var textNode = xmlDoc.createTextNode(Tab[item]);
            node.appendChild(textNode);
            infoNode.appendChild(node);
        }
    }

    function makeXMLData(rootNode, Tab)
    {
        var xmlDoc = rootNode.ownerDocument;

        for (var sec_name in Tab) {
            var secNode = xmlDoc.createElement("���");
            secNode.setAttribute("name", sec_name);
            rootNode.appendChild(secNode);

            var itemTab = ["�ڕW", "�\��", "�O�N", "�݌v_�ڕW", "�݌v_�\��", "�݌v_�O�N"];
            for (var i in itemTab) {
                var itemName = itemTab[i];
                var itemNode = xmlDoc.createElement(itemName);
                secNode.appendChild(itemNode);
                for (var m in Tab[sec_name][itemName]) {
                    var mNode = xmlDoc.createElement("��");
                    mNode.setAttribute("m",m);
                    itemNode.appendChild(mNode);
                    var sValue = Tab[sec_name][itemName][m];
                    var sText = xmlDoc.createTextNode(sValue);
                    mNode.appendChild(sText);
                }

            }
        }

    }

%>

<!--#include file = "����ڕW_����.inc.asp"-->
