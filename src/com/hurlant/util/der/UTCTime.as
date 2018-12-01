// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.hurlant.util.der.UTCTime

package com.hurlant.util.der
{
    import flash.utils.ByteArray;

    public class UTCTime implements IAsn1Type 
    {

        protected var type:uint;
        protected var len:uint;
        public var date:Date;

        public function UTCTime(_arg_1:uint, _arg_2:uint)
        {
            this.type = _arg_1;
            this.len = _arg_2;
        }

        public function getLength():uint
        {
            return (this.len);
        }

        public function getType():uint
        {
            return (this.type);
        }

        public function setUTCTime(_arg_1:String):void
        {
            var _local_2:uint = parseInt(_arg_1.substr(0, 2));
            if (_local_2 < 50)
            {
                _local_2 = (_local_2 + 2000);
            }
            else
            {
                _local_2 = (_local_2 + 1900);
            };
            var _local_3:uint = parseInt(_arg_1.substr(2, 2));
            var _local_4:uint = parseInt(_arg_1.substr(4, 2));
            var _local_5:uint = parseInt(_arg_1.substr(6, 2));
            var _local_6:uint = parseInt(_arg_1.substr(8, 2));
            this.date = new Date(_local_2, (_local_3 - 1), _local_4, _local_5, _local_6);
        }

        public function toString():String
        {
            return (((((((DER.indent + "UTCTime[") + this.type) + "][") + this.len) + "][") + this.date) + "]");
        }

        public function toDER():ByteArray
        {
            return (null);
        }


    }
}//package com.hurlant.util.der

