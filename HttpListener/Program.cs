using System.Net;
using System.Text;

public class HttpServer
{
    private static bool _keepRunning = true;
    private HttpListener _listener;
    public int Port = 8080;

    public void SimpleListenerExample()
    {
        _listener = new HttpListener();
        _listener.Prefixes.Add("http://localhost:" + Port + "/");
        _listener.Start();
        Receive();
        Console.WriteLine("Listening...");
        var context = _listener.GetContext();
        var request = context.Request;
        var response = context.Response;
        var responseString = "<HTML><BODY> Hello world!</BODY></HTML>";
        var buffer = Encoding.UTF8.GetBytes(responseString);
        response.ContentLength64 = buffer.Length;
        var output = response.OutputStream;
        output.Write(buffer, 0, buffer.Length);
        output.Close();
        _listener.Stop();
    }

    public void Start()
    {
        _listener = new HttpListener();
        _listener.Prefixes.Add("http://localhost:8080/");
        _listener.Start();
        Receive();
        Console.WriteLine("test");
        var context = _listener.GetContext();
        var request = context.Request;
        var response = context.Response;
        var responseString = "<HTML><BODY> Hello world!</BODY></HTML>";
        var buffer = Encoding.UTF8.GetBytes(responseString);
        response.ContentLength64 = buffer.Length;
        var output = response.OutputStream;
        output.Write(buffer, 0, buffer.Length);
        output.Close();
        Console.WriteLine("WTF");
    }

    public void Stop()
    {
        _listener.Stop();
    }

    private void Receive()
    {
        _listener.BeginGetContext(ListenerCallback, _listener);
    }

    private void ListenerCallback(IAsyncResult result)
    {
        if (_listener.IsListening)
        {
            var context = _listener.EndGetContext(result);
            var request = context.Request;
            // do something with the request
            Console.WriteLine($"{request.Url}");
            Receive();
        }
    }

    /*public static void Main(string[] args)
    {
        /*Console.CancelKeyPress += delegate(object sender, ConsoleCancelEventArgs e)
        {
            e.Cancel = true;
            HttpServer._keepRunning = false;
        };#1#
        Console.WriteLine("Starting HTTP listener...");
        var httpServer = new HttpServer();
        httpServer.Start();
        while (HttpServer._keepRunning) { }
        httpServer.Stop();
        Console.WriteLine("Exiting gracefully...");
    }*/
}