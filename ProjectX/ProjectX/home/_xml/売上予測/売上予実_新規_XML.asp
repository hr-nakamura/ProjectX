<%@ Language=JavaScript %>
<!--#include virtual = "/Project/home/_inc/cmn.inc"-->
<!--#include virtual = "/Project/home/_inc/json.inc"-->
<%
    try {

        var eMsg = "OK";

        var year = $queryString("year", 2018);
        var actual = $queryString("actual", 12);
        var fix = $queryString("fix", 70);

        year = 2018;


        //===========================================================================
        var Tab = getJSONData(year, actual, fix);

//        $JsonOut(Tab);


        var xmlDoc = makeXMLDoc(Tab);

        Response.CharSet = "SHIFT_JIS";
        //Response.AddHeader("Access-Control-Allow-Origin", "*");
        Response.ContentType = "text/xml"
        xmlDoc.save(Response)

    } catch (e) {
        pr(e.message + "][" + path);
    }
%>
<%
    function getJSONData(year, actual, fix) {

        var DB = Server.CreateObject("ADODB.Connection")
        DB.Open(Session("ODBC"))
        DB.DefaultDatabase = "kansaDB"

        var dispCnt = 12;

        var actualStr = actual;
        var actualMonth
        if (IsNumeric(actualStr)) {
            actualMonth = actualStr
            if (actualMonth > 12 || actualMonth < 0) actualMonth = -1
        }
        else {
            actualMonth = -1
        }

        var fixStr = fix;
        var fixLevel
        if (IsNumeric(fixStr)) {
            fixLevel = (Math.floor(fixStr / 10)) * 10
            if (fixLevel > 100 || fixLevel < 0) fixLevel = 70
        }
        else {
            fixLevel = 70
        }
        var allGroup = true
        var limitYear = 2003
        var dispCnt = 12
        if (year == "undefined") {
            var d = new Date()
            var yy = d.getFullYear()
            var mm = d.getMonth() + 1

            year = yy + (mm >= 10 ? 1 : 0)			  // 10月以降は次年度を表示
        }

        if (year < limitYear) {
            Response.End()
        }

        var b_yymm = ((year - 1) * 100) + 10
            var d = new Date()
            var yy = d.getFullYear()
            var mm = d.getMonth() + 1
            var dd = d.getDate()
            var yymm = yy * 100 + mm						// 今月のyymm

//        var OKday = dayChk(d, adjustDayCnt)
var OKday=10;
        yymm = (parseInt(dd) < parseInt(OKday) ? yymmAdd(yymm, -1) : yymmAdd(yymm, 0))			// 確定日の補正
            var actualCnt = yymmDiff(b_yymm, yymm)

    
            if (actualMonth >= 0) {
                actualCnt = actualMonth
            }
//        var Tab = getUser(DB, b_yymm, dispCnt);
        var Tab = new Object;

        getSalesData(DB, Tab, b_yymm, dispCnt, actualCnt, fixLevel)			 // 予測・実績

        DB.Close()

        //        dispPlan(Tab, b_yymm, dispCnt, actualCnt)

//=========================================================================
        var mainTab = {
            年度: year,
            開始月: b_yymm,
            表示月数: dispCnt,
            実績月数: actual,
            確度: fix,
            data: Tab
        };

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
            var total1 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
            var total2 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
            var secNode = xmlDoc.createElement("種別");
            secNode.setAttribute("name", sec_name);
            rootNode.appendChild(secNode);
            // 客先単位
            for (var usr_name in Tab[sec_name].uName) {
                var EMG = Tab[sec_name].uName[usr_name]["EMG"]
                var usrNode = xmlDoc.createElement("客先");
                usrNode.setAttribute("name", usr_name);
                usrNode.setAttribute("emg", EMG);
                secNode.appendChild(usrNode);
                var uValue = [];
                // 月売り上げ
                for (var m in Tab[sec_name].uName[usr_name].data) {
                    var mNode = xmlDoc.createElement("月");
                    usrNode.appendChild(mNode);
                    var sValue = Tab[sec_name].uName[usr_name].data[m];
                    var sText = xmlDoc.createTextNode(sValue);
                    mNode.appendChild(sText);
                    total1[m] += sValue;
                    total2[m] += sValue;
                    if (m == 0) {
                        total2[m] = total1[m];
                    }
                    else {
                        total2[m] = total2[m - 1] + total1[m];
                    }
                }
            }

            if ( !IsEmpty(Tab[sec_name].uName) ) {
                var totalNode = xmlDoc.createElement("合計");
                var r_totalNode = xmlDoc.createElement("累計");
                for (i = 0; i < 12; i++) {
                    var mNode1 = xmlDoc.createElement("月");
                    var mNode2 = xmlDoc.createElement("月");
                    var sText1 = xmlDoc.createTextNode(total1[i]);
                    var sText2 = xmlDoc.createTextNode(total2[i]);
                    mNode1.appendChild(sText1);
                    mNode2.appendChild(sText2);
                    totalNode.appendChild(mNode1);
                    r_totalNode.appendChild(mNode2);
                }
                secNode.appendChild(totalNode);
                secNode.appendChild(r_totalNode);
            }
        }

    }

%>

<!--#include file = "売上予実_新規.inc.asp"-->
