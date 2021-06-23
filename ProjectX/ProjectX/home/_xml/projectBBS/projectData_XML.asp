<%@ Language=JavaScript %>
<!--#include virtual = "/ProjectX/home/_inc/cmn.inc"-->
<!--#include virtual = "/ProjectX/home/_inc/確定日付.inc"-->
<!--#include virtual = "/ProjectX/home/_inc/JSon.inc"-->
<%
try{

   	var limitYear = makeYear() - 2

   var memberID = Session("memberID")

   var mode = String(Request.QueryString("mode"))

   if( mode == "undefined" ) mode = 1

	//EMGLog.Write("test.txt","========",mode,limitYear);


//----- 掲示板のNEWを出す日を設定----------------------------

	var visitDay	= readCookies("visitBBS");
	var beforDay = new Date();
	var bDate = DateAdd( "d", -7, convertDateTime(beforDay));
	beforDay= new Date(bDate);
	beforDay.setHours(0);
	beforDay.setMinutes(0);
	beforDay.setSeconds(0);
//------ 日付を合わす　---------------------------
	if(visitDay < beforDay) visitDay = beforDay;
//---------------------------------
	Session("visitBBS") = visitDay.toString();
	Session("beforBBS") = beforDay.toString();
	Session("dispMode") = "更新";

//	Session("visitBBS")	= readCookies("visitBBS");
//	if(IsEmpty(Session("visitBBS"))) Session("visitBBS") = new Date("1999/1/1");

    var beforBBS = convertDateTime(new Date(Session("beforBBS")))
    var visitBBS = convertDateTime(new Date(Session("visitBBS")))
	var memberID	= Session("memberID")
	var userName	= Session("userName")

    var Tab = dispProject(mode,limitYear)

    var json = $queryString("json", "0");
	if( json == "1" ){
		var Info = {
			mode:mode,
			limitYear:limitYear,
			beforBBS:beforBBS,
			visitBBS:visitBBS,
			memberID:memberID,
			userName:userName
			};
		$JsonOut_P(Tab);
		}
	else{
		var xmlDoc = makeXMLDoc(Tab, 2021)
		
//	var Nodes = xmlDoc.selectNodes("//root/projectNumList/pNum[@newFlag=0]")
//	var Nodes = xmlDoc.selectNodes("//root/projectNumList/pNum[@Stat!=-1]")
//	Nodes.removeAll()

        Response.CharSet = "SHIFT_JIS";
        Response.AddHeader("Access-Control-Allow-Origin", "*");
        Response.ContentType = "text/xml"
        xmlDoc.save(Response)
		}
		
}catch(e){
	p(e.message);
	//EMGLog.Write("test.txt",e.message);
	}
/*
    var para = {};
    try {

        var eMsg = "OK";

        //para.year = $queryString("year", 2018);
        //para.actual = $queryString("actual", 12);
        //para.fix = $queryString("fix", 70);
        //$JsonOut(para);

        year = 2019;

        var Tab = dispProject_Json(0, 2018);
        //$JsonOut(Tab);

        //===========================================================================

//        var Tab = getJSONData();
        var xmlDoc = makeXMLDoc(Tab, year);

        Response.CharSet = "SHIFT_JIS";
        Response.AddHeader("Access-Control-Allow-Origin", "*");
        Response.ContentType = "text/xml"
        xmlDoc.save(Response)

    } catch (e) {
        pr(e.message + "][" + path);
    }
*/
%>
<%
// 作成するコードの年度作成   
function makeYear()
   {
   var toDay = new Date()
   var yy = toDay.getFullYear()
   var mm = toDay.getMonth()+1
   var Year
//	Year = ( mm >= 3 ? yy : yy - 1 )			// 3月から新年度用のコード
	Year = yy
   return(Year)
   }
%>
<%
    function makeXMLDoc(Tab, year) {
        var xmlDoc = Server.CreateObject("Microsoft.XMLDom")
        xmlDoc.async = false

        var main1 = xmlDoc.createProcessingInstruction("xml", "version='1.0' encoding='Shift_JIS'")
        xmlDoc.appendChild(main1)

        var rootNode = xmlDoc.createElement("root")
        xmlDoc.appendChild(rootNode)

        try {
            setInfoNode(rootNode, "基本情報", Tab.info);
            setInfoNode(rootNode, "表示情報", Tab.head);

            makeXMLData(rootNode, Tab);
        }
        catch (e) {
//            var commentNode = xmlDoc.createComment("ERROR:" + e.message);
//            xmlDoc.insertBefore(commentNode, rootNode);
        }

//        var commentNode = xmlDoc.createComment(year);
//        xmlDoc.insertBefore(commentNode, rootNode);

        return (xmlDoc);
    }
    function setInfoNode(rootNode, titleStr, Tab) {
        var xmlDoc = rootNode.ownerDocument;
        var infoNode = xmlDoc.createElement(titleStr);
        rootNode.appendChild(infoNode);
        for (var n in Tab) {
//            if (item == "data") continue;
            var node = xmlDoc.createElement("item");
            node.setAttribute("name", n);
            var textNode = xmlDoc.createTextNode(Tab[n]);
            node.appendChild(textNode);
            infoNode.appendChild(node);
        }
    }

    function makeXMLData(rootNode, Tab) {
        var xmlDoc = rootNode.ownerDocument;
        var pNumListNode = xmlDoc.createElement("projectNumList");
        rootNode.appendChild(pNumListNode);

        for (var i in Tab.data) {
            var pNumNode = xmlDoc.createElement("pNum");
            pNumListNode.appendChild(pNumNode);
            var data = Tab.data[i];
            var itemTab = Tab.head;
            for (var itemNo in itemTab) {
                var itemName = itemTab[itemNo];
                pNumNode.setAttribute(itemName, data[itemNo]);
            }

        }

    }

%>


<!--#include file = "projectDataCsv.inc.asp"-->