using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServerLib
{
    public enum AuthorizationLevel
    {
        Unauthorized = 0,
        User = 1,
        Admin = 2
    }
}
