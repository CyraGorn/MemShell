using System.Web.Hosting;

namespace VirtualPathTest
{
    /// <summary>
    ///   Contains the application initialization method
    ///   for the sample application.
    /// </summary>
    public static class AppStart
    {
        public static void AppInitialize()
        {
            SamplePathProvider sampleProvider = new SamplePathProvider();
            HostingEnvironment.RegisterVirtualPathProvider(sampleProvider);
        }
    }
}