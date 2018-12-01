// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.hurlant.crypto.symmetric.TripleDESKey

package com.hurlant.crypto.symmetric
{
    import flash.utils.ByteArray;
    import com.hurlant.util.Memory;

    public class TripleDESKey extends DESKey 
    {

        protected var encKey2:Array;
        protected var encKey3:Array;
        protected var decKey2:Array;
        protected var decKey3:Array;

        public function TripleDESKey(_arg_1:ByteArray)
        {
            super(_arg_1);
            this.encKey2 = generateWorkingKey(false, _arg_1, 8);
            this.decKey2 = generateWorkingKey(true, _arg_1, 8);
            if (_arg_1.length > 16)
            {
                this.encKey3 = generateWorkingKey(true, _arg_1, 16);
                this.decKey3 = generateWorkingKey(false, _arg_1, 16);
            }
            else
            {
                this.encKey3 = encKey;
                this.decKey3 = decKey;
            };
        }

        override public function dispose():void
        {
            super.dispose();
            var _local_1:uint;
            if (this.encKey2 != null)
            {
                _local_1 = 0;
                while (_local_1 < this.encKey2.length)
                {
                    this.encKey2[_local_1] = 0;
                    _local_1++;
                };
                this.encKey2 = null;
            };
            if (this.encKey3 != null)
            {
                _local_1 = 0;
                while (_local_1 < this.encKey3.length)
                {
                    this.encKey3[_local_1] = 0;
                    _local_1++;
                };
                this.encKey3 = null;
            };
            if (this.decKey2 != null)
            {
                _local_1 = 0;
                while (_local_1 < this.decKey2.length)
                {
                    this.decKey2[_local_1] = 0;
                    _local_1++;
                };
                this.decKey2 = null;
            };
            if (this.decKey3 != null)
            {
                _local_1 = 0;
                while (_local_1 < this.decKey3.length)
                {
                    this.decKey3[_local_1] = 0;
                    _local_1++;
                };
                this.decKey3 = null;
            };
            Memory.gc();
        }

        override public function encrypt(_arg_1:ByteArray, _arg_2:uint=0):void
        {
            desFunc(encKey, _arg_1, _arg_2, _arg_1, _arg_2);
            desFunc(this.encKey2, _arg_1, _arg_2, _arg_1, _arg_2);
            desFunc(this.encKey3, _arg_1, _arg_2, _arg_1, _arg_2);
        }

        override public function decrypt(_arg_1:ByteArray, _arg_2:uint=0):void
        {
            desFunc(this.decKey3, _arg_1, _arg_2, _arg_1, _arg_2);
            desFunc(this.decKey2, _arg_1, _arg_2, _arg_1, _arg_2);
            desFunc(decKey, _arg_1, _arg_2, _arg_1, _arg_2);
        }

        override public function toString():String
        {
            return ("3des");
        }


    }
}//package com.hurlant.crypto.symmetric

