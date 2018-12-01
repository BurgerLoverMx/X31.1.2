// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.hurlant.crypto.hash.HMAC

package com.hurlant.crypto.hash
{
    import flash.utils.ByteArray;

    public class HMAC implements IHMAC 
    {

        private var hash:IHash;
        private var bits:uint;

        public function HMAC(_arg_1:IHash, _arg_2:uint=0)
        {
            this.hash = _arg_1;
            this.bits = _arg_2;
        }

        public function getHashSize():uint
        {
            if (this.bits != 0)
            {
                return (this.bits / 8);
            };
            return (this.hash.getHashSize());
        }

        public function compute(_arg_1:ByteArray, _arg_2:ByteArray):ByteArray
        {
            var _local_3:ByteArray;
            if (_arg_1.length > this.hash.getInputSize())
            {
                _local_3 = this.hash.hash(_arg_1);
            }
            else
            {
                _local_3 = new ByteArray();
                _local_3.writeBytes(_arg_1);
            };
            while (_local_3.length < this.hash.getInputSize())
            {
                _local_3[_local_3.length] = 0;
            };
            var _local_4:ByteArray = new ByteArray();
            var _local_5:ByteArray = new ByteArray();
            var _local_6:uint;
            while (_local_6 < _local_3.length)
            {
                _local_4[_local_6] = (_local_3[_local_6] ^ 0x36);
                _local_5[_local_6] = (_local_3[_local_6] ^ 0x5C);
                _local_6++;
            };
            _local_4.position = _local_3.length;
            _local_4.writeBytes(_arg_2);
            var _local_7:ByteArray = this.hash.hash(_local_4);
            _local_5.position = _local_3.length;
            _local_5.writeBytes(_local_7);
            var _local_8:ByteArray = this.hash.hash(_local_5);
            if (((this.bits > 0) && (this.bits < (8 * _local_8.length))))
            {
                _local_8.length = (this.bits / 8);
            };
            return (_local_8);
        }

        public function dispose():void
        {
            this.hash = null;
            this.bits = 0;
        }

        public function toString():String
        {
            return (("hmac-" + ((this.bits > 0) ? (this.bits + "-") : "")) + this.hash.toString());
        }


    }
}//package com.hurlant.crypto.hash

