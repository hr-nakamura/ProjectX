<%@ Language=JavaScript %>
<!--#include virtual = "/Project/home/_inc/cmn.inc"-->
<!--#include virtual = "/Project/home/_inc/確定日付.inc"-->
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

            var Tab = getUser(DB, b_yymm, dispCnt)								// グループ名作成

            getPastData(DB, Tab, yymmAdd(b_yymm, -12), 1)						// 前年度のデータ
            
            getActualData(DB, Tab, b_yymm, dispCnt, actualCnt)					// 実績データ取得
            
           //dispXML("",Tab)
            getExpectData(DB, Tab, b_yymm, dispCnt, actualCnt, fixLevel)			// 予測データ取得
            getTargetData(DB, Tab, b_yymm, dispCnt, 0)							// 目標データ取得
            
            
            if (TransferMode == 1) {
                var sTab = salesAdjustData(DB, b_yymm)
                for (var S_name in sTab["計画"]) {
                     //pr( "1[" + S_name + "][" + IsObject(Tab[S_name]) )
                    if (IsObject(Tab[S_name])) {
                        for (var m = 0; m < dispCnt; m++) {
                            value = sTab["計画"][S_name].受取[m] + sTab["計画"][S_name].支払[m]
                            Tab[S_name]["目標"][m] += value * 1000
                        }
                    }
                }
                var s_m = (actualCnt >= 0 ? actualCnt : 0)
                    for (var S_name in sTab["予測"]) {
                        //pr( "2[" + S_name + "][" + IsObject(Tab[S_name]) )
                        if (IsObject(Tab[S_name])) {
                            for (var m = s_m; m < dispCnt; m++) {
                                value = sTab["予測"][S_name].受取[m] + sTab["予測"][S_name].支払[m]
                                Tab[S_name]["予実"][m] += value * 1000
                            }
                        }
                    }
                }
            DB.Close();
//========================================
            // 累計データ計算
            var dispCnt = 12;
            for (var S_name in Tab) {
                if (S_name == "全体") continue;
                for (var m = 0; m < dispCnt; m++) {
                    Tab["全体"]["目標"][m] += Tab[S_name]["目標"][m]
                    Tab["全体"]["予実"][m] += Tab[S_name]["予実"][m]
                    Tab["全体"]["前年"][m] += Tab[S_name]["前年"][m]
                }
            }

            for (var S_name in Tab) {
                Tab[S_name]["累計_目標"] = new Array(Tab[S_name]["目標"][0], 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
                Tab[S_name]["累計_予実"] = new Array(Tab[S_name]["予実"][0], 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
                Tab[S_name]["累計_前年"] = new Array(Tab[S_name]["前年"][0], 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
                for (var m = 1; m < dispCnt; m++) {
                    Tab[S_name]["累計_目標"][m] = Tab[S_name]["累計_目標"][m - 1] + Tab[S_name]["目標"][m]
                    Tab[S_name]["累計_予実"][m] = Tab[S_name]["累計_予実"][m - 1] + Tab[S_name]["予実"][m]
                    Tab[S_name]["累計_前年"][m] = Tab[S_name]["累計_前年"][m - 1] + Tab[S_name]["前年"][m]
                }
            }
        }
        catch (e) {
            Tab["error"] = e.message;
        }

//=========================================================================
        var mainTab = {
            年度: year,
            開始月: b_yymm,
            表示月数: dispCnt,
            実績月数: actualCnt,
            確度: fixLevel,
            付替: TransferMode,
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
        var infoNode = xmlDoc.createElement("表示情報");
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
            var secNode = xmlDoc.createElement("種別");
            secNode.setAttribute("name", sec_name);
            rootNode.appendChild(secNode);

            var itemTab = ["目標", "予実", "前年", "累計_目標", "累計_予実", "累計_前年"];
            for (var i in itemTab) {
                var itemName = itemTab[i];
                var itemNode = xmlDoc.createElement(itemName);
                secNode.appendChild(itemNode);
                for (var m in Tab[sec_name][itemName]) {
                    var mNode = xmlDoc.createElement("月");
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

<!--#include file = "売上目標_部門.inc.asp"-->
