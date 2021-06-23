<%@ Language=JavaScript %>
<!--#include virtual = "/Project/home/_inc/cmn.inc"-->
<!--#include virtual = "/Project/home/_inc/json.inc"-->
<!--#include virtual = "/Project/home/_inc/�m����t.inc"-->
<%
    var eMsg = "OK";

    var year = $queryString("year", 2018);
    var actual = $queryString("actual", 12);
    var fix = $queryString("fix", 70);

    year = 2018;

//===========================================================================
    var Tab = getJSONData(year, actual, fix);

    //$JsonOut(Tab);
//    Response.End();


    var xmlDoc = makeXMLDoc(Tab);

    Response.CharSet = "SHIFT_JIS";
    //Response.AddHeader("Access-Control-Allow-Origin", "*");
    Response.ContentType = "text/xml"
    xmlDoc.save(Response)

%>
<%
    function getJSONData(year, actual, fix) {
        var b_yymm = 201810;
        var dispCnt = 12;
        var actualCnt = 3;

        try {

            //=== �f�[�^�擾 =======================================================
            var Tab = getUser(b_yymm, dispCnt)						// ���ޖ��쐬

            getActualData(Tab, b_yymm, dispCnt, actualCnt)			// ���уf�[�^�擾
            getPlanData(Tab, b_yymm, dispCnt, actualCnt)				// �v��f�[�^�擾
            getPastData(Tab, b_yymm, dispCnt)							// �ߋ��f�[�^

            // ���тƗ\�Z�̃}�[�W�i���т̐��l���Ȃ����͗\�Z���g���j

            for (var item in Tab) {
                for (var kind in Tab[item]) {
                    var x = "�v��"
                    for (var m in Tab[item][kind][x]) {
                        if (m >= actualCnt) {
                            Tab[item][kind]["����"][m] = Tab[item][kind]["�v��"][m]
                        }
                    }
                }
            }
            for (var item in Tab) {
                for (var kind in Tab[item]) {
                    Tab[item][kind]["�݌v_�v��"] = new Array(Tab[item][kind]["�v��"][0], 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
                    Tab[item][kind]["�݌v_����"] = new Array(Tab[item][kind]["����"][0], 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
                    for (var m = 1; m < dispCnt; m++) {
                        Tab[item][kind]["�݌v_�v��"][m] = Tab[item][kind]["�݌v_�v��"][m - 1] + Tab[item][kind]["�v��"][m]
                        Tab[item][kind]["�݌v_����"][m] = Tab[item][kind]["�݌v_����"][m - 1] + Tab[item][kind]["����"][m]
                    }
                }
            }
        } catch (e) {
            pr(e.message);
        }

        //=========================================================================
        var mainTab = {
            �N�x: year,
            �J�n��: b_yymm,
            �\������: dispCnt,
            ���ь���: actualCnt,
            �m�x: fix,
            data: ""
        };
        mainTab.data = Tab;
        return (mainTab);
    }
%>
<%
    function makeXMLDoc(Tab) {
        var xmlDoc = Server.CreateObject("Microsoft.XMLDom")
        xmlDoc.async = false

        var main1 = xmlDoc.createProcessingInstruction("xml", "version='1.0' encoding='Shift_JIS'")
        xmlDoc.appendChild(main1)

        var rootNode = xmlDoc.createElement("root")
        xmlDoc.appendChild(rootNode)

        setInfoNode(rootNode, Tab);

        makeXMLData( rootNode, Tab.data);

        return (xmlDoc);
    }
    function setInfoNode(rootNode, Tab) {
        var xmlDoc = rootNode.ownerDocument;
        var infoNode = xmlDoc.createElement("�\�����");
        rootNode.appendChild(infoNode);
        for( var item in Tab) {
            if (item == "data") continue;
            var node = xmlDoc.createElement(item);
            var textNode = xmlDoc.createTextNode(Tab[item]);
            node.appendChild(textNode);
            infoNode.appendChild(node);
        }
    }



    function makeXMLData( rootNode, Tab)
    {
        var xmlDoc = rootNode.ownerDocument;
        for (var item in Tab) {
            var itemNode = xmlDoc.createElement("����");
            itemNode.setAttribute("name", item);
            rootNode.appendChild(itemNode);
            // �q��P��
            for (var sub_item in Tab[item]) {
                var sub_itemNode = xmlDoc.createElement("������");
                sub_itemNode.setAttribute("name", sub_item);
                itemNode.appendChild(sub_itemNode);
                for (var m_item in Tab[item][sub_item]) {
                    var m_itemNode = xmlDoc.createElement("�����");
                    m_itemNode.setAttribute("name", m_item);
                    sub_itemNode.appendChild(m_itemNode);
                    for (var m in Tab[item][sub_item][m_item]) {
                        var mNode = xmlDoc.createElement("��");
                        mNode.setAttribute("name", m);
                        m_itemNode.appendChild(mNode);
                        var sValue = Tab[item][sub_item][m_item][m];
                        var sText = xmlDoc.createTextNode(sValue);
                        mNode.appendChild(sText);
                    }
                }
            }
        }

    }

%>

<!--#include file = "EMG��p��.inc.asp"-->
