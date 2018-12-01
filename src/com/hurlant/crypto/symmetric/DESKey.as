// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.hurlant.crypto.symmetric.DESKey

package com.hurlant.crypto.symmetric
{
    import flash.utils.ByteArray;
    import com.hurlant.util.Memory;

    public class DESKey implements ISymmetricKey 
    {

        private static const Df_Key:Array = [1, 35, 69, 103, 137, 171, 205, 239, 254, 220, 186, 152, 118, 84, 50, 16, 137, 171, 205, 239, 1, 35, 69, 103];
        private static const bytebit:Array = [128, 64, 32, 16, 8, 4, 2, 1];
        private static const bigbyte:Array = [0x800000, 0x400000, 0x200000, 0x100000, 0x80000, 0x40000, 0x20000, 0x10000, 0x8000, 0x4000, 0x2000, 0x1000, 0x0800, 0x0400, 0x0200, 0x0100, 128, 64, 32, 16, 8, 4, 2, 1];
        private static const pc1:Array = [56, 48, 40, 32, 24, 16, 8, 0, 57, 49, 41, 33, 25, 17, 9, 1, 58, 50, 42, 34, 26, 18, 10, 2, 59, 51, 43, 35, 62, 54, 46, 38, 30, 22, 14, 6, 61, 53, 45, 37, 29, 21, 13, 5, 60, 52, 44, 36, 28, 20, 12, 4, 27, 19, 11, 3];
        private static const totrot:Array = [1, 2, 4, 6, 8, 10, 12, 14, 15, 17, 19, 21, 23, 25, 27, 28];
        private static const pc2:Array = [13, 16, 10, 23, 0, 4, 2, 27, 14, 5, 20, 9, 22, 18, 11, 3, 25, 7, 15, 6, 26, 19, 12, 1, 40, 51, 30, 36, 46, 54, 29, 39, 50, 44, 32, 47, 43, 48, 38, 55, 33, 52, 45, 41, 49, 35, 28, 31];
        private static const SP1:Array = [16843776, 0, 0x10000, 16843780, 16842756, 66564, 4, 0x10000, 0x0400, 16843776, 16843780, 0x0400, 16778244, 16842756, 0x1000000, 4, 0x0404, 16778240, 16778240, 66560, 66560, 16842752, 16842752, 16778244, 65540, 16777220, 16777220, 65540, 0, 0x0404, 66564, 0x1000000, 0x10000, 16843780, 4, 16842752, 16843776, 0x1000000, 0x1000000, 0x0400, 16842756, 0x10000, 66560, 16777220, 0x0400, 4, 16778244, 66564, 16843780, 65540, 16842752, 16778244, 16777220, 0x0404, 66564, 16843776, 0x0404, 16778240, 16778240, 0, 65540, 66560, 0, 16842756];
        private static const SP2:Array = [2148565024, 0x80008000, 0x8000, 1081376, 0x100000, 32, 0x80100020, 0x80008020, 0x80000020, 2148565024, 0x80108000, 0x80000000, 0x80008000, 0x100000, 32, 0x80100020, 0x108000, 0x100020, 0x80008020, 0, 0x80000000, 0x8000, 1081376, 0x80100000, 0x100020, 0x80000020, 0, 0x108000, 32800, 0x80108000, 0x80100000, 32800, 0, 1081376, 0x80100020, 0x100000, 0x80008020, 0x80100000, 0x80108000, 0x8000, 0x80100000, 0x80008000, 32, 2148565024, 1081376, 32, 0x8000, 0x80000000, 32800, 0x80108000, 0x100000, 0x80000020, 0x100020, 0x80008020, 0x80000020, 0x100020, 0x108000, 0, 0x80008000, 32800, 0x80000000, 0x80100020, 2148565024, 0x108000];
        private static const SP3:Array = [520, 134349312, 0, 134348808, 134218240, 0, 131592, 134218240, 131080, 134217736, 134217736, 0x20000, 134349320, 131080, 134348800, 520, 0x8000000, 8, 134349312, 0x0200, 131584, 134348800, 134348808, 131592, 134218248, 131584, 0x20000, 134218248, 8, 134349320, 0x0200, 0x8000000, 134349312, 0x8000000, 131080, 520, 0x20000, 134349312, 134218240, 0, 0x0200, 131080, 134349320, 134218240, 134217736, 0x0200, 0, 134348808, 134218248, 0x20000, 0x8000000, 134349320, 8, 131592, 131584, 134217736, 134348800, 134218248, 520, 134348800, 131592, 8, 134348808, 131584];
        private static const SP4:Array = [8396801, 8321, 8321, 128, 8396928, 0x800081, 0x800001, 8193, 0, 0x802000, 0x802000, 8396929, 129, 0, 0x800080, 0x800001, 1, 0x2000, 0x800000, 8396801, 128, 0x800000, 8193, 8320, 0x800081, 1, 8320, 0x800080, 0x2000, 8396928, 8396929, 129, 0x800080, 0x800001, 0x802000, 8396929, 129, 0, 0, 0x802000, 8320, 0x800080, 0x800081, 1, 8396801, 8321, 8321, 128, 8396929, 129, 1, 0x2000, 0x800001, 8193, 8396928, 0x800081, 8193, 8320, 0x800000, 8396801, 128, 0x800000, 0x2000, 8396928];
        private static const SP5:Array = [0x0100, 34078976, 34078720, 0x42000100, 0x80000, 0x0100, 0x40000000, 34078720, 0x40080100, 0x80000, 33554688, 0x40080100, 0x42000100, 0x42080000, 524544, 0x40000000, 0x2000000, 0x40080000, 0x40080000, 0, 0x40000100, 0x42080100, 0x42080100, 33554688, 0x42080000, 0x40000100, 0, 0x42000000, 34078976, 0x2000000, 0x42000000, 524544, 0x80000, 0x42000100, 0x0100, 0x2000000, 0x40000000, 34078720, 0x42000100, 0x40080100, 33554688, 0x40000000, 0x42080000, 34078976, 0x40080100, 0x0100, 0x2000000, 0x42080000, 0x42080100, 524544, 0x42000000, 0x42080100, 34078720, 0, 0x40080000, 0x42000000, 524544, 33554688, 0x40000100, 0x80000, 0, 0x40080000, 34078976, 0x40000100];
        private static const SP6:Array = [0x20000010, 0x20400000, 0x4000, 541081616, 0x20400000, 16, 541081616, 0x400000, 0x20004000, 4210704, 0x400000, 0x20000010, 0x400010, 0x20004000, 0x20000000, 16400, 0, 0x400010, 0x20004010, 0x4000, 0x404000, 0x20004010, 16, 0x20400010, 0x20400010, 0, 4210704, 0x20404000, 16400, 0x404000, 0x20404000, 0x20000000, 0x20004000, 16, 0x20400010, 0x404000, 541081616, 0x400000, 16400, 0x20000010, 0x400000, 0x20004000, 0x20000000, 16400, 0x20000010, 541081616, 0x404000, 0x20400000, 4210704, 0x20404000, 0, 0x20400010, 16, 0x4000, 0x20400000, 4210704, 0x4000, 0x400010, 0x20004010, 0, 0x20404000, 0x20000000, 0x400010, 0x20004010];
        private static const SP7:Array = [0x200000, 69206018, 67110914, 0, 0x0800, 67110914, 2099202, 69208064, 69208066, 0x200000, 0, 67108866, 2, 0x4000000, 69206018, 2050, 67110912, 2099202, 0x200002, 67110912, 67108866, 69206016, 69208064, 0x200002, 69206016, 0x0800, 2050, 69208066, 0x200800, 2, 0x4000000, 0x200800, 0x4000000, 0x200800, 0x200000, 67110914, 67110914, 69206018, 69206018, 2, 0x200002, 0x4000000, 67110912, 0x200000, 69208064, 2050, 2099202, 69208064, 2050, 67108866, 69208066, 69206016, 0x200800, 0, 2, 69208066, 0, 2099202, 69206016, 0x0800, 67108866, 67110912, 0x0800, 0x200002];
        private static const SP8:Array = [0x10001040, 0x1000, 0x40000, 268701760, 0x10000000, 0x10001040, 64, 0x10000000, 262208, 0x10040000, 268701760, 266240, 0x10041000, 266304, 0x1000, 64, 0x10040000, 0x10000040, 0x10001000, 4160, 266240, 262208, 0x10040040, 0x10041000, 4160, 0, 0, 0x10040040, 0x10000040, 0x10001000, 266304, 0x40000, 266304, 0x40000, 0x10041000, 0x1000, 64, 0x10040040, 0x1000, 266304, 0x10001000, 64, 0x10000040, 0x10040000, 0x10040040, 0x10000000, 0x40000, 0x10001040, 0, 268701760, 262208, 0x10000040, 0x10040000, 0x10001000, 0x10001040, 0, 268701760, 266240, 266240, 4160, 4160, 262208, 0x10000000, 0x10041000];

        protected var key:ByteArray;
        protected var encKey:Array;
        protected var decKey:Array;

        public function DESKey(_arg_1:ByteArray)
        {
            this.key = _arg_1;
            this.encKey = this.generateWorkingKey(true, _arg_1, 0);
            this.decKey = this.generateWorkingKey(false, _arg_1, 0);
        }

        public function getBlockSize():uint
        {
            return (8);
        }

        public function decrypt(_arg_1:ByteArray, _arg_2:uint=0):void
        {
            this.desFunc(this.decKey, _arg_1, _arg_2, _arg_1, _arg_2);
        }

        public function dispose():void
        {
            var _local_1:uint;
            _local_1 = 0;
            while (_local_1 < this.encKey.length)
            {
                this.encKey[_local_1] = 0;
                _local_1++;
            };
            _local_1 = 0;
            while (_local_1 < this.decKey.length)
            {
                this.decKey[_local_1] = 0;
                _local_1++;
            };
            this.encKey = null;
            this.decKey = null;
            _local_1 = 0;
            while (_local_1 < this.key.length)
            {
                this.key[_local_1] = 0;
                _local_1++;
            };
            this.key.length = 0;
            this.key = null;
            Memory.gc();
        }

        public function encrypt(_arg_1:ByteArray, _arg_2:uint=0):void
        {
            this.desFunc(this.encKey, _arg_1, _arg_2, _arg_1, _arg_2);
        }

        protected function generateWorkingKey(_arg_1:Boolean, _arg_2:ByteArray, _arg_3:uint):Array
        {
            var _local_7:uint;
            var _local_10:uint;
            var _local_11:uint;
            var _local_12:uint;
            var _local_13:uint;
            var _local_4:Array = [];
            var _local_5:ByteArray = new ByteArray();
            var _local_6:ByteArray = new ByteArray();
            var _local_8:uint;
            while (_local_8 < 56)
            {
                _local_7 = pc1[_local_8];
                _local_5[_local_8] = (!((_arg_2[(_arg_3 + (_local_7 >>> 3))] & bytebit[(_local_7 & 0x07)]) == 0));
                _local_8++;
            };
            var _local_9:uint;
            while (_local_9 < 16)
            {
                if (_arg_1)
                {
                    _local_10 = (_local_9 << 1);
                }
                else
                {
                    _local_10 = ((15 - _local_9) << 1);
                };
                _local_11 = (_local_10 + 1);
                _local_4[_local_10] = (_local_4[_local_11] = 0);
                _local_8 = 0;
                while (_local_8 < 28)
                {
                    _local_7 = (_local_8 + totrot[_local_9]);
                    if (_local_7 < 28)
                    {
                        _local_6[_local_8] = _local_5[_local_7];
                    }
                    else
                    {
                        _local_6[_local_8] = _local_5[(_local_7 - 28)];
                    };
                    _local_8++;
                };
                _local_8 = 28;
                while (_local_8 < 56)
                {
                    _local_7 = (_local_8 + totrot[_local_9]);
                    if (_local_7 < 56)
                    {
                        _local_6[_local_8] = _local_5[_local_7];
                    }
                    else
                    {
                        _local_6[_local_8] = _local_5[(_local_7 - 28)];
                    };
                    _local_8++;
                };
                _local_8 = 0;
                while (_local_8 < 24)
                {
                    if (_local_6[pc2[_local_8]])
                    {
                        _local_4[_local_10] = (_local_4[_local_10] | bigbyte[_local_8]);
                    };
                    if (_local_6[pc2[(_local_8 + 24)]])
                    {
                        _local_4[_local_11] = (_local_4[_local_11] | bigbyte[_local_8]);
                    };
                    _local_8++;
                };
                _local_9++;
            };
            _local_9 = 0;
            while (_local_9 != 32)
            {
                _local_12 = _local_4[_local_9];
                _local_13 = _local_4[(_local_9 + 1)];
                _local_4[_local_9] = (((((_local_12 & 0xFC0000) << 6) | ((_local_12 & 0x0FC0) << 10)) | ((_local_13 & 0xFC0000) >>> 10)) | ((_local_13 & 0x0FC0) >>> 6));
                _local_4[(_local_9 + 1)] = (((((_local_12 & 0x03F000) << 12) | ((_local_12 & 0x3F) << 16)) | ((_local_13 & 0x03F000) >>> 4)) | (_local_13 & 0x3F));
                _local_9 = (_local_9 + 2);
            };
            return (_local_4);
        }

        protected function desFunc(_arg_1:Array, _arg_2:ByteArray, _arg_3:uint, _arg_4:ByteArray, _arg_5:uint):void
        {
            var _local_6:uint;
            var _local_7:uint;
            var _local_8:uint;
            var _local_10:uint;
            _local_8 = ((_arg_2[(_arg_3 + 0)] & 0xFF) << 24);
            _local_8 = (_local_8 | ((_arg_2[(_arg_3 + 1)] & 0xFF) << 16));
            _local_8 = (_local_8 | ((_arg_2[(_arg_3 + 2)] & 0xFF) << 8));
            _local_8 = (_local_8 | (_arg_2[(_arg_3 + 3)] & 0xFF));
            _local_7 = ((_arg_2[(_arg_3 + 4)] & 0xFF) << 24);
            _local_7 = (_local_7 | ((_arg_2[(_arg_3 + 5)] & 0xFF) << 16));
            _local_7 = (_local_7 | ((_arg_2[(_arg_3 + 6)] & 0xFF) << 8));
            _local_7 = (_local_7 | (_arg_2[(_arg_3 + 7)] & 0xFF));
            _local_6 = (((_local_8 >>> 4) ^ _local_7) & 0x0F0F0F0F);
            _local_7 = (_local_7 ^ _local_6);
            _local_8 = (_local_8 ^ (_local_6 << 4));
            _local_6 = (((_local_8 >>> 16) ^ _local_7) & 0xFFFF);
            _local_7 = (_local_7 ^ _local_6);
            _local_8 = (_local_8 ^ (_local_6 << 16));
            _local_6 = (((_local_7 >>> 2) ^ _local_8) & 0x33333333);
            _local_8 = (_local_8 ^ _local_6);
            _local_7 = (_local_7 ^ (_local_6 << 2));
            _local_6 = (((_local_7 >>> 8) ^ _local_8) & 0xFF00FF);
            _local_8 = (_local_8 ^ _local_6);
            _local_7 = (_local_7 ^ (_local_6 << 8));
            _local_7 = (((_local_7 << 1) | ((_local_7 >>> 31) & 0x01)) & 0xFFFFFFFF);
            _local_6 = ((_local_8 ^ _local_7) & 0xAAAAAAAA);
            _local_8 = (_local_8 ^ _local_6);
            _local_7 = (_local_7 ^ _local_6);
            _local_8 = (((_local_8 << 1) | ((_local_8 >>> 31) & 0x01)) & 0xFFFFFFFF);
            var _local_9:uint;
            while (_local_9 < 8)
            {
                _local_6 = ((_local_7 << 28) | (_local_7 >>> 4));
                _local_6 = (_local_6 ^ _arg_1[((_local_9 * 4) + 0)]);
                _local_10 = SP7[(_local_6 & 0x3F)];
                _local_10 = (_local_10 | SP5[((_local_6 >>> 8) & 0x3F)]);
                _local_10 = (_local_10 | SP3[((_local_6 >>> 16) & 0x3F)]);
                _local_10 = (_local_10 | SP1[((_local_6 >>> 24) & 0x3F)]);
                _local_6 = (_local_7 ^ _arg_1[((_local_9 * 4) + 1)]);
                _local_10 = (_local_10 | SP8[(_local_6 & 0x3F)]);
                _local_10 = (_local_10 | SP6[((_local_6 >>> 8) & 0x3F)]);
                _local_10 = (_local_10 | SP4[((_local_6 >>> 16) & 0x3F)]);
                _local_10 = (_local_10 | SP2[((_local_6 >>> 24) & 0x3F)]);
                _local_8 = (_local_8 ^ _local_10);
                _local_6 = ((_local_8 << 28) | (_local_8 >>> 4));
                _local_6 = (_local_6 ^ _arg_1[((_local_9 * 4) + 2)]);
                _local_10 = SP7[(_local_6 & 0x3F)];
                _local_10 = (_local_10 | SP5[((_local_6 >>> 8) & 0x3F)]);
                _local_10 = (_local_10 | SP3[((_local_6 >>> 16) & 0x3F)]);
                _local_10 = (_local_10 | SP1[((_local_6 >>> 24) & 0x3F)]);
                _local_6 = (_local_8 ^ _arg_1[((_local_9 * 4) + 3)]);
                _local_10 = (_local_10 | SP8[(_local_6 & 0x3F)]);
                _local_10 = (_local_10 | SP6[((_local_6 >>> 8) & 0x3F)]);
                _local_10 = (_local_10 | SP4[((_local_6 >>> 16) & 0x3F)]);
                _local_10 = (_local_10 | SP2[((_local_6 >>> 24) & 0x3F)]);
                _local_7 = (_local_7 ^ _local_10);
                _local_9++;
            };
            _local_7 = ((_local_7 << 31) | (_local_7 >>> 1));
            _local_6 = ((_local_8 ^ _local_7) & 0xAAAAAAAA);
            _local_8 = (_local_8 ^ _local_6);
            _local_7 = (_local_7 ^ _local_6);
            _local_8 = ((_local_8 << 31) | (_local_8 >>> 1));
            _local_6 = (((_local_8 >>> 8) ^ _local_7) & 0xFF00FF);
            _local_7 = (_local_7 ^ _local_6);
            _local_8 = (_local_8 ^ (_local_6 << 8));
            _local_6 = (((_local_8 >>> 2) ^ _local_7) & 0x33333333);
            _local_7 = (_local_7 ^ _local_6);
            _local_8 = (_local_8 ^ (_local_6 << 2));
            _local_6 = (((_local_7 >>> 16) ^ _local_8) & 0xFFFF);
            _local_8 = (_local_8 ^ _local_6);
            _local_7 = (_local_7 ^ (_local_6 << 16));
            _local_6 = (((_local_7 >>> 4) ^ _local_8) & 0x0F0F0F0F);
            _local_8 = (_local_8 ^ _local_6);
            _local_7 = (_local_7 ^ (_local_6 << 4));
            _arg_4[(_arg_5 + 0)] = ((_local_7 >>> 24) & 0xFF);
            _arg_4[(_arg_5 + 1)] = ((_local_7 >>> 16) & 0xFF);
            _arg_4[(_arg_5 + 2)] = ((_local_7 >>> 8) & 0xFF);
            _arg_4[(_arg_5 + 3)] = (_local_7 & 0xFF);
            _arg_4[(_arg_5 + 4)] = ((_local_8 >>> 24) & 0xFF);
            _arg_4[(_arg_5 + 5)] = ((_local_8 >>> 16) & 0xFF);
            _arg_4[(_arg_5 + 6)] = ((_local_8 >>> 8) & 0xFF);
            _arg_4[(_arg_5 + 7)] = (_local_8 & 0xFF);
        }

        public function toString():String
        {
            return ("des");
        }


    }
}//package com.hurlant.crypto.symmetric

