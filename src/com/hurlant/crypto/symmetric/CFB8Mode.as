// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.hurlant.crypto.symmetric.CFB8Mode

package com.hurlant.crypto.symmetric
{
    import flash.utils.ByteArray;

    public class CFB8Mode extends IVMode implements IMode 
    {

        public function CFB8Mode(_arg_1:ISymmetricKey, _arg_2:IPad=null)
        {
            super(_arg_1, null);
        }

        public function encrypt(_arg_1:ByteArray):void
        {
            var _local_5:uint;
            var _local_2:ByteArray = getIV4e();
            var _local_3:ByteArray = new ByteArray();
            var _local_4:uint;
            while (_local_4 < _arg_1.length)
            {
                _local_3.position = 0;
                _local_3.writeBytes(_local_2);
                key.encrypt(_local_2);
                _arg_1[_local_4] = (_arg_1[_local_4] ^ _local_2[0]);
                _local_5 = 0;
                while (_local_5 < (blockSize - 1))
                {
                    _local_2[_local_5] = _local_3[(_local_5 + 1)];
                    _local_5++;
                };
                _local_2[(blockSize - 1)] = _arg_1[_local_4];
                _local_4++;
            };
        }

        public function decrypt(_arg_1:ByteArray):void
        {
            var _local_5:uint;
            var _local_6:uint;
            var _local_2:ByteArray = getIV4d();
            var _local_3:ByteArray = new ByteArray();
            var _local_4:uint;
            while (_local_4 < _arg_1.length)
            {
                _local_5 = _arg_1[_local_4];
                _local_3.position = 0;
                _local_3.writeBytes(_local_2);
                key.encrypt(_local_2);
                _arg_1[_local_4] = (_arg_1[_local_4] ^ _local_2[0]);
                _local_6 = 0;
                while (_local_6 < (blockSize - 1))
                {
                    _local_2[_local_6] = _local_3[(_local_6 + 1)];
                    _local_6++;
                };
                _local_2[(blockSize - 1)] = _local_5;
                _local_4++;
            };
        }

        public function toString():String
        {
            return (key.toString() + "-cfb8");
        }


    }
}//package com.hurlant.crypto.symmetric

