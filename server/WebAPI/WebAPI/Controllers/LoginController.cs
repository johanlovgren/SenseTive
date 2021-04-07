using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

using ServerLib;
using ServerLib.Data;

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
        private readonly Database _database;

        public LoginController(ILogger<LoginController> logger, Database database)
        {
            _logger = logger;
            _database = database;
        }

        [HttpPost]
        [Route("/[controller]")]
        public LoginResponse Login([FromBody] LoginRequest request)
        {
            return new LoginResponse(ok: false)
            {
            
            };
        }

        public class LoginResponse
        {
            public bool Ok { get; } 

            public LoginResponse(bool ok)
            {
                Ok = ok;
            }
        }

        public class LoginRequest
        {
            public LoginMethod Method { get; set; }
            public string Idenfifier { get; set; }
        }
    }
}
