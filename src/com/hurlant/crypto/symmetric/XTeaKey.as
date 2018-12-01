// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.hurlant.crypto.symmetric.XTeaKey

package com.hurlant.crypto.symmetric
{
    import flash.utils.ByteArray;
    import com.hurlant.crypto.prng.Random;
    import com.hurlant.util.Memory;

    public class XTeaKey implements ISymmetricKey 
    {

        public const NUM_ROUNDS:uint = 64;

        private var k:Array;

        public function XTeaKey(_arg_1:ByteArray)
        {
            _arg_1.position = 0;
            this.k = [_arg_1.readUnsignedInt(), _arg_1.readUnsignedInt(), _arg_1.readUnsignedInt(), _arg_1.readUnsignedInt()];
        }

        public static function parseKey(_arg_1:String):XTeaKey
        {
            var _local_2:ByteArray = new ByteArray();
            _local_2.writeUnsignedInt(parseInt(_arg_1.substr(0, 8), 16));
            _local_2.writeUnsignedInt(parseInt(_arg_1.substr(8, 8), 16));
            _local_2.writeUnsignedInt(parseInt(_arg_1.substr(16, 8), 16));
            _local_2.writeUnsignedInt(parseInt(_arg_1.substr(24, 8), 16));
            _local_2.position = 0;
            return (new XTeaKey(_local_2));
        }


        public function getBlockSize():uint
        {
            return (8);
        }

        public function encrypt(_arg_1:ByteArray, _arg_2:uint=0):void
        {
            var _local_5:uint;
            _arg_1.position = _arg_2;
            var _local_3:uint = _arg_1.readUnsignedInt();
            var _local_4:uint = _arg_1.readUnsignedInt();
            var _local_6:uint;
            var _local_7:uint = 2654435769;
            _local_5 = 0;
            while (_local_5 < this.NUM_ROUNDS)
            {
                _local_3 = (_local_3 + ((((_local_4 << 4) ^ (_local_4 >> 5)) + _local_4) ^ (_local_6 + this.k[(_local_6 & 0x03)])));
                _local_6 = (_local_6 + _local_7);
                _local_4 = (_local_4 + ((((_local_3 << 4) ^ (_local_3 >> 5)) + _local_3) ^ (_local_6 + this.k[((_local_6 >> 11) & 0x03)])));
                _local_5++;
            };
            _arg_1.position = (_arg_1.position - 8);
            _arg_1.writeUnsignedInt(_local_3);
            _arg_1.writeUnsignedInt(_local_4);
        }

        public function decrypt(_arg_1:ByteArray, _arg_2:uint=0):void
        {
            var _local_5:uint;
            _arg_1.position = _arg_2;
            var _local_3:uint = _arg_1.readUnsignedInt();
            var _local_4:uint = _arg_1.readUnsignedInt();
            var _local_6:uint = 2654435769;
            var _local_7:uint = (_local_6 * this.NUM_ROUNDS);
            _local_5 = 0;
            while (_local_5 < this.NUM_ROUNDS)
            {
                _local_4 = (_local_4 - ((((_local_3 << 4) ^ (_local_3 >> 5)) + _local_3) ^ (_local_7 + this.k[((_local_7 >> 11) & 0x03)])));
                _local_7 = (_local_7 - _local_6);
                _local_3 = (_local_3 - ((((_local_4 << 4) ^ (_local_4 >> 5)) + _local_4) ^ (_local_7 + this.k[(_local_7 & 0x03)])));
                _local_5++;
            };
            _arg_1.position = (_arg_1.position - 8);
            _arg_1.writeUnsignedInt(_local_3);
            _arg_1.writeUnsignedInt(_local_4);
        }

        public function dispose():void
        {
            var _local_1:Random = new Random();
            var _local_2:uint;
            while (_local_2 < this.k.length)
            {
                this.k[_local_2] = _local_1.nextByte();
                delete this.k[_local_2];
                _local_2++;
            };
            this.k = null;
            Memory.gc();
        }

        public function toString():String
        {
            return ("xtea");
        }


    }
}//package com.hurlant.crypto.symmetric

