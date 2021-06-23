using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text.RegularExpressions;
using DebugHost;

namespace WebApi_project._home.debug
{
    /// <summary>
    /// debug の概要の説明です
    /// </summary>
    public class debug : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            //context.Response.Write("Hello World");
            string LogData = context.Request.Form["LogData"];
            LogData = Regex.Replace(LogData, "&amp;", "&");
            LogData = Regex.Replace(LogData, "&lt;", "<");
            LogData = Regex.Replace(LogData, "&gt;", ">");
            LogData = Regex.Replace(LogData, "&apos;", "\'");
            LogData = Regex.Replace(LogData, "&Quot;", "\"");
            DebugHost.Debug.Note(LogData);
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}