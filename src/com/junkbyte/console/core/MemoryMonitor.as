// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.junkbyte.console.core.MemoryMonitor

package com.junkbyte.console.core
{
    import flash.utils.Dictionary;
    import com.junkbyte.console.Console;
    import flash.utils.getQualifiedClassName;
    import flash.utils.getTimer;
    import flash.system.System;

    public class MemoryMonitor extends ConsoleCore 
    {

        private var _namesList:Object;
        private var _objectsList:Dictionary;
        private var _count:uint;

        public function MemoryMonitor(_arg_1:Console)
        {
            super(_arg_1);
            this._namesList = new Object();
            this._objectsList = new Dictionary(true);
            console.remoter.registerCallback("gc", this.gc);
        }

        public function watch(_arg_1:Object, _arg_2:String):String
        {
            var _local_3:String = getQualifiedClassName(_arg_1);
            if (!_arg_2)
            {
                _arg_2 = ((_local_3 + "@") + getTimer());
            };
            if (this._objectsList[_arg_1])
            {
                if (this._namesList[this._objectsList[_arg_1]])
                {
                    this.unwatch(this._objectsList[_arg_1]);
                };
            };
            if (this._namesList[_arg_2])
            {
                if (this._objectsList[_arg_1] == _arg_2)
                {
                    this._count--;
                }
                else
                {
                    _arg_2 = ((((_arg_2 + "@") + getTimer()) + "_") + Math.floor((Math.random() * 100)));
                };
            };
            this._namesList[_arg_2] = true;
            this._count++;
            this._objectsList[_arg_1] = _arg_2;
            return (_arg_2);
        }

        public function unwatch(_arg_1:String):void
        {
            var _local_2:Object;
            for (_local_2 in this._objectsList)
            {
                if (this._objectsList[_local_2] == _arg_1)
                {
                    delete this._objectsList[_local_2];
                };
            };
            if (this._namesList[_arg_1])
            {
                delete this._namesList[_arg_1];
                this._count--;
            };
        }

        public function update():void
        {
            var _local_3:Object;
            var _local_4:String;
            if (this._count == 0)
            {
                return;
            };
            var _local_1:Array = new Array();
            var _local_2:Object = new Object();
            for (_local_3 in this._objectsList)
            {
                _local_2[this._objectsList[_local_3]] = true;
            };
            for (_local_4 in this._namesList)
            {
                if (!_local_2[_local_4])
                {
                    _local_1.push(_local_4);
                    delete this._namesList[_local_4];
                    this._count--;
                };
            };
            if (_local_1.length)
            {
                report(((("<b>GARBAGE COLLECTED " + _local_1.length) + " item(s): </b>") + _local_1.join(", ")), -2);
            };
        }

        public function get count():uint
        {
            return (this._count);
        }

        public function gc():void
        {
            var ok:Boolean;
            var str:String;
            if (remoter.remoting == Remoting.RECIEVER)
            {
                try
                {
                    remoter.send("gc");
                }
                catch(e:Error)
                {
                    report(e, 10);
                };
            }
            else
            {
                try
                {
                    if (System["gc"] != null)
                    {
                        var _local_2:* = System;
                        (_local_2["gc"]());
                        ok = true;
                    };
                }
                catch(e:Error)
                {
                };
                str = ("Manual garbage collection " + ((ok) ? "successful." : "FAILED. You need debugger version of flash player."));
                report(str, ((ok) ? -1 : 10));
            };
        }


    }
}//package com.junkbyte.console.core

