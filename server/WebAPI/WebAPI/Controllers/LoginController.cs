using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class LoginController : ControllerBase
    {
        private readonly ILogger<LoginController> _logger;

        public LoginController(ILogger<LoginController> logger)
        {
            _logger = logger;
        }

        [HttpGet]
        public LoginResponse Get() => new LoginResponse(ok: false)
        {
            
        };

        public class LoginResponse
        {
            public bool Ok { get; } 

            public LoginResponse(bool ok)
            {
                Ok = ok;
            }
        }
    }
}
