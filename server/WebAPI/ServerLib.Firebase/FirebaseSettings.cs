using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServerLib.Firebase
{
    /// <summary>
    /// Settings specifying the parameters for how Firebase 
    /// should be used and accessed.
    /// </summary>
    public class FirebaseSettings
    {
        /// <summary>
        /// The file system path of the firebase service account
        /// credentials.
        /// </summary>
        public string FirebaseKeyPath { get; set; } = null;
    }
}
