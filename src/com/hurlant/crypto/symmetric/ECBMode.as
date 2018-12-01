// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.hurlant.crypto.symmetric.ECBMode

package com.hurlant.crypto.symmetric
{
    import flash.utils.ByteArray;
    import com.hurlant.util.Memory;

    public class ECBMode implements IMode, ICipher 
    {

        private var key:ISymmetricKey;
        private var padding:IPad;

        public function ECBMode(_arg_1:ISymmetricKey, _arg_2:IPad=null)
        {
            this.key = _arg_1;
            if (_arg_2 == null)
            {
                _arg_2 = new PKCS5(_arg_1.getBlockSize());
            }
            else
            {
                _arg_2.setBlockSize(_arg_1.getBlockSize());
            };
            this.padding = _arg_2;
        }

        public function getBlockSize():uint
        {
            return (this.key.getBlockSize());
        }

        public function encrypt(_arg_1:ByteArray):void
        {
            this.padding.pad(_arg_1);
            _arg_1.position = 0;
            var _local_2:uint = this.key.getBlockSize();
            var _local_3:ByteArray = new ByteArray();
            var _local_4:ByteArray = new ByteArray();
            var _local_5:uint;
            while (_local_5 < _arg_1.length)
            {
                _local_3.length = 0;
                _arg_1.readBytes(_local_3, 0, _local_2);
                this.key.encrypt(_local_3);
                _local_4.writeBytes(_local_3);
                _local_5 = (_local_5 + _local_2);
            };
            _arg_1.length = 0;
            _arg_1.writeBytes(_local_4);
        }

        public function decrypt(_arg_1:ByteArray):void
        {
            _arg_1.position = 0;
            var _local_2:uint = this.key.getBlockSize();
            if ((_arg_1.length % _local_2) != 0)
            {
                throw (new Error(("ECB mode cipher length must be a multiple of blocksize " + _local_2)));
            };
            var _local_3:ByteArray = new ByteArray();
            var _local_4:ByteArray = new ByteArray();
            var _local_5:uint;
            while (_local_5 < _arg_1.length)
            {
                _local_3.length = 0;
                _arg_1.readBytes(_local_3, 0, _local_2);
                this.key.decrypt(_local_3);
                _local_4.writeBytes(_local_3);
                _local_5 = (_local_5 + _local_2);
            };
            this.padding.unpad(_local_4);
            _arg_1.length = 0;
            _arg_1.writeBytes(_local_4);
        }

        public function dispose():void
        {
            this.key.dispose();
            this.key = null;
            this.padding = null;
            Memory.gc();
        }

        public function toString():String
        {
            return (this.key.toString() + "-ecb");
        }


    }
}//package com.hurlant.crypto.symmetric

