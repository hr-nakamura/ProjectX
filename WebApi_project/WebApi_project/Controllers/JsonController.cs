using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Newtonsoft.Json;
using System.Data.SqlClient;

namespace WebApi_project.Controllers
{
    public class JsonController : ApiController
    {
        // GET api/<controller>
        public object Get()
        {
            object work = new { a = "value1", b = "value2" };
            //object work = new { };
            var src = new List<string> { "abc", "123" };
            string output = JsonConvert.SerializeObject(src);
            SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder();
            builder.DataSource = "_DataSource";
            builder.UserID = "_UserID";
            builder.Password = "_Password";
            builder.InitialCatalog = "_InitialCatalog";


            return builder;
        }

        // GET api/<controller>/5
        public string Get(int id)
        {
            return "value";
        }

        // POST api/<controller>
        public void Post([FromBody] string value)
        {
        }

        // PUT api/<controller>/5
        public void Put(int id, [FromBody] string value)
        {
        }

        // DELETE api/<controller>/5
        public void Delete(int id)
        {
        }
    }
}