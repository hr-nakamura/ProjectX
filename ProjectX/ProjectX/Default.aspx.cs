using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;

using Util;
using DebugHost;

namespace ProjectX
{
    public partial class Default : System.Web.UI.Page
    {
        // DBコネクション
        //private SqlConnection con;
        HttpContext context = HttpContext.Current;

        // DB接続文字列
        public string DB_connectString = "";

        // コンストラクタ
        public Default()
        {
            // hostInfo設定
            try
            {
                DebugHost.Debug.Write("Default");

                var work = Init_DBInfo();

                HttpContext context = HttpContext.Current;
                //DB_connectString = (string)context.Session["DB_connectString"].ToString();
            }
            catch (Exception ex)
            {
                //Log.Write(ex.Message);
            }
        }
        private string Init_DBInfo()
        {
            /* データベース情報取得 */

            HttpContext context = HttpContext.Current;
            bool debug_mode = (context.Request.Url.Host == "localhost" ? true : false);
            if (debug_mode == false)
            {
                //string hostPath = context.Request.PhysicalApplicationPath;
                //debug_mode = (0 <= hostPath.IndexOf("wf_test") ? true : false);
            }

            string iFile = context.Server.MapPath("/ProjectX/App_Data/system.ini");
            IniFile ini = new IniFile(iFile);

            string DB_mode = "データベース";

            string _DataSource = ini.GetValue(DB_mode, "DataSource", "");
            string _UserID = ini.GetValue(DB_mode, "UserID", "");
            string _Password = ini.GetValue(DB_mode, "Password", "");
            string _InitialCatalog = ini.GetValue(DB_mode, "InitialCatalog", "");
            string _Title = ini.GetValue(DB_mode, "Title", "読込失敗");

            SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder();
            builder.DataSource = _DataSource;
            builder.UserID = _UserID;
            builder.Password = _Password;
            builder.InitialCatalog = _InitialCatalog;

            //Session["DB_connectString"] = builder.ConnectionString;

            var work = String.Concat("[", _DataSource, "][", _InitialCatalog, "");
            return (builder.ConnectionString);
        }

        protected void Page_Load(object sender, EventArgs e)
        {

        }
    }
}