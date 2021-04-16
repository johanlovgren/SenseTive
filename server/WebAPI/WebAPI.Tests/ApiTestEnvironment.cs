using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.TestHost;
using Microsoft.Extensions.Hosting;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;

namespace WebAPI.Tests
{
    public class ApiTestEnvironment
    {
        public TestServer Server { get; }
        public HttpClient Client { get; }

        public Uri Hostname { get; }

        public const string TestSecret1 = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
        public const string TestSecret2 = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaab";

        public string[] TestSecrets { get; } = { TestSecret1, TestSecret2 };

        public ApiTestEnvironment()
        {
            var hostBuilder = WebAPI.Program.CreateHostBuilder(Array.Empty<string>());
            var host = hostBuilder.Build();

            Server = new TestServer(host.Services);
            Hostname = Server.BaseAddress;

            Client = new HttpClient();
        }
    }
}
