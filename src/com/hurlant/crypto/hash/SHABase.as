// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.hurlant.crypto.hash.SHABase

package com.hurlant.crypto.hash
{
    import flash.utils.Endian;
    import flash.utils.ByteArray;

    public class SHABase implements IHash 
    {

        public var pad_size:int = 40;


        public function getInputSize():uint
        {
            return (64);
        }

        public function getHashSize():uint
        {
            return (0);
        }

        public function getPadSize():int
        {
            return (this.pad_size);
        }

        public function hash(_arg_1:ByteArray):ByteArray
        {
            var _local_2:uint = _arg_1.length;
            var _local_3:String = _arg_1.endian;
            _arg_1.endian = Endian.BIG_ENDIAN;
            var _local_4:uint = (_local_2 * 8);
            while ((_arg_1.length % 4) != 0)
            {
                _arg_1[_arg_1.length] = 0;
            };
            _arg_1.position = 0;
            var _local_5:Array = [];
            var _local_6:uint;
            while (_local_6 < _arg_1.length)
            {
                _local_5.push(_arg_1.readUnsignedInt());
                _local_6 = (_local_6 + 4);
            };
            var _local_7:Array = this.core(_local_5, _local_4);
            var _local_8:ByteArray = new ByteArray();
            var _local_9:uint = uint((this.getHashSize() / 4));
            _local_6 = 0;
            while (_local_6 < _local_9)
            {
                _local_8.writeUnsignedInt(_local_7[_local_6]);
                _local_6++;
            };
            _arg_1.length = _local_2;
            _arg_1.endian = _local_3;
            return (_local_8);
        }

        protected function core(_arg_1:Array, _arg_2:uint):Array
        {
            return (null);
        }

        public function toString():String
        {
            return ("sha");
        }


    }
}//package com.hurlant.crypto.hash

