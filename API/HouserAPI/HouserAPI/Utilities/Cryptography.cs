using System;
using System.Security.Cryptography;

namespace HouserAPI.Utilities
{
    public class Cryptography
    {
        public static string GenerateSalt(int saltLength = 32)
        {
            byte[] salt = new byte[saltLength];
            using (var random = new RNGCryptoServiceProvider())
            {
                random.GetNonZeroBytes(salt);
            }

            return Convert.ToBase64String(salt);
        }
    }
}
