// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.junkbyte.console.KeyBind

package com.junkbyte.console
{
    public class KeyBind 
    {

        private var _code:Boolean;
        private var _key:String;

        public function KeyBind(_arg_1:*, _arg_2:Boolean=false, _arg_3:Boolean=false, _arg_4:Boolean=false, _arg_5:Boolean=false)
        {
            this._key = String(_arg_1).toUpperCase();
            if ((_arg_1 is uint))
            {
                this._code = true;
            }
            else
            {
                if (((!(_arg_1)) || (!(this._key.length == 1))))
                {
                    throw (new Error((("KeyBind: character (first char) must be a single character. You gave [" + _arg_1) + "]")));
                };
            };
            if (this._code)
            {
                this._key = ("keycode:" + this._key);
            };
            if (_arg_2)
            {
                this._key = (this._key + "+shift");
            };
            if (_arg_3)
            {
                this._key = (this._key + "+ctrl");
            };
            if (_arg_4)
            {
                this._key = (this._key + "+alt");
            };
            if (_arg_5)
            {
                this._key = (this._key + "+up");
            };
        }

        public function get useKeyCode():Boolean
        {
            return (this._code);
        }

        public function get key():String
        {
            return (this._key);
        }


    }
}//package com.junkbyte.console

