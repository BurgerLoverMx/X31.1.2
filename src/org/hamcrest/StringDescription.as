// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.hamcrest.StringDescription

package org.hamcrest
{
    public class StringDescription extends BaseDescription 
    {

        private var _out:String;

        public function StringDescription()
        {
            clear();
        }

        public static function toString(_arg_1:SelfDescribing):String
        {
            return (new (StringDescription)().appendDescriptionOf(_arg_1).toString());
        }


        override protected function append(_arg_1:Object):void
        {
            _out = (_out + String(_arg_1));
        }

        override public function toString():String
        {
            return (_out);
        }

        public function clear():void
        {
            _out = "";
        }


    }
}//package org.hamcrest

