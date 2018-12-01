// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.junkbyte.console.vos.GraphInterest

package com.junkbyte.console.vos
{
    import flash.utils.ByteArray;
    import com.junkbyte.console.core.Executer;

    public class GraphInterest 
    {

        private var _ref:WeakRef;
        public var _prop:String;
        private var useExec:Boolean;
        public var key:String;
        public var col:Number;
        public var v:Number;
        public var avg:Number;

        public function GraphInterest(_arg_1:String="", _arg_2:Number=0):void
        {
            this.col = _arg_2;
            this.key = _arg_1;
        }

        public static function FromBytes(_arg_1:ByteArray):GraphInterest
        {
            var _local_2:GraphInterest = new GraphInterest(_arg_1.readUTF(), _arg_1.readUnsignedInt());
            _local_2.v = _arg_1.readDouble();
            _local_2.avg = _arg_1.readDouble();
            return (_local_2);
        }


        public function setObject(_arg_1:Object, _arg_2:String):Number
        {
            this._ref = new WeakRef(_arg_1);
            this._prop = _arg_2;
            this.useExec = (this._prop.search(/[^\w\d]/) >= 0);
            this.v = this.getCurrentValue();
            this.avg = this.v;
            return (this.v);
        }

        public function get obj():Object
        {
            return ((this._ref != null) ? this._ref.reference : undefined);
        }

        public function get prop():String
        {
            return (this._prop);
        }

        public function getCurrentValue():Number
        {
            return ((this.useExec) ? Executer.Exec(this.obj, this._prop) : this.obj[this._prop]);
        }

        public function setValue(_arg_1:Number, _arg_2:uint=0):void
        {
            this.v = _arg_1;
            if (_arg_2 > 0)
            {
                if (isNaN(this.avg))
                {
                    this.avg = this.v;
                }
                else
                {
                    this.avg = (this.avg + ((this.v - this.avg) / _arg_2));
                };
            };
        }

        public function toBytes(_arg_1:ByteArray):void
        {
            _arg_1.writeUTF(this.key);
            _arg_1.writeUnsignedInt(this.col);
            _arg_1.writeDouble(this.v);
            _arg_1.writeDouble(this.avg);
        }


    }
}//package com.junkbyte.console.vos

