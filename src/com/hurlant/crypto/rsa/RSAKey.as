// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.hurlant.crypto.rsa.RSAKey

package com.hurlant.crypto.rsa
{
    import com.hurlant.math.BigInteger;
    import com.hurlant.crypto.prng.Random;
    import flash.utils.ByteArray;
    import com.hurlant.util.Memory;
    import com.hurlant.crypto.tls.TLSError;

    public class RSAKey 
    {

        public var e:int;
        public var n:BigInteger;
        public var d:BigInteger;
        public var p:BigInteger;
        public var q:BigInteger;
        public var dmp1:BigInteger;
        public var dmq1:BigInteger;
        public var coeff:BigInteger;
        protected var canDecrypt:Boolean;
        protected var canEncrypt:Boolean;

        public function RSAKey(_arg_1:BigInteger, _arg_2:int, _arg_3:BigInteger=null, _arg_4:BigInteger=null, _arg_5:BigInteger=null, _arg_6:BigInteger=null, _arg_7:BigInteger=null, _arg_8:BigInteger=null)
        {
            this.n = _arg_1;
            this.e = _arg_2;
            this.d = _arg_3;
            this.p = _arg_4;
            this.q = _arg_5;
            this.dmp1 = _arg_6;
            this.dmq1 = _arg_7;
            this.coeff = _arg_8;
            this.canEncrypt = ((!(this.n == null)) && (!(this.e == 0)));
            this.canDecrypt = ((this.canEncrypt) && (!(this.d == null)));
        }

        public static function parsePublicKey(_arg_1:String, _arg_2:String):RSAKey
        {
            return (new RSAKey(new BigInteger(_arg_1, 16, true), parseInt(_arg_2, 16)));
        }

        public static function parsePrivateKey(_arg_1:String, _arg_2:String, _arg_3:String, _arg_4:String=null, _arg_5:String=null, _arg_6:String=null, _arg_7:String=null, _arg_8:String=null):RSAKey
        {
            if (_arg_4 == null)
            {
                return (new RSAKey(new BigInteger(_arg_1, 16, true), parseInt(_arg_2, 16), new BigInteger(_arg_3, 16, true)));
            };
            return (new RSAKey(new BigInteger(_arg_1, 16, true), parseInt(_arg_2, 16), new BigInteger(_arg_3, 16, true), new BigInteger(_arg_4, 16, true), new BigInteger(_arg_5, 16, true), new BigInteger(_arg_6, 16, true), new BigInteger(_arg_7, 16, true), new BigInteger(_arg_8, 16, true)));
        }

        public static function generate(_arg_1:uint, _arg_2:String):RSAKey
        {
            var _local_7:BigInteger;
            var _local_8:BigInteger;
            var _local_9:BigInteger;
            var _local_10:BigInteger;
            var _local_3:Random = new Random();
            var _local_4:uint = (_arg_1 >> 1);
            var _local_5:RSAKey = new RSAKey(null, 0, null);
            _local_5.e = parseInt(_arg_2, 16);
            var _local_6:BigInteger = new BigInteger(_arg_2, 16, true);
            while (true)
            {
                while (true)
                {
                    _local_5.p = bigRandom((_arg_1 - _local_4), _local_3);
                    if (((_local_5.p.subtract(BigInteger.ONE).gcd(_local_6).compareTo(BigInteger.ONE) == 0) && (_local_5.p.isProbablePrime(10)))) break;
                };
                while (true)
                {
                    _local_5.q = bigRandom(_local_4, _local_3);
                    if (((_local_5.q.subtract(BigInteger.ONE).gcd(_local_6).compareTo(BigInteger.ONE) == 0) && (_local_5.q.isProbablePrime(10)))) break;
                };
                if (_local_5.p.compareTo(_local_5.q) <= 0)
                {
                    _local_10 = _local_5.p;
                    _local_5.p = _local_5.q;
                    _local_5.q = _local_10;
                };
                _local_7 = _local_5.p.subtract(BigInteger.ONE);
                _local_8 = _local_5.q.subtract(BigInteger.ONE);
                _local_9 = _local_7.multiply(_local_8);
                if (_local_9.gcd(_local_6).compareTo(BigInteger.ONE) == 0)
                {
                    _local_5.n = _local_5.p.multiply(_local_5.q);
                    _local_5.d = _local_6.modInverse(_local_9);
                    _local_5.dmp1 = _local_5.d.mod(_local_7);
                    _local_5.dmq1 = _local_5.d.mod(_local_8);
                    _local_5.coeff = _local_5.q.modInverse(_local_5.p);
                    break;
                };
            };
            return (_local_5);
        }

        protected static function bigRandom(_arg_1:int, _arg_2:Random):BigInteger
        {
            if (_arg_1 < 2)
            {
                return (BigInteger.nbv(1));
            };
            var _local_3:ByteArray = new ByteArray();
            _arg_2.nextBytes(_local_3, (_arg_1 >> 3));
            _local_3.position = 0;
            var _local_4:BigInteger = new BigInteger(_local_3, 0, true);
            _local_4.primify(_arg_1, 1);
            return (_local_4);
        }


        public function getBlockSize():uint
        {
            return ((this.n.bitLength() + 7) / 8);
        }

        public function dispose():void
        {
            this.e = 0;
            this.n.dispose();
            this.n = null;
            Memory.gc();
        }

        public function encrypt(_arg_1:ByteArray, _arg_2:ByteArray, _arg_3:uint, _arg_4:Function=null):void
        {
            this._encrypt(this.doPublic, _arg_1, _arg_2, _arg_3, _arg_4, 2);
        }

        public function decrypt(_arg_1:ByteArray, _arg_2:ByteArray, _arg_3:uint, _arg_4:Function=null):void
        {
            this._decrypt(this.doPrivate2, _arg_1, _arg_2, _arg_3, _arg_4, 2);
        }

        public function sign(_arg_1:ByteArray, _arg_2:ByteArray, _arg_3:uint, _arg_4:Function=null):void
        {
            this._encrypt(this.doPrivate2, _arg_1, _arg_2, _arg_3, _arg_4, 1);
        }

        public function verify(_arg_1:ByteArray, _arg_2:ByteArray, _arg_3:uint, _arg_4:Function=null):void
        {
            this._decrypt(this.doPublic, _arg_1, _arg_2, _arg_3, _arg_4, 1);
        }

        private function _encrypt(_arg_1:Function, _arg_2:ByteArray, _arg_3:ByteArray, _arg_4:uint, _arg_5:Function, _arg_6:int):void
        {
            var _local_9:BigInteger;
            var _local_10:BigInteger;
            if (_arg_5 == null)
            {
                _arg_5 = this.pkcs1pad;
            };
            if (_arg_2.position >= _arg_2.length)
            {
                _arg_2.position = 0;
            };
            var _local_7:uint = this.getBlockSize();
            var _local_8:int = (_arg_2.position + _arg_4);
            while (_arg_2.position < _local_8)
            {
                _local_9 = new BigInteger(_arg_5(_arg_2, _local_8, _local_7, _arg_6), _local_7, true);
                _local_10 = _arg_1(_local_9);
                _local_10.toArray(_arg_3);
            };
        }

        private function _decrypt(_arg_1:Function, _arg_2:ByteArray, _arg_3:ByteArray, _arg_4:uint, _arg_5:Function, _arg_6:int):void
        {
            var _local_9:BigInteger;
            var _local_10:BigInteger;
            var _local_11:ByteArray;
            if (_arg_5 == null)
            {
                _arg_5 = this.pkcs1unpad;
            };
            if (_arg_2.position >= _arg_2.length)
            {
                _arg_2.position = 0;
            };
            var _local_7:uint = this.getBlockSize();
            var _local_8:int = (_arg_2.position + _arg_4);
            while (_arg_2.position < _local_8)
            {
                _local_9 = new BigInteger(_arg_2, _local_7, true);
                _local_10 = _arg_1(_local_9);
                _local_11 = _arg_5(_local_10, _local_7, _arg_6);
                if (_local_11 == null)
                {
                    throw (new TLSError("Decrypt error - padding function returned null!", TLSError.decode_error));
                };
                _arg_3.writeBytes(_local_11);
            };
        }

        private function pkcs1pad(_arg_1:ByteArray, _arg_2:int, _arg_3:uint, _arg_4:uint=2):ByteArray
        {
            var _local_8:Random;
            var _local_9:int;
            var _local_5:ByteArray = new ByteArray();
            var _local_6:uint = _arg_1.position;
            _arg_2 = Math.min(_arg_2, _arg_1.length, ((_local_6 + _arg_3) - 11));
            _arg_1.position = _arg_2;
            var _local_7:int = (_arg_2 - 1);
            while (((_local_7 >= _local_6) && (_arg_3 > 11)))
            {
                var _local_10:* = --_arg_3;
                _local_5[_local_10] = _arg_1[_local_7--];
            };
            _local_10 = --_arg_3;
            _local_5[_local_10] = 0;
            if (_arg_4 == 2)
            {
                _local_8 = new Random();
                _local_9 = 0;
                while (_arg_3 > 2)
                {
                    do 
                    {
                        _local_9 = _local_8.nextByte();
                    } while (_local_9 == 0);
                    var _local_11:* = --_arg_3;
                    _local_5[_local_11] = _local_9;
                };
            }
            else
            {
                while (_arg_3 > 2)
                {
                    _local_11 = --_arg_3;
                    _local_5[_local_11] = 0xFF;
                };
            };
            _local_11 = --_arg_3;
            _local_5[_local_11] = _arg_4;
            var _local_12:* = --_arg_3;
            _local_5[_local_12] = 0;
            return (_local_5);
        }

        private function pkcs1unpad(_arg_1:BigInteger, _arg_2:uint, _arg_3:uint=2):ByteArray
        {
            var _local_4:ByteArray = _arg_1.toByteArray();
            var _local_5:ByteArray = new ByteArray();
            _local_4.position = 0;
            var _local_6:int;
            while (((_local_6 < _local_4.length) && (_local_4[_local_6] == 0)))
            {
                _local_6++;
            };
            if (((!((_local_4.length - _local_6) == (_arg_2 - 1))) || (!(_local_4[_local_6] == _arg_3))))
            {
                trace(((((("PKCS#1 unpad: i=" + _local_6) + ", expected b[i]==") + _arg_3) + ", got b[i]=") + _local_4[_local_6].toString(16)));
                return (null);
            };
            _local_6++;
            while (_local_4[_local_6] != 0)
            {
                if (++_local_6 >= _local_4.length)
                {
                    trace((((("PKCS#1 unpad: i=" + _local_6) + ", b[i-1]!=0 (=") + _local_4[(_local_6 - 1)].toString(16)) + ")"));
                    return (null);
                };
            };
            while (++_local_6 < _local_4.length)
            {
                _local_5.writeByte(_local_4[_local_6]);
            };
            _local_5.position = 0;
            return (_local_5);
        }

        public function rawpad(_arg_1:ByteArray, _arg_2:int, _arg_3:uint, _arg_4:uint=0):ByteArray
        {
            return (_arg_1);
        }

        public function rawunpad(_arg_1:BigInteger, _arg_2:uint, _arg_3:uint=0):ByteArray
        {
            return (_arg_1.toByteArray());
        }

        public function toString():String
        {
            return ("rsa");
        }

        public function dump():String
        {
            var _local_1:* = ((((("N=" + this.n.toString(16)) + "\n") + "E=") + this.e.toString(16)) + "\n");
            if (this.canDecrypt)
            {
                _local_1 = (_local_1 + (("D=" + this.d.toString(16)) + "\n"));
                if (((!(this.p == null)) && (!(this.q == null))))
                {
                    _local_1 = (_local_1 + (("P=" + this.p.toString(16)) + "\n"));
                    _local_1 = (_local_1 + (("Q=" + this.q.toString(16)) + "\n"));
                    _local_1 = (_local_1 + (("DMP1=" + this.dmp1.toString(16)) + "\n"));
                    _local_1 = (_local_1 + (("DMQ1=" + this.dmq1.toString(16)) + "\n"));
                    _local_1 = (_local_1 + (("IQMP=" + this.coeff.toString(16)) + "\n"));
                };
            };
            return (_local_1);
        }

        protected function doPublic(_arg_1:BigInteger):BigInteger
        {
            return (_arg_1.modPowInt(this.e, this.n));
        }

        protected function doPrivate2(_arg_1:BigInteger):BigInteger
        {
            if (((this.p == null) && (this.q == null)))
            {
                return (_arg_1.modPow(this.d, this.n));
            };
            var _local_2:BigInteger = _arg_1.mod(this.p).modPow(this.dmp1, this.p);
            var _local_3:BigInteger = _arg_1.mod(this.q).modPow(this.dmq1, this.q);
            while (_local_2.compareTo(_local_3) < 0)
            {
                _local_2 = _local_2.add(this.p);
            };
            var _local_4:BigInteger = _local_2.subtract(_local_3).multiply(this.coeff).mod(this.p).multiply(this.q).add(_local_3);
            return (_local_4);
        }

        protected function doPrivate(_arg_1:BigInteger):BigInteger
        {
            if (((this.p == null) || (this.q == null)))
            {
                return (_arg_1.modPow(this.d, this.n));
            };
            var _local_2:BigInteger = _arg_1.mod(this.p).modPow(this.dmp1, this.p);
            var _local_3:BigInteger = _arg_1.mod(this.q).modPow(this.dmq1, this.q);
            while (_local_2.compareTo(_local_3) < 0)
            {
                _local_2 = _local_2.add(this.p);
            };
            return (_local_2.subtract(_local_3).multiply(this.coeff).mod(this.p).multiply(this.q).add(_local_3));
        }


    }
}//package com.hurlant.crypto.rsa

