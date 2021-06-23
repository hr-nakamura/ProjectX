using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Routing;
using System.Text.RegularExpressions;

using DebugHost;

namespace ProjectX
{
    public class WebApiApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            GlobalConfiguration.Configure(WebApiConfig.Register);
            DebugHost.Debug.Write("ABCDEF");
        }
        protected void Session_Start(object sender, EventArgs e)
        {
            Application.Lock();

            DebugHost.Debug.Write("ABCDEF");
            //Int32 user_count = (Int32)Application["user_count"];
            //user_count++;
            //Application["user_count"] = user_count;

            string bInfo = BrowserInfo();
            Dictionary<string, string> HistTab = (Dictionary<string, string>)Application["historyTab"];
            string sessionID = (string)this.Session.SessionID;
            string msg = "Session_Start" + "," + bInfo;
            //setLog(HistTab, sessionID, "--", msg, (Int32)Application["historyMode"]);

            Session["kansa"] = "Kansaw" + msg;
            Session["DB_connectString"] = "";

            Application.UnLock();
        }

        protected void Session_End(object sender, EventArgs e)
        {
            //Log.Write("Session_End");
            Application.Lock();

            //Int32 user_count = (Int32)Application["user_count"];
            //user_count--;
            //Application["user_count"] = user_count;

            string mail = (string)this.Session["loginMail"];
            Dictionary<string, string> InfoTab = (Dictionary<string, string>)Application["accessTab"];
            //DeleteAccess(InfoTab, mail);

            Dictionary<string, string> HistTab = (Dictionary<string, string>)Application["historyTab"];
            string sessionID = (string)this.Session.SessionID;
            string msg = "Session_End";
            //setLog(HistTab, sessionID, mail, msg, (Int32)Application["historyMode"]);

            Application.UnLock();
        }
        private void setLog(Dictionary<string, string> HistTab, string sessionID, string mail, string msg, Int32 historyMode)
        {
            if (historyMode == 1)
            {
                DateTime dt = DateTime.Now;
                HistTab.Add(dt.ToString("yyyy/MM/dd HH:mm:ss.fff"), sessionID + "," + mail + "," + msg);
            }
        }
        private string BrowserInfo()
        {
            string userAgent = "";
            string browser = "";
            string type = "";
            try
            {
                userAgent = Request.Browser.Capabilities[""].ToString();
                type = Request.Browser.Capabilities["type"].ToString();
                HttpBrowserCapabilities bc = Request.Browser;
            }
            catch (Exception ex)
            {

            }

            if (Regex.Match(userAgent, "iPhone", RegexOptions.IgnoreCase).Success)
            {
                browser = Regex.Match(userAgent, "iPhone", RegexOptions.IgnoreCase).Value;
            }
            else if (Regex.Match(userAgent, "Android", RegexOptions.IgnoreCase).Success)
            {
                browser = Regex.Match(userAgent, "Android", RegexOptions.IgnoreCase).Value;
            }
            else if (Regex.Match(userAgent, "edge", RegexOptions.IgnoreCase).Success)
            {
                browser = Regex.Match(userAgent, "edge", RegexOptions.IgnoreCase).Value;
            }
            else if (Regex.Match(userAgent, "chrome", RegexOptions.IgnoreCase).Success)
            {
                browser = Regex.Match(userAgent, "chrome", RegexOptions.IgnoreCase).Value;
            }
            else if (Regex.Match(userAgent, "safari", RegexOptions.IgnoreCase).Success)
            {
                browser = Regex.Match(userAgent, "safari", RegexOptions.IgnoreCase).Value;
            }
            else if (Regex.Match(userAgent, "opera", RegexOptions.IgnoreCase).Success)
            {
                browser = Regex.Match(userAgent, "opera", RegexOptions.IgnoreCase).Value;
            }
            else if (Regex.Match(userAgent, "OPR", RegexOptions.IgnoreCase).Success)
            {
                browser = Regex.Match(userAgent, "OPR", RegexOptions.IgnoreCase).Value;
            }
            else if (Regex.Match(userAgent, "msie", RegexOptions.IgnoreCase).Success)
            {
                browser = Regex.Match(userAgent, "msie", RegexOptions.IgnoreCase).Value;
            }
            else if (Regex.Match(userAgent, "trident", RegexOptions.IgnoreCase).Success)
            {
                browser = Regex.Match(userAgent, "trident", RegexOptions.IgnoreCase).Value;
            }
            if (type != "") browser = String.Concat(browser, "(", type, ")");
            return (browser);

        }

    }
}
