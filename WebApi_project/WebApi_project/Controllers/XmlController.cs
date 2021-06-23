using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Xml;
using Newtonsoft.Json;
using WebApi_project.Models;
using System.Web;

using DebugHost;

namespace WebApi_project.Controllers
{
    public class XmlController : ApiController
    {
        // GET api/<controller>
        //public object Get()
        //{
        //    object work = new { a = "value1", b = "value2" };
        //    return work;
        //}

        // GET api/<controller>/5
        public string Get()
        {
            Debug.Write("Get-0");
            XmlDocument xmlDoc = makeXmlDoc("GET-0");
            return (xmlDoc.OuterXml);

        }
        public string Get(string Item, string Func, string Json)
        {
            Debug.Write("Get");
            var work = new List<string>();
            work.Add(Item);
            work.Add(Func);
            work.Add(Json);
            var deserialized = JsonConvert.DeserializeObject<SampleData>(Json);

            XmlDocument xmlDoc = makeXmlDoc("GET" + "[" + string.Join("][",work)+ "]");
            return (xmlDoc.OuterXml);

        }

        // POST api/<controller>

        public string Post([FromBody] ProjectJson para)
        {

            Debug.Write("Post");


            HttpContext context = HttpContext.Current;
            var Request = context.Request;
            var work1 = Request.UrlReferrer.Host;
            var work2 = Request.UrlReferrer.LocalPath;
            var work3 = Request.UrlReferrer.Port;
            ////Debug.Write(work);

            var work = new List<string>();
            work.Add(para.Item);
            work.Add(para.Func);
            work.Add(para.Json);

            XmlDocument xmlDoc = makeXmlDoc("POST" + "[" + string.Join("][", work) + "]");
            return (xmlDoc.OuterXml);
        }


        // PUT api/<controller>/5
        public string Put([FromBody] ProjectJson para)
        {
            Debug.Write("Put");
            var work = new List<string>();
            work.Add(para.Item);
            work.Add(para.Func);
            work.Add(para.Json);
            XmlDocument xmlDoc = makeXmlDoc("PUT" + "[" + string.Join("][", work) + "]");
            return (xmlDoc.OuterXml);
        }

        // DELETE api/<controller>/5
        public void Delete(int id)
        {
            Debug.Write("Delete");
        }
        public XmlDocument makeXmlDoc(string Func)
        {
            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.CreateXmlDeclaration("1.0", null, null);

            var xmlMain = xmlDoc.CreateProcessingInstruction("xml", "version='1.0' encoding='Shift_JIS'");
            XmlElement root = xmlDoc.CreateElement("root");
            XmlElement data1 = xmlDoc.CreateElement("data");
            XmlElement data2 = xmlDoc.CreateElement("data");

            var comment = xmlDoc.CreateComment(Func);
            xmlDoc.AppendChild(xmlMain);
            xmlDoc.AppendChild(root);
            root.AppendChild(comment);
            root.AppendChild(data1);
            root.AppendChild(data2);
            data2.InnerText = "A123";
            data2.SetAttribute("class", "c123");
            data2.SetAttribute("id", "id123");
            data1.InnerText = "A111";
            data1.SetAttribute("class", "c1112");
            data1.SetAttribute("id", "id111");
            return (xmlDoc);

        }
        class SampleData
        {
            public string a { get; set; }
            public string b { get; set; }
        }
    }
}