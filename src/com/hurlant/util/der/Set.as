// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.hurlant.util.der.Set

package com.hurlant.util.der
{
    public dynamic class Set extends Sequence implements IAsn1Type 
    {

        public function Set(_arg_1:uint=49, _arg_2:uint=0)
        {
            super(_arg_1, _arg_2);
        }

        override public function toString():String
        {
            var _local_1:String;
            _local_1 = DER.indent;
            DER.indent = (DER.indent + "    ");
            var _local_2:String = join("\n");
            DER.indent = _local_1;
            return (((((((((DER.indent + "Set[") + type) + "][") + len) + "][\n") + _local_2) + "\n") + _local_1) + "]");
        }


    }
}//package com.hurlant.util.der

