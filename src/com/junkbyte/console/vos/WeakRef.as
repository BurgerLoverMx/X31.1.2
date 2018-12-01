// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.junkbyte.console.vos.WeakRef

package com.junkbyte.console.vos
{
    import flash.utils.Dictionary;

    public class WeakRef 
    {

        private var _val:*;
        private var _strong:Boolean;

        public function WeakRef(_arg_1:*, _arg_2:Boolean=false)
        {
            this._strong = _arg_2;
            this.reference = _arg_1;
        }

        public function get reference():*
        {
            var _local_1:*;
            if (this._strong)
            {
                return (this._val);
            };
            for (_local_1 in this._val)
            {
                return (_local_1);
            };
            return (null);
        }

        public function set reference(_arg_1:*):void
        {
            if (this._strong)
            {
                this._val = _arg_1;
            }
            else
            {
                this._val = new Dictionary(true);
                this._val[_arg_1] = null;
            };
        }

        public function get strong():Boolean
        {
            return (this._strong);
        }


    }
}//package com.junkbyte.console.vos

