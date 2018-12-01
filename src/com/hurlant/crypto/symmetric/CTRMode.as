// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.hurlant.crypto.symmetric.CTRMode

package com.hurlant.crypto.symmetric
{
    import flash.utils.ByteArray;

    public class CTRMode extends IVMode implements IMode 
    {

        public function CTRMode(_arg_1:ISymmetricKey, _arg_2:IPad=null)
        {
            super(_arg_1, _arg_2);
        }

        public function encrypt(_arg_1:ByteArray):void
        {
            padding.pad(_arg_1);
            var _local_2:ByteArray = getIV4e();
            this.core(_arg_1, _local_2);
        }

        public function decrypt(_arg_1:ByteArray):void
        {
            var _local_2:ByteArray = getIV4d();
            this.core(_arg_1, _local_2);
            padding.unpad(_arg_1);
        }

        private function core(_arg_1:ByteArray, _arg_2:ByteArray):void
        {
            var _local_6:uint;
            var _local_3:ByteArray = new ByteArray();
            var _local_4:ByteArray = new ByteArray();
            _local_3.writeBytes(_arg_2);
            var _local_5:uint;
            while (_local_5 < _arg_1.length)
            {
                _local_4.position = 0;
                _local_4.writeBytes(_local_3);
                key.encrypt(_local_4);
                _local_6 = 0;
                while (_local_6 < blockSize)
                {
                    _arg_1[(_local_5 + _local_6)] = (_arg_1[(_local_5 + _local_6)] ^ _local_4[_local_6]);
                    _local_6++;
                };
                _local_6 = (blockSize - 1);
                while (_local_6 >= 0)
                {
                    _local_3[_local_6]++;
                    if (_local_3[_local_6] != 0) break;
                    _local_6--;
                };
                _local_5 = (_local_5 + blockSize);
            };
        }

        public function toString():String
        {
            return (key.toString() + "-ctr");
        }


    }
}//package com.hurlant.crypto.symmetric

