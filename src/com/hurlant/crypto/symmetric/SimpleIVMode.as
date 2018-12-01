// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.hurlant.crypto.symmetric.SimpleIVMode

package com.hurlant.crypto.symmetric
{
    import com.hurlant.util.Memory;
    import flash.utils.ByteArray;

    public class SimpleIVMode implements IMode, ICipher 
    {

        protected var mode:IVMode;
        protected var cipher:ICipher;

        public function SimpleIVMode(_arg_1:IVMode)
        {
            this.mode = _arg_1;
            this.cipher = (_arg_1 as ICipher);
        }

        public function getBlockSize():uint
        {
            return (this.mode.getBlockSize());
        }

        public function dispose():void
        {
            this.mode.dispose();
            this.mode = null;
            this.cipher = null;
            Memory.gc();
        }

        public function encrypt(_arg_1:ByteArray):void
        {
            this.cipher.encrypt(_arg_1);
            var _local_2:ByteArray = new ByteArray();
            _local_2.writeBytes(this.mode.IV);
            _local_2.writeBytes(_arg_1);
            _arg_1.position = 0;
            _arg_1.writeBytes(_local_2);
        }

        public function decrypt(_arg_1:ByteArray):void
        {
            var _local_2:ByteArray = new ByteArray();
            _local_2.writeBytes(_arg_1, 0, this.getBlockSize());
            this.mode.IV = _local_2;
            _local_2 = new ByteArray();
            _local_2.writeBytes(_arg_1, this.getBlockSize());
            this.cipher.decrypt(_local_2);
            _arg_1.length = 0;
            _arg_1.writeBytes(_local_2);
        }

        public function toString():String
        {
            return ("simple-" + this.cipher.toString());
        }


    }
}//package com.hurlant.crypto.symmetric

