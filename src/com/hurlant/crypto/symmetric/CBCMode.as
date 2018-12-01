// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.hurlant.crypto.symmetric.CBCMode

package com.hurlant.crypto.symmetric
{
    import flash.utils.ByteArray;

    public class CBCMode extends IVMode implements IMode 
    {

        public function CBCMode(_arg_1:ISymmetricKey, _arg_2:IPad=null)
        {
            super(_arg_1, _arg_2);
        }

        public function encrypt(_arg_1:ByteArray):void
        {
            var _local_4:uint;
            padding.pad(_arg_1);
            var _local_2:ByteArray = getIV4e();
            var _local_3:uint;
            while (_local_3 < _arg_1.length)
            {
                _local_4 = 0;
                while (_local_4 < blockSize)
                {
                    _arg_1[(_local_3 + _local_4)] = (_arg_1[(_local_3 + _local_4)] ^ _local_2[_local_4]);
                    _local_4++;
                };
                key.encrypt(_arg_1, _local_3);
                _local_2.position = 0;
                _local_2.writeBytes(_arg_1, _local_3, blockSize);
                _local_3 = (_local_3 + blockSize);
            };
        }

        public function decrypt(_arg_1:ByteArray):void
        {
            var _local_5:uint;
            var _local_2:ByteArray = getIV4d();
            var _local_3:ByteArray = new ByteArray();
            var _local_4:uint;
            while (_local_4 < _arg_1.length)
            {
                _local_3.position = 0;
                _local_3.writeBytes(_arg_1, _local_4, blockSize);
                key.decrypt(_arg_1, _local_4);
                _local_5 = 0;
                while (_local_5 < blockSize)
                {
                    _arg_1[(_local_4 + _local_5)] = (_arg_1[(_local_4 + _local_5)] ^ _local_2[_local_5]);
                    _local_5++;
                };
                _local_2.position = 0;
                _local_2.writeBytes(_local_3, 0, blockSize);
                _local_4 = (_local_4 + blockSize);
            };
            padding.unpad(_arg_1);
        }

        public function toString():String
        {
            return (key.toString() + "-cbc");
        }


    }
}//package com.hurlant.crypto.symmetric

