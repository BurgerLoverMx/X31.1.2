// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.junkbyte.console.core.ConsoleCore

package com.junkbyte.console.core
{
    import flash.events.EventDispatcher;
    import com.junkbyte.console.Console;
    import com.junkbyte.console.ConsoleConfig;

    public class ConsoleCore extends EventDispatcher 
    {

        protected var console:Console;
        protected var config:ConsoleConfig;

        public function ConsoleCore(_arg_1:Console)
        {
            this.console = _arg_1;
            this.config = this.console.config;
        }

        protected function get remoter():Remoting
        {
            return (this.console.remoter);
        }

        protected function report(_arg_1:*="", _arg_2:int=0, _arg_3:Boolean=true, _arg_4:String=null):void
        {
            this.console.report(_arg_1, _arg_2, _arg_3, _arg_4);
        }


    }
}//package com.junkbyte.console.core

