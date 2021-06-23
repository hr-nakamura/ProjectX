<%@ Language=JavaScript %>
<!--#include virtual = "/Project/home/_inc/cmn.inc"-->
<!--#include virtual = "/Project/home/_inc/json.inc"-->
<!--#include virtual = "/Project/home/_inc/確定日付.inc"-->
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

            //=== データ取得 =======================================================
            var Tab = getUser(b_yymm, dispCnt)						// 分類名作成

            getActualData(Tab, b_yymm, dispCnt, actualCnt)			// 実績データ取得
            getPlanData(Tab, b_yymm, dispCnt, actualCnt)				// 計画データ取得
            getPastData(Tab, b_yymm, dispCnt)							// 過去データ

            // 実績と予算のマージ（実績の数値がない月は予算を使う）

            for (var item in Tab) {
                for (var kind in Tab[item]) {
                    var x = "計画"
                    for (var m in Tab[item][kind][x]) {
                        if (m >= actualCnt) {
                            Tab[item][kind]["実績"][m] = Tab[item][kind]["計画"][m]
                        }
                    }
                }
            }
            for (var item in Tab) {
                for (var kind in Tab[item]) {
                    Tab[item][kind]["累計_計画"] = new Array(Tab[item][kind]["計画"][0], 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
                    Tab[item][kind]["累計_実績"] = new Array(Tab[item][kind]["実績"][0], 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
                    for (var m = 1; m < dispCnt; m++) {
                        Tab[item][kind]["累計_計画"][m] = Tab[item][kind]["累計_計画"][m - 1] + Tab[item][kind]["計画"][m]
                        Tab[item][kind]["累計_実績"][m] = Tab[item][kind]["累計_実績"][m - 1] + Tab[item][kind]["実績"][m]
                    }
                }
            }
        } catch (e) {
            pr(e.message);
        }

        //=========================================================================
        var mainTab = {
            年度: year,
            開始月: b_yymm,
            表示月数: dispCnt,
            実績月数: actualCnt,
            確度: fix,
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
        var infoNode = xmlDoc.createElement("表示情報");
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
            var itemNode = xmlDoc.createElement("項目");
            itemNode.setAttribute("name", item);
            rootNode.appendChild(itemNode);
            // 客先単位
            for (var sub_item in Tab[item]) {
                var sub_itemNode = xmlDoc.createElement("副項目");
                sub_itemNode.setAttribute("name", sub_item);
                itemNode.appendChild(sub_itemNode);
                for (var m_item in Tab[item][sub_item]) {
                    var m_itemNode = xmlDoc.createElement("月情報");
                    m_itemNode.setAttribute("name", m_item);
                    sub_itemNode.appendChild(m_itemNode);
                    for (var m in Tab[item][sub_item][m_item]) {
                        var mNode = xmlDoc.createElement("月");
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

<!--#include file = "EMG費用状況.inc.asp"-->
