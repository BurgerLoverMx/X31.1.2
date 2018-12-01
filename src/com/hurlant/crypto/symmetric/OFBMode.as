// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.hurlant.crypto.symmetric.OFBMode

package com.hurlant.crypto.symmetric
{
    import flash.utils.ByteArray;

    public class OFBMode extends IVMode implements IMode 
    {

        public function OFBMode(_arg_1:ISymmetricKey, _arg_2:IPad=null)
        {
            super(_arg_1, null);
        }

        public function encrypt(_arg_1:ByteArray):void
        {
            var _local_2:ByteArray = getIV4e();
            this.core(_arg_1, _local_2);
        }

        public function decrypt(_arg_1:ByteArray):void
        {
            var _local_2:ByteArray = getIV4d();
            this.core(_arg_1, _local_2);
        }

        private function core(_arg_1:ByteArray, _arg_2:ByteArray):void
        {
            var _local_6:uint;
            var _local_7:uint;
            var _local_3:uint = _arg_1.length;
            var _local_4:ByteArray = new ByteArray();
            var _local_5:uint;
            while (_local_5 < _arg_1.length)
            {
                key.encrypt(_arg_2);
                _local_4.position = 0;
                _local_4.writeBytes(_arg_2);
                _local_6 = (((_local_5 + blockSize) < _local_3) ? blockSize : (_local_3 - _local_5));
                _local_7 = 0;
                while (_local_7 < _local_6)
                {
                    _arg_1[(_local_5 + _local_7)] = (_arg_1[(_local_5 + _local_7)] ^ _arg_2[_local_7]);
                    _local_7++;
                };
                _arg_2.position = 0;
                _arg_2.writeBytes(_local_4);
                _local_5 = (_local_5 + blockSize);
            };
        }

        public function toString():String
        {
            return (key.toString() + "-ofb");
        }


    }
}//package com.hurlant.crypto.symmetric

