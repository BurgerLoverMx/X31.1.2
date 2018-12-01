// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.hurlant.util.der.PEM

package com.hurlant.util.der
{
    import flash.utils.ByteArray;
    import com.hurlant.crypto.rsa.RSAKey;
    import com.hurlant.util.Base64;

    public class PEM 
    {

        private static const RSA_PRIVATE_KEY_HEADER:String = "-----BEGIN RSA PRIVATE KEY-----";
        private static const RSA_PRIVATE_KEY_FOOTER:String = "-----END RSA PRIVATE KEY-----";
        private static const RSA_PUBLIC_KEY_HEADER:String = "-----BEGIN PUBLIC KEY-----";
        private static const RSA_PUBLIC_KEY_FOOTER:String = "-----END PUBLIC KEY-----";
        private static const CERTIFICATE_HEADER:String = "-----BEGIN CERTIFICATE-----";
        private static const CERTIFICATE_FOOTER:String = "-----END CERTIFICATE-----";


        public static function readRSAPrivateKey(_arg_1:String):RSAKey
        {
            var _local_4:Array;
            var _local_2:ByteArray = extractBinary(RSA_PRIVATE_KEY_HEADER, RSA_PRIVATE_KEY_FOOTER, _arg_1);
            if (_local_2 == null)
            {
                return (null);
            };
            var _local_3:* = DER.parse(_local_2);
            if ((_local_3 is Array))
            {
                _local_4 = (_local_3 as Array);
                return (new RSAKey(_local_4[1], _local_4[2].valueOf(), _local_4[3], _local_4[4], _local_4[5], _local_4[6], _local_4[7], _local_4[8]));
            };
            return (null);
        }

        public static function readRSAPublicKey(_arg_1:String):RSAKey
        {
            var _local_4:Array;
            var _local_2:ByteArray = extractBinary(RSA_PUBLIC_KEY_HEADER, RSA_PUBLIC_KEY_FOOTER, _arg_1);
            if (_local_2 == null)
            {
                return (null);
            };
            var _local_3:* = DER.parse(_local_2);
            if ((_local_3 is Array))
            {
                _local_4 = (_local_3 as Array);
                if (_local_4[0][0].toString() != OID.RSA_ENCRYPTION)
                {
                    return (null);
                };
                if (_local_4[1][_local_4[1].position] == 0)
                {
                    _local_4[1].position++;
                };
                _local_3 = DER.parse(_local_4[1]);
                if ((_local_3 is Array))
                {
                    _local_4 = (_local_3 as Array);
                    return (new RSAKey(_local_4[0], _local_4[1]));
                };
                return (null);
            };
            return (null);
        }

        public static function readCertIntoArray(_arg_1:String):ByteArray
        {
            return (extractBinary(CERTIFICATE_HEADER, CERTIFICATE_FOOTER, _arg_1));
        }

        private static function extractBinary(_arg_1:String, _arg_2:String, _arg_3:String):ByteArray
        {
            var _local_4:int = _arg_3.indexOf(_arg_1);
            if (_local_4 == -1)
            {
                return (null);
            };
            _local_4 = (_local_4 + _arg_1.length);
            var _local_5:int = _arg_3.indexOf(_arg_2);
            if (_local_5 == -1)
            {
                return (null);
            };
            var _local_6:String = _arg_3.substring(_local_4, _local_5);
            _local_6 = _local_6.replace(/\s/mg, "");
            return (Base64.decodeToByteArray(_local_6));
        }


    }
}//package com.hurlant.util.der

