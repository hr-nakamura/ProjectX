using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApi_project.Models
{
    public class Common
    {
        public string MessageText { get; set; }
        public string UserName { get; set; }
    }
    public class FuncMode
    {
        public string Func { get; set; }
        public string Para { get; set; }
    }
    public class Project
    {
        public string Terminal { get; set; }
        public string Name { get; set; }
        public string Message { get; set; }
    }
    public class ProjectJson
    {
        public string Item { get; set; }
        public string Func { get; set; }
        public string Json { get; set; }
    }
}