// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.hurlant.math.BigInteger

package com.hurlant.math
{
    import flash.utils.ByteArray;
    import com.hurlant.util.Hex;
    import com.hurlant.crypto.prng.Random;
    import com.hurlant.util.Memory;
    import com.hurlant.math.bi_internal;

    use namespace bi_internal;

    public class BigInteger 
    {

        public static const DB:int = 30;
        public static const DV:int = (1 << DB);
        public static const DM:int = (DV - 1);
        public static const BI_FP:int = 52;
        public static const FV:Number = Math.pow(2, BI_FP);
        public static const F1:int = (BI_FP - DB);//22
        public static const F2:int = ((2 * DB) - BI_FP);//8
        public static const ZERO:BigInteger = nbv(0);
        public static const ONE:BigInteger = nbv(1);
        public static const lowprimes:Array = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251, 0x0101, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397, 401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499, 503, 509];
        public static const lplim:int = ((1 << 26) / lowprimes[(lowprimes.length - 1)]);

        public var t:int;
        bi_internal var s:int;
        bi_internal var a:Array;

        public function BigInteger(_arg_1:*=null, _arg_2:int=0, _arg_3:Boolean=false)
        {
            var _local_4:ByteArray;
            var _local_5:int;
            super();
            this.a = new Array();
            if ((_arg_1 is String))
            {
                if (((_arg_2) && (!(_arg_2 == 16))))
                {
                    throw (new Error("BigInteger construction with radix!=16 is not supported."));
                };
                _arg_1 = Hex.toArray(_arg_1);
                _arg_2 = 0;
            };
            if ((_arg_1 is ByteArray))
            {
                _local_4 = (_arg_1 as ByteArray);
                _local_5 = ((_arg_2) || (_local_4.length - _local_4.position));
                this.fromArray(_local_4, _local_5, _arg_3);
            };
        }

        public static function nbv(_arg_1:int):BigInteger
        {
            var _local_2:BigInteger = new (BigInteger)();
            _local_2.fromInt(_arg_1);
            return (_local_2);
        }


        public function dispose():void
        {
            var _local_1:Random = new Random();
            var _local_2:uint;
            while (_local_2 < this.a.length)
            {
                this.a[_local_2] = _local_1.nextByte();
                delete this.a[_local_2];
                _local_2++;
            };
            this.a = null;
            this.t = 0;
            this.s = 0;
            Memory.gc();
        }

        public function toString(_arg_1:Number=16):String
        {
            var _local_2:int;
            if (this.s < 0)
            {
                return ("-" + this.negate().toString(_arg_1));
            };
            switch (_arg_1)
            {
                case 2:
                    _local_2 = 1;
                    break;
                case 4:
                    _local_2 = 2;
                    break;
                case 8:
                    _local_2 = 3;
                    break;
                case 16:
                    _local_2 = 4;
                    break;
                case 32:
                    _local_2 = 5;
                    break;
            };
            var _local_3:int = ((1 << _local_2) - 1);
            var _local_4:int;
            var _local_5:Boolean;
            var _local_6:* = "";
            var _local_7:int = this.t;
            var _local_8:int = (DB - ((_local_7 * DB) % _local_2));
            if (_local_7-- > 0)
            {
                if (((_local_8 < DB) && ((_local_4 = (this.a[_local_7] >> _local_8)) > 0)))
                {
                    _local_5 = true;
                    _local_6 = _local_4.toString(36);
                };
                while (_local_7 >= 0)
                {
                    if (_local_8 < _local_2)
                    {
                        _local_4 = ((this.a[_local_7] & ((1 << _local_8) - 1)) << (_local_2 - _local_8));
                        _local_4 = (_local_4 | (this.a[--_local_7] >> (_local_8 = (_local_8 + (DB - _local_2)))));
                    }
                    else
                    {
                        _local_4 = ((this.a[_local_7] >> (_local_8 = (_local_8 - _local_2))) & _local_3);
                        if (_local_8 <= 0)
                        {
                            _local_8 = (_local_8 + DB);
                            _local_7--;
                        };
                    };
                    if (_local_4 > 0)
                    {
                        _local_5 = true;
                    };
                    if (_local_5)
                    {
                        _local_6 = (_local_6 + _local_4.toString(36));
                    };
                };
            };
            return ((_local_5) ? _local_6 : "0");
        }

        public function toArray(_arg_1:ByteArray):uint
        {
            var _local_2:int = 8;
            var _local_3:int = ((1 << 8) - 1);
            var _local_4:int;
            var _local_5:int = this.t;
            var _local_6:int = (DB - ((_local_5 * DB) % _local_2));
            var _local_7:Boolean;
            var _local_8:int;
            if (_local_5-- > 0)
            {
                if (((_local_6 < DB) && ((_local_4 = (this.a[_local_5] >> _local_6)) > 0)))
                {
                    _local_7 = true;
                    _arg_1.writeByte(_local_4);
                    _local_8++;
                };
                while (_local_5 >= 0)
                {
                    if (_local_6 < _local_2)
                    {
                        _local_4 = ((this.a[_local_5] & ((1 << _local_6) - 1)) << (_local_2 - _local_6));
                        _local_4 = (_local_4 | (this.a[--_local_5] >> (_local_6 = (_local_6 + (DB - _local_2)))));
                    }
                    else
                    {
                        _local_4 = ((this.a[_local_5] >> (_local_6 = (_local_6 - _local_2))) & _local_3);
                        if (_local_6 <= 0)
                        {
                            _local_6 = (_local_6 + DB);
                            _local_5--;
                        };
                    };
                    if (_local_4 > 0)
                    {
                        _local_7 = true;
                    };
                    if (_local_7)
                    {
                        _arg_1.writeByte(_local_4);
                        _local_8++;
                    };
                };
            };
            return (_local_8);
        }

        public function valueOf():Number
        {
            if (this.s == -1)
            {
                return (-(this.negate().valueOf()));
            };
            var _local_1:Number = 1;
            var _local_2:Number = 0;
            var _local_3:uint;
            while (_local_3 < this.t)
            {
                _local_2 = (_local_2 + (this.a[_local_3] * _local_1));
                _local_1 = (_local_1 * DV);
                _local_3++;
            };
            return (_local_2);
        }

        public function negate():BigInteger
        {
            var _local_1:BigInteger = this.nbi();
            ZERO.subTo(this, _local_1);
            return (_local_1);
        }

        public function abs():BigInteger
        {
            return ((this.s < 0) ? this.negate() : this);
        }

        public function compareTo(_arg_1:BigInteger):int
        {
            var _local_2:int = (this.s - _arg_1.s);
            if (_local_2 != 0)
            {
                return (_local_2);
            };
            var _local_3:int = this.t;
            _local_2 = (_local_3 - _arg_1.t);
            if (_local_2 != 0)
            {
                return (_local_2);
            };
            while (--_local_3 >= 0)
            {
                _local_2 = (this.a[_local_3] - _arg_1.a[_local_3]);
                if (_local_2 != 0)
                {
                    return (_local_2);
                };
            };
            return (0);
        }

        bi_internal function nbits(_arg_1:int):int
        {
            var _local_3:int;
            var _local_2:int = 1;
            if ((_local_3 = (_arg_1 >>> 16)) != 0)
            {
                _arg_1 = _local_3;
                _local_2 = (_local_2 + 16);
            };
            if ((_local_3 = (_arg_1 >> 8)) != 0)
            {
                _arg_1 = _local_3;
                _local_2 = (_local_2 + 8);
            };
            if ((_local_3 = (_arg_1 >> 4)) != 0)
            {
                _arg_1 = _local_3;
                _local_2 = (_local_2 + 4);
            };
            if ((_local_3 = (_arg_1 >> 2)) != 0)
            {
                _arg_1 = _local_3;
                _local_2 = (_local_2 + 2);
            };
            if ((_local_3 = (_arg_1 >> 1)) != 0)
            {
                _arg_1 = _local_3;
                _local_2 = (_local_2 + 1);
            };
            return (_local_2);
        }

        public function bitLength():int
        {
            if (this.t <= 0)
            {
                return (0);
            };
            return ((DB * (this.t - 1)) + this.nbits((this.a[(this.t - 1)] ^ (this.s & DM))));
        }

        public function mod(_arg_1:BigInteger):BigInteger
        {
            var _local_2:BigInteger = this.nbi();
            this.abs().divRemTo(_arg_1, null, _local_2);
            if (((this.s < 0) && (_local_2.compareTo(ZERO) > 0)))
            {
                _arg_1.subTo(_local_2, _local_2);
            };
            return (_local_2);
        }

        public function modPowInt(_arg_1:int, _arg_2:BigInteger):BigInteger
        {
            var _local_3:IReduction;
            if (((_arg_1 < 0x0100) || (_arg_2.isEven())))
            {
                _local_3 = new ClassicReduction(_arg_2);
            }
            else
            {
                _local_3 = new MontgomeryReduction(_arg_2);
            };
            return (this.exp(_arg_1, _local_3));
        }

        bi_internal function copyTo(_arg_1:BigInteger):void
        {
            var _local_2:int = (this.t - 1);
            while (_local_2 >= 0)
            {
                _arg_1.a[_local_2] = this.a[_local_2];
                _local_2--;
            };
            _arg_1.t = this.t;
            _arg_1.s = this.s;
        }

        bi_internal function fromInt(_arg_1:int):void
        {
            this.t = 1;
            this.s = ((_arg_1 < 0) ? -1 : 0);
            if (_arg_1 > 0)
            {
                this.a[0] = _arg_1;
            }
            else
            {
                if (_arg_1 < -1)
                {
                    this.a[0] = (_arg_1 + DV);
                }
                else
                {
                    this.t = 0;
                };
            };
        }

        bi_internal function fromArray(_arg_1:ByteArray, _arg_2:int, _arg_3:Boolean=false):void
        {
            var _local_8:int;
            var _local_4:int = _arg_1.position;
            var _local_5:int = (_local_4 + _arg_2);
            var _local_6:int;
            var _local_7:int = 8;
            this.t = 0;
            this.s = 0;
            while (--_local_5 >= _local_4)
            {
                _local_8 = ((_local_5 < _arg_1.length) ? _arg_1[_local_5] : 0);
                if (_local_6 == 0)
                {
                    var _local_9:* = this.t++;
                    this.a[_local_9] = _local_8;
                }
                else
                {
                    if ((_local_6 + _local_7) > DB)
                    {
                        this.a[(this.t - 1)] = (this.a[(this.t - 1)] | ((_local_8 & ((1 << (DB - _local_6)) - 1)) << _local_6));
                        _local_9 = this.t++;
                        this.a[_local_9] = (_local_8 >> (DB - _local_6));
                    }
                    else
                    {
                        this.a[(this.t - 1)] = (this.a[(this.t - 1)] | (_local_8 << _local_6));
                    };
                };
                _local_6 = (_local_6 + _local_7);
                if (_local_6 >= DB)
                {
                    _local_6 = (_local_6 - DB);
                };
            };
            if (((!(_arg_3)) && ((_arg_1[0] & 0x80) == 128)))
            {
                this.s = -1;
                if (_local_6 > 0)
                {
                    this.a[(this.t - 1)] = (this.a[(this.t - 1)] | (((1 << (DB - _local_6)) - 1) << _local_6));
                };
            };
            this.clamp();
            _arg_1.position = Math.min((_local_4 + _arg_2), _arg_1.length);
        }

        bi_internal function clamp():void
        {
            var _local_1:* = (this.s & DM);
            while (((this.t > 0) && (this.a[(this.t - 1)] == _local_1)))
            {
                this.t--;
            };
        }

        bi_internal function dlShiftTo(_arg_1:int, _arg_2:BigInteger):void
        {
            var _local_3:int;
            _local_3 = (this.t - 1);
            while (_local_3 >= 0)
            {
                _arg_2.a[(_local_3 + _arg_1)] = this.a[_local_3];
                _local_3--;
            };
            _local_3 = (_arg_1 - 1);
            while (_local_3 >= 0)
            {
                _arg_2.a[_local_3] = 0;
                _local_3--;
            };
            _arg_2.t = (this.t + _arg_1);
            _arg_2.s = this.s;
        }

        bi_internal function drShiftTo(_arg_1:int, _arg_2:BigInteger):void
        {
            var _local_3:int;
            _local_3 = _arg_1;
            while (_local_3 < this.t)
            {
                _arg_2.a[(_local_3 - _arg_1)] = this.a[_local_3];
                _local_3++;
            };
            _arg_2.t = Math.max((this.t - _arg_1), 0);
            _arg_2.s = this.s;
        }

        bi_internal function lShiftTo(_arg_1:int, _arg_2:BigInteger):void
        {
            var _local_8:int;
            var _local_3:int = (_arg_1 % DB);
            var _local_4:int = (DB - _local_3);
            var _local_5:int = ((1 << _local_4) - 1);
            var _local_6:int = int((_arg_1 / DB));
            var _local_7:* = ((this.s << _local_3) & DM);
            _local_8 = (this.t - 1);
            while (_local_8 >= 0)
            {
                _arg_2.a[((_local_8 + _local_6) + 1)] = ((this.a[_local_8] >> _local_4) | _local_7);
                _local_7 = ((this.a[_local_8] & _local_5) << _local_3);
                _local_8--;
            };
            _local_8 = (_local_6 - 1);
            while (_local_8 >= 0)
            {
                _arg_2.a[_local_8] = 0;
                _local_8--;
            };
            _arg_2.a[_local_6] = _local_7;
            _arg_2.t = ((this.t + _local_6) + 1);
            _arg_2.s = this.s;
            _arg_2.clamp();
        }

        bi_internal function rShiftTo(_arg_1:int, _arg_2:BigInteger):void
        {
            var _local_7:int;
            _arg_2.s = this.s;
            var _local_3:int = int((_arg_1 / DB));
            if (_local_3 >= this.t)
            {
                _arg_2.t = 0;
                return;
            };
            var _local_4:int = (_arg_1 % DB);
            var _local_5:int = (DB - _local_4);
            var _local_6:int = ((1 << _local_4) - 1);
            _arg_2.a[0] = (this.a[_local_3] >> _local_4);
            _local_7 = (_local_3 + 1);
            while (_local_7 < this.t)
            {
                _arg_2.a[((_local_7 - _local_3) - 1)] = (_arg_2.a[((_local_7 - _local_3) - 1)] | ((this.a[_local_7] & _local_6) << _local_5));
                _arg_2.a[(_local_7 - _local_3)] = (this.a[_local_7] >> _local_4);
                _local_7++;
            };
            if (_local_4 > 0)
            {
                _arg_2.a[((this.t - _local_3) - 1)] = (_arg_2.a[((this.t - _local_3) - 1)] | ((this.s & _local_6) << _local_5));
            };
            _arg_2.t = (this.t - _local_3);
            _arg_2.clamp();
        }

        bi_internal function subTo(_arg_1:BigInteger, _arg_2:BigInteger):void
        {
            var _local_3:int;
            var _local_4:int;
            var _local_5:int = Math.min(_arg_1.t, this.t);
            while (_local_3 < _local_5)
            {
                _local_4 = (_local_4 + (this.a[_local_3] - _arg_1.a[_local_3]));
                var _local_6:* = _local_3++;
                _arg_2.a[_local_6] = (_local_4 & DM);
                _local_4 = (_local_4 >> DB);
            };
            if (_arg_1.t < this.t)
            {
                _local_4 = (_local_4 - _arg_1.s);
                while (_local_3 < this.t)
                {
                    _local_4 = (_local_4 + this.a[_local_3]);
                    _local_6 = _local_3++;
                    _arg_2.a[_local_6] = (_local_4 & DM);
                    _local_4 = (_local_4 >> DB);
                };
                _local_4 = (_local_4 + this.s);
            }
            else
            {
                _local_4 = (_local_4 + this.s);
                while (_local_3 < _arg_1.t)
                {
                    _local_4 = (_local_4 - _arg_1.a[_local_3]);
                    _local_6 = _local_3++;
                    _arg_2.a[_local_6] = (_local_4 & DM);
                    _local_4 = (_local_4 >> DB);
                };
                _local_4 = (_local_4 - _arg_1.s);
            };
            _arg_2.s = ((_local_4 < 0) ? -1 : 0);
            if (_local_4 < -1)
            {
                _local_6 = _local_3++;
                _arg_2.a[_local_6] = (DV + _local_4);
            }
            else
            {
                if (_local_4 > 0)
                {
                    _local_6 = _local_3++;
                    _arg_2.a[_local_6] = _local_4;
                };
            };
            _arg_2.t = _local_3;
            _arg_2.clamp();
        }

        bi_internal function am(_arg_1:int, _arg_2:int, _arg_3:BigInteger, _arg_4:int, _arg_5:int, _arg_6:int):int
        {
            var _local_9:int;
            var _local_10:int;
            var _local_11:int;
            var _local_7:* = (_arg_2 & 0x7FFF);
            var _local_8:* = (_arg_2 >> 15);
            while (--_arg_6 >= 0)
            {
                _local_9 = (this.a[_arg_1] & 0x7FFF);
                _local_10 = (this.a[_arg_1++] >> 15);
                _local_11 = ((_local_8 * _local_9) + (_local_10 * _local_7));
                _local_9 = ((((_local_7 * _local_9) + ((_local_11 & 0x7FFF) << 15)) + _arg_3.a[_arg_4]) + (_arg_5 & 0x3FFFFFFF));
                _arg_5 = ((((_local_9 >>> 30) + (_local_11 >>> 15)) + (_local_8 * _local_10)) + (_arg_5 >>> 30));
                var _local_12:* = _arg_4++;
                _arg_3.a[_local_12] = (_local_9 & 0x3FFFFFFF);
            };
            return (_arg_5);
        }

        bi_internal function multiplyTo(_arg_1:BigInteger, _arg_2:BigInteger):void
        {
            var _local_3:BigInteger = this.abs();
            var _local_4:BigInteger = _arg_1.abs();
            var _local_5:int = _local_3.t;
            _arg_2.t = (_local_5 + _local_4.t);
            while (--_local_5 >= 0)
            {
                _arg_2.a[_local_5] = 0;
            };
            _local_5 = 0;
            while (_local_5 < _local_4.t)
            {
                _arg_2.a[(_local_5 + _local_3.t)] = _local_3.am(0, _local_4.a[_local_5], _arg_2, _local_5, 0, _local_3.t);
                _local_5++;
            };
            _arg_2.s = 0;
            _arg_2.clamp();
            if (this.s != _arg_1.s)
            {
                ZERO.subTo(_arg_2, _arg_2);
            };
        }

        bi_internal function squareTo(_arg_1:BigInteger):void
        {
            var _local_4:int;
            var _local_2:BigInteger = this.abs();
            var _local_3:int = (_arg_1.t = (2 * _local_2.t));
            while (--_local_3 >= 0)
            {
                _arg_1.a[_local_3] = 0;
            };
            _local_3 = 0;
            while (_local_3 < (_local_2.t - 1))
            {
                _local_4 = _local_2.am(_local_3, _local_2.a[_local_3], _arg_1, (2 * _local_3), 0, 1);
                if ((_arg_1.a[(_local_3 + _local_2.t)] = (_arg_1.a[(_local_3 + _local_2.t)] + _local_2.am((_local_3 + 1), (2 * _local_2.a[_local_3]), _arg_1, ((2 * _local_3) + 1), _local_4, ((_local_2.t - _local_3) - 1)))) >= DV)
                {
                    _arg_1.a[(_local_3 + _local_2.t)] = (_arg_1.a[(_local_3 + _local_2.t)] - DV);
                    _arg_1.a[((_local_3 + _local_2.t) + 1)] = 1;
                };
                _local_3++;
            };
            if (_arg_1.t > 0)
            {
                _arg_1.a[(_arg_1.t - 1)] = (_arg_1.a[(_arg_1.t - 1)] + _local_2.am(_local_3, _local_2.a[_local_3], _arg_1, (2 * _local_3), 0, 1));
            };
            _arg_1.s = 0;
            _arg_1.clamp();
        }

        bi_internal function divRemTo(m:BigInteger, q:BigInteger=null, r:BigInteger=null):void
        {
            var qd:int;
            var pm:BigInteger = m.abs();
            if (pm.t <= 0)
            {
                return;
            };
            var pt:BigInteger = this.abs();
            if (pt.t < pm.t)
            {
                if (q != null)
                {
                    q.fromInt(0);
                };
                if (r != null)
                {
                    this.copyTo(r);
                };
                return;
            };
            if (r == null)
            {
                r = this.nbi();
            };
            var y:BigInteger = this.nbi();
            var ts:int = this.s;
            var ms:int = m.s;
            var nsh:int = (DB - this.nbits(pm.a[(pm.t - 1)]));
            if (nsh > 0)
            {
                pm.lShiftTo(nsh, y);
                pt.lShiftTo(nsh, r);
            }
            else
            {
                pm.copyTo(y);
                pt.copyTo(r);
            };
            var ys:int = y.t;
            var y0:int = y.a[(ys - 1)];
            if (y0 == 0)
            {
                return;
            };
            var yt:Number = ((y0 * (1 << F1)) + ((ys > 1) ? (y.a[(ys - 2)] >> F2) : 0));
            var d1:Number = (FV / yt);
            var d2:Number = ((1 << F1) / yt);
            var e:Number = (1 << F2);
            var i:int = r.t;
            var j:int = (i - ys);
            var t:BigInteger = ((q == null) ? this.nbi() : q);
            y.dlShiftTo(j, t);
            if (r.compareTo(t) >= 0)
            {
                var _local_5:* = r.t++;
                r.a[_local_5] = 1;
                r.subTo(t, r);
            };
            ONE.dlShiftTo(ys, t);
            t.subTo(y, y);
            while (y.t < ys)
            {
                y.(y.t++, 0); //not popped
            };
            while (--j >= 0)
            {
                qd = ((r.a[--i] == y0) ? DM : ((Number(r.a[i]) * d1) + ((Number(r.a[(i - 1)]) + e) * d2)));
                if ((r.a[i] = (r.a[i] + y.am(0, qd, r, j, 0, ys))) < qd)
                {
                    y.dlShiftTo(j, t);
                    r.subTo(t, r);
                    while (r.a[i] < --qd)
                    {
                        r.subTo(t, r);
                    };
                };
            };
            if (q != null)
            {
                r.drShiftTo(ys, q);
                if (ts != ms)
                {
                    ZERO.subTo(q, q);
                };
            };
            r.t = ys;
            r.clamp();
            if (nsh > 0)
            {
                r.rShiftTo(nsh, r);
            };
            if (ts < 0)
            {
                ZERO.subTo(r, r);
            };
        }

        bi_internal function invDigit():int
        {
            if (this.t < 1)
            {
                return (0);
            };
            var _local_1:int = this.a[0];
            if ((_local_1 & 0x01) == 0)
            {
                return (0);
            };
            var _local_2:* = (_local_1 & 0x03);
            _local_2 = ((_local_2 * (2 - ((_local_1 & 0x0F) * _local_2))) & 0x0F);
            _local_2 = ((_local_2 * (2 - ((_local_1 & 0xFF) * _local_2))) & 0xFF);
            _local_2 = ((_local_2 * (2 - (((_local_1 & 0xFFFF) * _local_2) & 0xFFFF))) & 0xFFFF);
            _local_2 = ((_local_2 * (2 - ((_local_1 * _local_2) % DV))) % DV);
            return ((_local_2 > 0) ? (DV - _local_2) : -(_local_2));
        }

        bi_internal function isEven():Boolean
        {
            return (((this.t > 0) ? (this.a[0] & 0x01) : this.s) == 0);
        }

        bi_internal function exp(_arg_1:int, _arg_2:IReduction):BigInteger
        {
            var _local_7:BigInteger;
            if (((_arg_1 > 0xFFFFFFFF) || (_arg_1 < 1)))
            {
                return (ONE);
            };
            var _local_3:BigInteger = this.nbi();
            var _local_4:BigInteger = this.nbi();
            var _local_5:BigInteger = _arg_2.convert(this);
            var _local_6:int = (this.nbits(_arg_1) - 1);
            _local_5.copyTo(_local_3);
            while (--_local_6 >= 0)
            {
                _arg_2.sqrTo(_local_3, _local_4);
                if ((_arg_1 & (1 << _local_6)) > 0)
                {
                    _arg_2.mulTo(_local_4, _local_5, _local_3);
                }
                else
                {
                    _local_7 = _local_3;
                    _local_3 = _local_4;
                    _local_4 = _local_7;
                };
            };
            return (_arg_2.revert(_local_3));
        }

        bi_internal function intAt(_arg_1:String, _arg_2:int):int
        {
            return (parseInt(_arg_1.charAt(_arg_2), 36));
        }

        protected function nbi():*
        {
            return (new BigInteger());
        }

        public function clone():BigInteger
        {
            var _local_1:BigInteger = new BigInteger();
            this.copyTo(_local_1);
            return (_local_1);
        }

        public function intValue():int
        {
            if (this.s < 0)
            {
                if (this.t == 1)
                {
                    return (this.a[0] - DV);
                };
                if (this.t == 0)
                {
                    return (-1);
                };
            }
            else
            {
                if (this.t == 1)
                {
                    return (this.a[0]);
                };
                if (this.t == 0)
                {
                    return (0);
                };
            };
            return (((this.a[1] & ((1 << (32 - DB)) - 1)) << DB) | this.a[0]);
        }

        public function byteValue():int
        {
            return ((this.t == 0) ? this.s : ((this.a[0] << 24) >> 24));
        }

        public function shortValue():int
        {
            return ((this.t == 0) ? this.s : ((this.a[0] << 16) >> 16));
        }

        protected function chunkSize(_arg_1:Number):int
        {
            return (Math.floor(((Math.LN2 * DB) / Math.log(_arg_1))));
        }

        public function sigNum():int
        {
            if (this.s < 0)
            {
                return (-1);
            };
            if (((this.t <= 0) || ((this.t == 1) && (this.a[0] <= 0))))
            {
                return (0);
            };
            return (1);
        }

        protected function toRadix(_arg_1:uint=10):String
        {
            if ((((this.sigNum() == 0) || (_arg_1 < 2)) || (_arg_1 > 32)))
            {
                return ("0");
            };
            var _local_2:int = this.chunkSize(_arg_1);
            var _local_3:Number = Math.pow(_arg_1, _local_2);
            var _local_4:BigInteger = nbv(_local_3);
            var _local_5:BigInteger = this.nbi();
            var _local_6:BigInteger = this.nbi();
            var _local_7:* = "";
            this.divRemTo(_local_4, _local_5, _local_6);
            while (_local_5.sigNum() > 0)
            {
                _local_7 = ((_local_3 + _local_6.intValue()).toString(_arg_1).substr(1) + _local_7);
                _local_5.divRemTo(_local_4, _local_5, _local_6);
            };
            return (_local_6.intValue().toString(_arg_1) + _local_7);
        }

        protected function fromRadix(_arg_1:String, _arg_2:int=10):void
        {
            var _local_9:int;
            this.fromInt(0);
            var _local_3:int = this.chunkSize(_arg_2);
            var _local_4:Number = Math.pow(_arg_2, _local_3);
            var _local_5:Boolean;
            var _local_6:int;
            var _local_7:int;
            var _local_8:int;
            while (_local_8 < _arg_1.length)
            {
                _local_9 = this.intAt(_arg_1, _local_8);
                if (_local_9 < 0)
                {
                    if (((_arg_1.charAt(_local_8) == "-") && (this.sigNum() == 0)))
                    {
                        _local_5 = true;
                    };
                }
                else
                {
                    _local_7 = ((_arg_2 * _local_7) + _local_9);
                    if (++_local_6 >= _local_3)
                    {
                        this.dMultiply(_local_4);
                        this.dAddOffset(_local_7, 0);
                        _local_6 = 0;
                        _local_7 = 0;
                    };
                };
                _local_8++;
            };
            if (_local_6 > 0)
            {
                this.dMultiply(Math.pow(_arg_2, _local_6));
                this.dAddOffset(_local_7, 0);
            };
            if (_local_5)
            {
                BigInteger.ZERO.subTo(this, this);
            };
        }

        public function toByteArray():ByteArray
        {
            var _local_4:int;
            var _local_1:int = this.t;
            var _local_2:ByteArray = new ByteArray();
            _local_2[0] = this.s;
            var _local_3:int = (DB - ((_local_1 * DB) % 8));
            var _local_5:int;
            if (_local_1-- > 0)
            {
                if (((_local_3 < DB) && (!((_local_4 = (this.a[_local_1] >> _local_3)) == ((this.s & DM) >> _local_3)))))
                {
                    var _local_6:* = _local_5++;
                    _local_2[_local_6] = (_local_4 | (this.s << (DB - _local_3)));
                };
                while (_local_1 >= 0)
                {
                    if (_local_3 < 8)
                    {
                        _local_4 = ((this.a[_local_1] & ((1 << _local_3) - 1)) << (8 - _local_3));
                        _local_4 = (_local_4 | (this.a[--_local_1] >> (_local_3 = (_local_3 + (DB - 8)))));
                    }
                    else
                    {
                        _local_4 = ((this.a[_local_1] >> (_local_3 = (_local_3 - 8))) & 0xFF);
                        if (_local_3 <= 0)
                        {
                            _local_3 = (_local_3 + DB);
                            _local_1--;
                        };
                    };
                    if ((_local_4 & 0x80) != 0)
                    {
                        _local_4 = (_local_4 | 0xFFFFFF00);
                    };
                    if (((_local_5 == 0) && (!((this.s & 0x80) == (_local_4 & 0x80)))))
                    {
                        _local_5++;
                    };
                    if (((_local_5 > 0) || (!(_local_4 == this.s))))
                    {
                        _local_6 = _local_5++;
                        _local_2[_local_6] = _local_4;
                    };
                };
            };
            return (_local_2);
        }

        public function equals(_arg_1:BigInteger):Boolean
        {
            return (this.compareTo(_arg_1) == 0);
        }

        public function min(_arg_1:BigInteger):BigInteger
        {
            return ((this.compareTo(_arg_1) < 0) ? this : _arg_1);
        }

        public function max(_arg_1:BigInteger):BigInteger
        {
            return ((this.compareTo(_arg_1) > 0) ? this : _arg_1);
        }

        protected function bitwiseTo(_arg_1:BigInteger, _arg_2:Function, _arg_3:BigInteger):void
        {
            var _local_4:int;
            var _local_5:int;
            var _local_6:int = Math.min(_arg_1.t, this.t);
            _local_4 = 0;
            while (_local_4 < _local_6)
            {
                _arg_3.a[_local_4] = _arg_2(this.a[_local_4], _arg_1.a[_local_4]);
                _local_4++;
            };
            if (_arg_1.t < this.t)
            {
                _local_5 = (_arg_1.s & DM);
                _local_4 = _local_6;
                while (_local_4 < this.t)
                {
                    _arg_3.a[_local_4] = _arg_2(this.a[_local_4], _local_5);
                    _local_4++;
                };
                _arg_3.t = this.t;
            }
            else
            {
                _local_5 = (this.s & DM);
                _local_4 = _local_6;
                while (_local_4 < _arg_1.t)
                {
                    _arg_3.a[_local_4] = _arg_2(_local_5, _arg_1.a[_local_4]);
                    _local_4++;
                };
                _arg_3.t = _arg_1.t;
            };
            _arg_3.s = _arg_2(this.s, _arg_1.s);
            _arg_3.clamp();
        }

        private function op_and(_arg_1:int, _arg_2:int):int
        {
            return (_arg_1 & _arg_2);
        }

        public function and(_arg_1:BigInteger):BigInteger
        {
            var _local_2:BigInteger = new BigInteger();
            this.bitwiseTo(_arg_1, this.op_and, _local_2);
            return (_local_2);
        }

        private function op_or(_arg_1:int, _arg_2:int):int
        {
            return (_arg_1 | _arg_2);
        }

        public function or(_arg_1:BigInteger):BigInteger
        {
            var _local_2:BigInteger = new BigInteger();
            this.bitwiseTo(_arg_1, this.op_or, _local_2);
            return (_local_2);
        }

        private function op_xor(_arg_1:int, _arg_2:int):int
        {
            return (_arg_1 ^ _arg_2);
        }

        public function xor(_arg_1:BigInteger):BigInteger
        {
            var _local_2:BigInteger = new BigInteger();
            this.bitwiseTo(_arg_1, this.op_xor, _local_2);
            return (_local_2);
        }

        private function op_andnot(_arg_1:int, _arg_2:int):int
        {
            return (_arg_1 & (~(_arg_2)));
        }

        public function andNot(_arg_1:BigInteger):BigInteger
        {
            var _local_2:BigInteger = new BigInteger();
            this.bitwiseTo(_arg_1, this.op_andnot, _local_2);
            return (_local_2);
        }

        public function not():BigInteger
        {
            var _local_1:BigInteger = new BigInteger();
            var _local_2:int;
            while (_local_2 < this.t)
            {
                _local_1[_local_2] = (DM & (~(this.a[_local_2])));
                _local_2++;
            };
            _local_1.t = this.t;
            _local_1.s = (~(this.s));
            return (_local_1);
        }

        public function shiftLeft(_arg_1:int):BigInteger
        {
            var _local_2:BigInteger = new BigInteger();
            if (_arg_1 < 0)
            {
                this.rShiftTo(-(_arg_1), _local_2);
            }
            else
            {
                this.lShiftTo(_arg_1, _local_2);
            };
            return (_local_2);
        }

        public function shiftRight(_arg_1:int):BigInteger
        {
            var _local_2:BigInteger = new BigInteger();
            if (_arg_1 < 0)
            {
                this.lShiftTo(-(_arg_1), _local_2);
            }
            else
            {
                this.rShiftTo(_arg_1, _local_2);
            };
            return (_local_2);
        }

        private function lbit(_arg_1:int):int
        {
            if (_arg_1 == 0)
            {
                return (-1);
            };
            var _local_2:int;
            if ((_arg_1 & 0xFFFF) == 0)
            {
                _arg_1 = (_arg_1 >> 16);
                _local_2 = (_local_2 + 16);
            };
            if ((_arg_1 & 0xFF) == 0)
            {
                _arg_1 = (_arg_1 >> 8);
                _local_2 = (_local_2 + 8);
            };
            if ((_arg_1 & 0x0F) == 0)
            {
                _arg_1 = (_arg_1 >> 4);
                _local_2 = (_local_2 + 4);
            };
            if ((_arg_1 & 0x03) == 0)
            {
                _arg_1 = (_arg_1 >> 2);
                _local_2 = (_local_2 + 2);
            };
            if ((_arg_1 & 0x01) == 0)
            {
                _local_2++;
            };
            return (_local_2);
        }

        public function getLowestSetBit():int
        {
            var _local_1:int;
            while (_local_1 < this.t)
            {
                if (this.a[_local_1] != 0)
                {
                    return ((_local_1 * DB) + this.lbit(this.a[_local_1]));
                };
                _local_1++;
            };
            if (this.s < 0)
            {
                return (this.t * DB);
            };
            return (-1);
        }

        private function cbit(_arg_1:int):int
        {
            var _local_2:uint;
            while (_arg_1 != 0)
            {
                _arg_1 = (_arg_1 & (_arg_1 - 1));
                _local_2++;
            };
            return (_local_2);
        }

        public function bitCount():int
        {
            var _local_1:int;
            var _local_2:* = (this.s & DM);
            var _local_3:int;
            while (_local_3 < this.t)
            {
                _local_1 = (_local_1 + this.cbit((this.a[_local_3] ^ _local_2)));
                _local_3++;
            };
            return (_local_1);
        }

        public function testBit(_arg_1:int):Boolean
        {
            var _local_2:int = int(Math.floor((_arg_1 / DB)));
            if (_local_2 >= this.t)
            {
                return (!(this.s == 0));
            };
            return (!((this.a[_local_2] & (1 << (_arg_1 % DB))) == 0));
        }

        protected function changeBit(_arg_1:int, _arg_2:Function):BigInteger
        {
            var _local_3:BigInteger = BigInteger.ONE.shiftLeft(_arg_1);
            this.bitwiseTo(_local_3, _arg_2, _local_3);
            return (_local_3);
        }

        public function setBit(_arg_1:int):BigInteger
        {
            return (this.changeBit(_arg_1, this.op_or));
        }

        public function clearBit(_arg_1:int):BigInteger
        {
            return (this.changeBit(_arg_1, this.op_andnot));
        }

        public function flipBit(_arg_1:int):BigInteger
        {
            return (this.changeBit(_arg_1, this.op_xor));
        }

        protected function addTo(_arg_1:BigInteger, _arg_2:BigInteger):void
        {
            var _local_3:int;
            var _local_4:int;
            var _local_5:int = Math.min(_arg_1.t, this.t);
            while (_local_3 < _local_5)
            {
                _local_4 = (_local_4 + (this.a[_local_3] + _arg_1.a[_local_3]));
                var _local_6:* = _local_3++;
                _arg_2.a[_local_6] = (_local_4 & DM);
                _local_4 = (_local_4 >> DB);
            };
            if (_arg_1.t < this.t)
            {
                _local_4 = (_local_4 + _arg_1.s);
                while (_local_3 < this.t)
                {
                    _local_4 = (_local_4 + this.a[_local_3]);
                    _local_6 = _local_3++;
                    _arg_2.a[_local_6] = (_local_4 & DM);
                    _local_4 = (_local_4 >> DB);
                };
                _local_4 = (_local_4 + this.s);
            }
            else
            {
                _local_4 = (_local_4 + this.s);
                while (_local_3 < _arg_1.t)
                {
                    _local_4 = (_local_4 + _arg_1.a[_local_3]);
                    _local_6 = _local_3++;
                    _arg_2.a[_local_6] = (_local_4 & DM);
                    _local_4 = (_local_4 >> DB);
                };
                _local_4 = (_local_4 + _arg_1.s);
            };
            _arg_2.s = ((_local_4 < 0) ? -1 : 0);
            if (_local_4 > 0)
            {
                _local_6 = _local_3++;
                _arg_2.a[_local_6] = _local_4;
            }
            else
            {
                if (_local_4 < -1)
                {
                    _local_6 = _local_3++;
                    _arg_2.a[_local_6] = (DV + _local_4);
                };
            };
            _arg_2.t = _local_3;
            _arg_2.clamp();
        }

        public function add(_arg_1:BigInteger):BigInteger
        {
            var _local_2:BigInteger = new BigInteger();
            this.addTo(_arg_1, _local_2);
            return (_local_2);
        }

        public function subtract(_arg_1:BigInteger):BigInteger
        {
            var _local_2:BigInteger = new BigInteger();
            this.subTo(_arg_1, _local_2);
            return (_local_2);
        }

        public function multiply(_arg_1:BigInteger):BigInteger
        {
            var _local_2:BigInteger = new BigInteger();
            this.multiplyTo(_arg_1, _local_2);
            return (_local_2);
        }

        public function divide(_arg_1:BigInteger):BigInteger
        {
            var _local_2:BigInteger = new BigInteger();
            this.divRemTo(_arg_1, _local_2, null);
            return (_local_2);
        }

        public function remainder(_arg_1:BigInteger):BigInteger
        {
            var _local_2:BigInteger = new BigInteger();
            this.divRemTo(_arg_1, null, _local_2);
            return (_local_2);
        }

        public function divideAndRemainder(_arg_1:BigInteger):Array
        {
            var _local_2:BigInteger = new BigInteger();
            var _local_3:BigInteger = new BigInteger();
            this.divRemTo(_arg_1, _local_2, _local_3);
            return ([_local_2, _local_3]);
        }

        bi_internal function dMultiply(_arg_1:int):void
        {
            this.a[this.t] = this.am(0, (_arg_1 - 1), this, 0, 0, this.t);
            this.t++;
            this.clamp();
        }

        bi_internal function dAddOffset(_arg_1:int, _arg_2:int):void
        {
            while (this.t <= _arg_2)
            {
                var _local_3:* = this.t++;
                this.a[_local_3] = 0;
            };
            this.a[_arg_2] = (this.a[_arg_2] + _arg_1);
            while (this.a[_arg_2] >= DV)
            {
                this.a[_arg_2] = (this.a[_arg_2] - DV);
                if (++_arg_2 >= this.t)
                {
                    _local_3 = this.t++;
                    this.a[_local_3] = 0;
                };
                this.a[_arg_2]++;
            };
        }

        public function pow(_arg_1:int):BigInteger
        {
            return (this.exp(_arg_1, new NullReduction()));
        }

        bi_internal function multiplyLowerTo(_arg_1:BigInteger, _arg_2:int, _arg_3:BigInteger):void
        {
            var _local_5:int;
            var _local_4:int = Math.min((this.t + _arg_1.t), _arg_2);
            _arg_3.s = 0;
            _arg_3.t = _local_4;
            while (_local_4 > 0)
            {
                var _local_6:* = --_local_4;
                _arg_3.a[_local_6] = 0;
            };
            _local_5 = (_arg_3.t - this.t);
            while (_local_4 < _local_5)
            {
                _arg_3.a[(_local_4 + this.t)] = this.am(0, _arg_1.a[_local_4], _arg_3, _local_4, 0, this.t);
                _local_4++;
            };
            _local_5 = Math.min(_arg_1.t, _arg_2);
            while (_local_4 < _local_5)
            {
                this.am(0, _arg_1.a[_local_4], _arg_3, _local_4, 0, (_arg_2 - _local_4));
                _local_4++;
            };
            _arg_3.clamp();
        }

        bi_internal function multiplyUpperTo(_arg_1:BigInteger, _arg_2:int, _arg_3:BigInteger):void
        {
            _arg_2--;
            var _local_4:int = (_arg_3.t = ((this.t + _arg_1.t) - _arg_2));
            _arg_3.s = 0;
            while (--_local_4 >= 0)
            {
                _arg_3.a[_local_4] = 0;
            };
            _local_4 = Math.max((_arg_2 - this.t), 0);
            while (_local_4 < _arg_1.t)
            {
                _arg_3.a[((this.t + _local_4) - _arg_2)] = this.am((_arg_2 - _local_4), _arg_1.a[_local_4], _arg_3, 0, 0, ((this.t + _local_4) - _arg_2));
                _local_4++;
            };
            _arg_3.clamp();
            _arg_3.drShiftTo(1, _arg_3);
        }

        public function modPow(_arg_1:BigInteger, _arg_2:BigInteger):BigInteger
        {
            var _local_4:int;
            var _local_6:IReduction;
            var _local_12:int;
            var _local_15:BigInteger;
            var _local_16:BigInteger;
            var _local_3:int = _arg_1.bitLength();
            var _local_5:BigInteger = nbv(1);
            if (_local_3 <= 0)
            {
                return (_local_5);
            };
            if (_local_3 < 18)
            {
                _local_4 = 1;
            }
            else
            {
                if (_local_3 < 48)
                {
                    _local_4 = 3;
                }
                else
                {
                    if (_local_3 < 144)
                    {
                        _local_4 = 4;
                    }
                    else
                    {
                        if (_local_3 < 0x0300)
                        {
                            _local_4 = 5;
                        }
                        else
                        {
                            _local_4 = 6;
                        };
                    };
                };
            };
            if (_local_3 < 8)
            {
                _local_6 = new ClassicReduction(_arg_2);
            }
            else
            {
                if (_arg_2.isEven())
                {
                    _local_6 = new BarrettReduction(_arg_2);
                }
                else
                {
                    _local_6 = new MontgomeryReduction(_arg_2);
                };
            };
            var _local_7:Array = [];
            var _local_8:int = 3;
            var _local_9:int = (_local_4 - 1);
            var _local_10:int = ((1 << _local_4) - 1);
            _local_7[1] = _local_6.convert(this);
            if (_local_4 > 1)
            {
                _local_16 = new BigInteger();
                _local_6.sqrTo(_local_7[1], _local_16);
                while (_local_8 <= _local_10)
                {
                    _local_7[_local_8] = new BigInteger();
                    _local_6.mulTo(_local_16, _local_7[(_local_8 - 2)], _local_7[_local_8]);
                    _local_8 = (_local_8 + 2);
                };
            };
            var _local_11:int = (_arg_1.t - 1);
            var _local_13:Boolean = true;
            var _local_14:BigInteger = new BigInteger();
            _local_3 = (this.nbits(_arg_1.a[_local_11]) - 1);
            while (_local_11 >= 0)
            {
                if (_local_3 >= _local_9)
                {
                    _local_12 = ((_arg_1.a[_local_11] >> (_local_3 - _local_9)) & _local_10);
                }
                else
                {
                    _local_12 = ((_arg_1.a[_local_11] & ((1 << (_local_3 + 1)) - 1)) << (_local_9 - _local_3));
                    if (_local_11 > 0)
                    {
                        _local_12 = (_local_12 | (_arg_1.a[(_local_11 - 1)] >> ((DB + _local_3) - _local_9)));
                    };
                };
                _local_8 = _local_4;
                while ((_local_12 & 0x01) == 0)
                {
                    _local_12 = (_local_12 >> 1);
                    _local_8--;
                };
                if ((_local_3 = (_local_3 - _local_8)) < 0)
                {
                    _local_3 = (_local_3 + DB);
                    _local_11--;
                };
                if (_local_13)
                {
                    _local_7[_local_12].copyTo(_local_5);
                    _local_13 = false;
                }
                else
                {
                    while (_local_8 > 1)
                    {
                        _local_6.sqrTo(_local_5, _local_14);
                        _local_6.sqrTo(_local_14, _local_5);
                        _local_8 = (_local_8 - 2);
                    };
                    if (_local_8 > 0)
                    {
                        _local_6.sqrTo(_local_5, _local_14);
                    }
                    else
                    {
                        _local_15 = _local_5;
                        _local_5 = _local_14;
                        _local_14 = _local_15;
                    };
                    _local_6.mulTo(_local_14, _local_7[_local_12], _local_5);
                };
                while (((_local_11 >= 0) && ((_arg_1.a[_local_11] & (1 << _local_3)) == 0)))
                {
                    _local_6.sqrTo(_local_5, _local_14);
                    _local_15 = _local_5;
                    _local_5 = _local_14;
                    _local_14 = _local_15;
                    if (--_local_3 < 0)
                    {
                        _local_3 = (DB - 1);
                        _local_11--;
                    };
                };
            };
            return (_local_6.revert(_local_5));
        }

        public function gcd(_arg_1:BigInteger):BigInteger
        {
            var _local_6:BigInteger;
            var _local_2:BigInteger = ((this.s < 0) ? this.negate() : this.clone());
            var _local_3:BigInteger = ((_arg_1.s < 0) ? _arg_1.negate() : _arg_1.clone());
            if (_local_2.compareTo(_local_3) < 0)
            {
                _local_6 = _local_2;
                _local_2 = _local_3;
                _local_3 = _local_6;
            };
            var _local_4:int = _local_2.getLowestSetBit();
            var _local_5:int = _local_3.getLowestSetBit();
            if (_local_5 < 0)
            {
                return (_local_2);
            };
            if (_local_4 < _local_5)
            {
                _local_5 = _local_4;
            };
            if (_local_5 > 0)
            {
                _local_2.rShiftTo(_local_5, _local_2);
                _local_3.rShiftTo(_local_5, _local_3);
            };
            while (_local_2.sigNum() > 0)
            {
                if ((_local_4 = _local_2.getLowestSetBit()) > 0)
                {
                    _local_2.rShiftTo(_local_4, _local_2);
                };
                if ((_local_4 = _local_3.getLowestSetBit()) > 0)
                {
                    _local_3.rShiftTo(_local_4, _local_3);
                };
                if (_local_2.compareTo(_local_3) >= 0)
                {
                    _local_2.subTo(_local_3, _local_2);
                    _local_2.rShiftTo(1, _local_2);
                }
                else
                {
                    _local_3.subTo(_local_2, _local_3);
                    _local_3.rShiftTo(1, _local_3);
                };
            };
            if (_local_5 > 0)
            {
                _local_3.lShiftTo(_local_5, _local_3);
            };
            return (_local_3);
        }

        protected function modInt(_arg_1:int):int
        {
            var _local_4:int;
            if (_arg_1 <= 0)
            {
                return (0);
            };
            var _local_2:int = (DV % _arg_1);
            var _local_3:int = ((this.s < 0) ? (_arg_1 - 1) : 0);
            if (this.t > 0)
            {
                if (_local_2 == 0)
                {
                    _local_3 = (this.a[0] % _arg_1);
                }
                else
                {
                    _local_4 = (this.t - 1);
                    while (_local_4 >= 0)
                    {
                        _local_3 = (((_local_2 * _local_3) + this.a[_local_4]) % _arg_1);
                        _local_4--;
                    };
                };
            };
            return (_local_3);
        }

        public function modInverse(_arg_1:BigInteger):BigInteger
        {
            var _local_2:Boolean = _arg_1.isEven();
            if ((((this.isEven()) && (_local_2)) || (_arg_1.sigNum() == 0)))
            {
                return (BigInteger.ZERO);
            };
            var _local_3:BigInteger = _arg_1.clone();
            var _local_4:BigInteger = this.clone();
            var _local_5:BigInteger = nbv(1);
            var _local_6:BigInteger = nbv(0);
            var _local_7:BigInteger = nbv(0);
            var _local_8:BigInteger = nbv(1);
            while (_local_3.sigNum() != 0)
            {
                while (_local_3.isEven())
                {
                    _local_3.rShiftTo(1, _local_3);
                    if (_local_2)
                    {
                        if (((!(_local_5.isEven())) || (!(_local_6.isEven()))))
                        {
                            _local_5.addTo(this, _local_5);
                            _local_6.subTo(_arg_1, _local_6);
                        };
                        _local_5.rShiftTo(1, _local_5);
                    }
                    else
                    {
                        if (!_local_6.isEven())
                        {
                            _local_6.subTo(_arg_1, _local_6);
                        };
                    };
                    _local_6.rShiftTo(1, _local_6);
                };
                while (_local_4.isEven())
                {
                    _local_4.rShiftTo(1, _local_4);
                    if (_local_2)
                    {
                        if (((!(_local_7.isEven())) || (!(_local_8.isEven()))))
                        {
                            _local_7.addTo(this, _local_7);
                            _local_8.subTo(_arg_1, _local_8);
                        };
                        _local_7.rShiftTo(1, _local_7);
                    }
                    else
                    {
                        if (!_local_8.isEven())
                        {
                            _local_8.subTo(_arg_1, _local_8);
                        };
                    };
                    _local_8.rShiftTo(1, _local_8);
                };
                if (_local_3.compareTo(_local_4) >= 0)
                {
                    _local_3.subTo(_local_4, _local_3);
                    if (_local_2)
                    {
                        _local_5.subTo(_local_7, _local_5);
                    };
                    _local_6.subTo(_local_8, _local_6);
                }
                else
                {
                    _local_4.subTo(_local_3, _local_4);
                    if (_local_2)
                    {
                        _local_7.subTo(_local_5, _local_7);
                    };
                    _local_8.subTo(_local_6, _local_8);
                };
            };
            if (_local_4.compareTo(BigInteger.ONE) != 0)
            {
                return (BigInteger.ZERO);
            };
            if (_local_8.compareTo(_arg_1) >= 0)
            {
                return (_local_8.subtract(_arg_1));
            };
            if (_local_8.sigNum() < 0)
            {
                _local_8.addTo(_arg_1, _local_8);
            }
            else
            {
                return (_local_8);
            };
            if (_local_8.sigNum() < 0)
            {
                return (_local_8.add(_arg_1));
            };
            return (_local_8);
        }

        public function isProbablePrime(_arg_1:int):Boolean
        {
            var _local_2:int;
            var _local_4:int;
            var _local_5:int;
            var _local_3:BigInteger = this.abs();
            if (((_local_3.t == 1) && (_local_3.a[0] <= lowprimes[(lowprimes.length - 1)])))
            {
                _local_2 = 0;
                while (_local_2 < lowprimes.length)
                {
                    if (_local_3[0] == lowprimes[_local_2])
                    {
                        return (true);
                    };
                    _local_2++;
                };
                return (false);
            };
            if (_local_3.isEven())
            {
                return (false);
            };
            _local_2 = 1;
            while (_local_2 < lowprimes.length)
            {
                _local_4 = lowprimes[_local_2];
                _local_5 = (_local_2 + 1);
                while (((_local_5 < lowprimes.length) && (_local_4 < lplim)))
                {
                    _local_4 = (_local_4 * lowprimes[_local_5++]);
                };
                _local_4 = _local_3.modInt(_local_4);
                while (_local_2 < _local_5)
                {
                    if ((_local_4 % lowprimes[_local_2++]) == 0)
                    {
                        return (false);
                    };
                };
            };
            return (_local_3.millerRabin(_arg_1));
        }

        protected function millerRabin(_arg_1:int):Boolean
        {
            var _local_7:BigInteger;
            var _local_8:int;
            var _local_2:BigInteger = this.subtract(BigInteger.ONE);
            var _local_3:int = _local_2.getLowestSetBit();
            if (_local_3 <= 0)
            {
                return (false);
            };
            var _local_4:BigInteger = _local_2.shiftRight(_local_3);
            _arg_1 = ((_arg_1 + 1) >> 1);
            if (_arg_1 > lowprimes.length)
            {
                _arg_1 = lowprimes.length;
            };
            var _local_5:BigInteger = new BigInteger();
            var _local_6:int;
            while (_local_6 < _arg_1)
            {
                _local_5.fromInt(lowprimes[_local_6]);
                _local_7 = _local_5.modPow(_local_4, this);
                if (((!(_local_7.compareTo(BigInteger.ONE) == 0)) && (!(_local_7.compareTo(_local_2) == 0))))
                {
                    _local_8 = 1;
                    while (((_local_8++ < _local_3) && (!(_local_7.compareTo(_local_2) == 0))))
                    {
                        _local_7 = _local_7.modPowInt(2, this);
                        if (_local_7.compareTo(BigInteger.ONE) == 0)
                        {
                            return (false);
                        };
                    };
                    if (_local_7.compareTo(_local_2) != 0)
                    {
                        return (false);
                    };
                };
                _local_6++;
            };
            return (true);
        }

        public function primify(_arg_1:int, _arg_2:int):void
        {
            if (!this.testBit((_arg_1 - 1)))
            {
                this.bitwiseTo(BigInteger.ONE.shiftLeft((_arg_1 - 1)), this.op_or, this);
            };
            if (this.isEven())
            {
                this.dAddOffset(1, 0);
            };
            while ((!(this.isProbablePrime(_arg_2))))
            {
                this.dAddOffset(2, 0);
                while (this.bitLength() > _arg_1)
                {
                    this.subTo(BigInteger.ONE.shiftLeft((_arg_1 - 1)), this);
                };
            };
        }


    }
}//package com.hurlant.math

