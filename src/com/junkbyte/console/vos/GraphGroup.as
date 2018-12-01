// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.junkbyte.console.vos.GraphGroup

package com.junkbyte.console.vos
{
    import flash.geom.Rectangle;
    import flash.utils.ByteArray;

    public class GraphGroup 
    {

        public static const FPS:uint = 1;
        public static const MEM:uint = 2;

        public var type:uint;
        public var name:String;
        public var freq:int = 1;
        public var low:Number;
        public var hi:Number;
        public var fixed:Boolean;
        public var averaging:uint;
        public var inv:Boolean;
        public var interests:Array = [];
        public var rect:Rectangle;
        public var idle:int;

        public function GraphGroup(_arg_1:String)
        {
            this.name = _arg_1;
        }

        public static function FromBytes(_arg_1:ByteArray):GraphGroup
        {
            var _local_2:GraphGroup = new GraphGroup(_arg_1.readUTF());
            _local_2.type = _arg_1.readUnsignedInt();
            _local_2.idle = _arg_1.readUnsignedInt();
            _local_2.low = _arg_1.readDouble();
            _local_2.hi = _arg_1.readDouble();
            _local_2.inv = _arg_1.readBoolean();
            var _local_3:uint = _arg_1.readUnsignedInt();
            while (_local_3)
            {
                _local_2.interests.push(GraphInterest.FromBytes(_arg_1));
                _local_3--;
            };
            return (_local_2);
        }


        public function updateMinMax(_arg_1:Number):void
        {
            if (((!(isNaN(_arg_1))) && (!(this.fixed))))
            {
                if (isNaN(this.low))
                {
                    this.low = _arg_1;
                    this.hi = _arg_1;
                };
                if (_arg_1 > this.hi)
                {
                    this.hi = _arg_1;
                };
                if (_arg_1 < this.low)
                {
                    this.low = _arg_1;
                };
            };
        }

        public function toBytes(_arg_1:ByteArray):void
        {
            var _local_2:GraphInterest;
            _arg_1.writeUTF(this.name);
            _arg_1.writeUnsignedInt(this.type);
            _arg_1.writeUnsignedInt(this.idle);
            _arg_1.writeDouble(this.low);
            _arg_1.writeDouble(this.hi);
            _arg_1.writeBoolean(this.inv);
            _arg_1.writeUnsignedInt(this.interests.length);
            for each (_local_2 in this.interests)
            {
                _local_2.toBytes(_arg_1);
            };
        }


    }
}//package com.junkbyte.console.vos

