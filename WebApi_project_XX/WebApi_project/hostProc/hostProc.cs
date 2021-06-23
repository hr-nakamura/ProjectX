using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using System.Data.SqlClient;
using System.Text;

using DebugHost;
using Util;

namespace WebApi_project.hostProc
{
    public class hostFunc
    {
        // DBコネクション
        public string DB_connectString = "";

        HttpContext context = HttpContext.Current;

        // DB接続文字列
        public hostFunc()
        {
            string mName = Environment.MachineName;
            Debug.Write("hostFunc Start", mName);
            string DB_mode = "データベース";
            switch (mName)
            {
                case "QOSMIO":
                    DB_mode = "データベース_QOSMIO";
                    break;
                case "SURFACE-PC":
                    DB_mode = "データベース_QOSMIO";
                    break;
                case "NAKAMURA-RD":
                    DB_mode = "データベース_naka";
                    break;
                default:
                    DB_mode = "データベース";
                    break;
            }


            HttpContext context = HttpContext.Current;
            string AppPath = context.Request.ApplicationPath;
            string iFile = context.Server.MapPath(AppPath + "/App_Data/system.ini");
            IniFile ini = new IniFile(iFile);



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
            DB_connectString = builder.ConnectionString;

            //return (builder.ConnectionString);


        }
        ~hostFunc()
        {
            Debug.Write("hostFunc End");

        }

        public void set_prev_Func(string name, string func_name)
        {
            HttpContext context = HttpContext.Current;
            context.Application[name] = func_name;
        }
        public string get_prev_Func(string name)
        {
            string work = "";
            try
            {
                HttpContext context = HttpContext.Current;
                work = (string)context.Application[name];

            }
            catch (Exception ex)
            {
                work = ex.Message;
                return (work);
            }
            finally
            {
                //work = "XYZ";
            }
            return (work);
        }
        public Dictionary<string, string> dbFunc_A()
        {
            SqlConnection DB;
            string s = "";
            string mail = "";
            Dictionary<string, string> Tab = new Dictionary<string, string>();

            DB = new SqlConnection(DB_connectString);
            DB.Open();
            Debug.Write("DB Open");
            try
            {

                StringBuilder sql = new StringBuilder("");
                sql.Append(" SELECT");
                sql.Append(" terminal = MAST.terminal,");
                sql.Append(" mail = MAST.mail");
                sql.Append(" FROM");
                sql.Append("    ログデータ MAST");
                //sql.Append(" WHERE");
                //sql.Append("    MAST.id = 2");


                SqlDataReader reader = dbRead1(DB,sql.ToString());
                Debug.Write("reader Start");


                while (reader.Read())
                {
                    s = (string)reader["terminal"];
                    mail = (string)reader["mail"];
                    Debug.Write(s,mail);
                    if (!Tab.ContainsKey(s))
                    {
                        Tab.Add(s, mail);
                    }
                }

                Debug.Write("reader Close");
                reader.Close();

            }
            catch(Exception ex)
            {
                Debug.WriteLog(ex.Message);
            }
            finally
            {
                Debug.Write("DB Close");
                DB.Close();
                Debug.Write("DB Dispose");
                DB.Dispose();
                Debug.Write("DB null");
                DB = null;
            }
            return (Tab);
        }

        public SqlDataReader dbRead1(SqlConnection DB, string sql)
        {
            SqlCommand cmd = null;
            try
            {
                Debug.Write("cmd Start");
                cmd = new SqlCommand(sql, DB);
                SqlDataReader reader = cmd.ExecuteReader();
                return (reader);
            }
            //catch(Exception ex)
            //{
            //    debug.WriteLog(ex.Message);
            //    return (null);
            //}
            finally
            {
                Debug.Write("cmd Dispose");
                cmd.Dispose();
                cmd = null;
            }
        }
    }

}
