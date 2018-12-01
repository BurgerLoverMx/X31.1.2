// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.junkbyte.console.vos.Log

package com.junkbyte.console.vos
{
    import flash.utils.ByteArray;

    public class Log 
    {

        public var line:uint;
        public var text:String;
        public var ch:String;
        public var priority:int;
        public var repeat:Boolean;
        public var html:Boolean;
        public var time:uint;
        public var timeStr:String;
        public var lineStr:String;
        public var chStr:String;
        public var next:Log;
        public var prev:Log;

        public function Log(_arg_1:String, _arg_2:String, _arg_3:int, _arg_4:Boolean=false, _arg_5:Boolean=false)
        {
            this.text = _arg_1;
            this.ch = _arg_2;
            this.priority = _arg_3;
            this.repeat = _arg_4;
            this.html = _arg_5;
        }

        public static function FromBytes(_arg_1:ByteArray):Log
        {
            var _local_2:String = _arg_1.readUTFBytes(_arg_1.readUnsignedInt());
            var _local_3:String = _arg_1.readUTF();
            var _local_4:int = _arg_1.readInt();
            var _local_5:Boolean = _arg_1.readBoolean();
            return (new Log(_local_2, _local_3, _local_4, _local_5, true));
        }


        public function toBytes(_arg_1:ByteArray):void
        {
            var _local_2:ByteArray = new ByteArray();
            _local_2.writeUTFBytes(this.text);
            _arg_1.writeUnsignedInt(_local_2.length);
            _arg_1.writeBytes(_local_2);
            _arg_1.writeUTF(this.ch);
            _arg_1.writeInt(this.priority);
            _arg_1.writeBoolean(this.repeat);
        }

        public function plainText():String
        {
            return (this.text.replace(/<.*?>/g, "").replace(/&lt;/g, "<").replace(/&gt;/g, ">"));
        }

        public function toString():String
        {
            return ((("[" + this.ch) + "] ") + this.plainText());
        }

        public function clone():Log
        {
            var _local_1:Log = new Log(this.text, this.ch, this.priority, this.repeat, this.html);
            _local_1.line = this.line;
            _local_1.time = this.time;
            return (_local_1);
        }


    }
}//package com.junkbyte.console.vos

