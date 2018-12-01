// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.junkbyte.console.vos.WeakObject

package com.junkbyte.console.vos
{
    import flash.utils.Proxy;
    import flash.utils.flash_proxy; 

    use namespace flash.utils.flash_proxy;

    public dynamic class WeakObject extends Proxy 
    {

        private var _item:Array;
        private var _dir:Object;

        public function WeakObject()
        {
            this._dir = new Object();
        }

        public function set(_arg_1:String, _arg_2:Object, _arg_3:Boolean=false):void
        {
            if (_arg_2 == null)
            {
                delete this._dir[_arg_1];
            }
            else
            {
                this._dir[_arg_1] = new WeakRef(_arg_2, _arg_3);
            };
        }

        public function get(_arg_1:String):*
        {
            var _local_2:WeakRef = this.getWeakRef(_arg_1);
            return ((_local_2) ? _local_2.reference : undefined);
        }

        public function getWeakRef(_arg_1:String):WeakRef
        {
            return (this._dir[_arg_1] as WeakRef);
        }

        override flash_proxy function getProperty(_arg_1:*):*
        {
            return (this.get(_arg_1));
        }

        override flash_proxy function callProperty(_arg_1:*, ... _args):*
        {
            var _local_3:Object = this.get(_arg_1);
            return (_local_3.apply(this, _args));
        }

        override flash_proxy function setProperty(_arg_1:*, _arg_2:*):void
        {
            this.set(_arg_1, _arg_2);
        }

        override flash_proxy function nextName(_arg_1:int):String
        {
            return (this._item[(_arg_1 - 1)]);
        }

        override flash_proxy function nextValue(_arg_1:int):*
        {
            return (this[this.nextName(_arg_1)]);
        }

        override flash_proxy function nextNameIndex(_arg_1:int):int
        {
            var _local_2:*;
            if (_arg_1 == 0)
            {
                this._item = new Array();
                for (_local_2 in this._dir)
                {
                    this._item.push(_local_2);
                };
            };
            if (_arg_1 < this._item.length)
            {
                return (_arg_1 + 1);
            };
            return (0);
        }

        override flash_proxy function deleteProperty(_arg_1:*):Boolean
        {
            return (delete this._dir[_arg_1]);
        }

        public function toString():String
        {
            return ("[WeakObject]");
        }


    }
}//package com.junkbyte.console.vos

