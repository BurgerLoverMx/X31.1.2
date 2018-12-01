// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.hurlant.util.der.Integer

package com.hurlant.util.der
{
    import com.hurlant.math.BigInteger;
    import flash.utils.ByteArray;

    public class Integer extends BigInteger implements IAsn1Type 
    {

        private var type:uint;
        private var len:uint;

        public function Integer(_arg_1:uint, _arg_2:uint, _arg_3:ByteArray)
        {
            this.type = _arg_1;
            this.len = _arg_2;
            super(_arg_3);
        }

        public function getLength():uint
        {
            return (this.len);
        }

        public function getType():uint
        {
            return (this.type);
        }

        override public function toString(_arg_1:Number=0):String
        {
            return (((((((DER.indent + "Integer[") + this.type) + "][") + this.len) + "][") + super.toString(16)) + "]");
        }

        public function toDER():ByteArray
        {
            return (null);
        }


    }
}//package com.hurlant.util.der

