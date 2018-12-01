// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.junkbyte.console.core.Logs

package com.junkbyte.console.core
{
    import com.junkbyte.console.vos.Log;
    import flash.events.Event;
    import flash.utils.ByteArray;
    import com.junkbyte.console.Console;

    public class Logs extends ConsoleCore 
    {

        private var _channels:Object;
        private var _repeating:uint;
        private var _lastRepeat:Log;
        private var _newRepeat:Log;
        private var _hasNewLog:Boolean;
        private var _timer:uint;
        public var first:Log;
        public var last:Log;
        private var _length:uint;
        private var _lines:uint;

        public function Logs(console:Console)
        {
            super(console);
            this._channels = new Object();
            remoter.addEventListener(Event.CONNECT, this.onRemoteConnection);
            remoter.registerCallback("log", function (_arg_1:ByteArray):void
            {
                registerLog(Log.FromBytes(_arg_1));
            });
        }

        private function onRemoteConnection(_arg_1:Event):void
        {
            var _local_2:Log = this.first;
            while (_local_2)
            {
                this.send2Remote(_local_2);
                _local_2 = _local_2.next;
            };
        }

        private function send2Remote(_arg_1:Log):void
        {
            var _local_2:ByteArray;
            if (remoter.canSend)
            {
                _local_2 = new ByteArray();
                _arg_1.toBytes(_local_2);
                remoter.send("log", _local_2);
            };
        }

        public function update(_arg_1:uint):Boolean
        {
            this._timer = _arg_1;
            if (this._repeating > 0)
            {
                this._repeating--;
            };
            if (this._newRepeat)
            {
                if (this._lastRepeat)
                {
                    this.remove(this._lastRepeat);
                };
                this._lastRepeat = this._newRepeat;
                this._newRepeat = null;
                this.push(this._lastRepeat);
            };
            var _local_2:Boolean = this._hasNewLog;
            this._hasNewLog = false;
            return (_local_2);
        }

        public function add(_arg_1:Log):void
        {
            this._lines++;
            _arg_1.line = this._lines;
            _arg_1.time = this._timer;
            this.registerLog(_arg_1);
        }

        private function registerLog(_arg_1:Log):void
        {
            this._hasNewLog = true;
            this.addChannel(_arg_1.ch);
            _arg_1.lineStr = (_arg_1.line + " ");
            _arg_1.chStr = (((('[<a href="event:channel_' + _arg_1.ch) + '">') + _arg_1.ch) + "</a>] ");
            _arg_1.timeStr = (config.timeStampFormatter(_arg_1.time) + " ");
            this.send2Remote(_arg_1);
            if (_arg_1.repeat)
            {
                if (((this._repeating > 0) && (this._lastRepeat)))
                {
                    _arg_1.line = this._lastRepeat.line;
                    this._newRepeat = _arg_1;
                    return;
                };
                this._repeating = config.maxRepeats;
                this._lastRepeat = _arg_1;
            };
            this.push(_arg_1);
            while (((this._length > config.maxLines) && (config.maxLines > 0)))
            {
                this.remove(this.first);
            };
            if (((config.tracing) && (!(config.traceCall == null))))
            {
                config.traceCall(_arg_1.ch, _arg_1.plainText(), _arg_1.priority);
            };
        }

        public function clear(_arg_1:String=null):void
        {
            var _local_2:Log;
            if (_arg_1)
            {
                _local_2 = this.first;
                while (_local_2)
                {
                    if (_local_2.ch == _arg_1)
                    {
                        this.remove(_local_2);
                    };
                    _local_2 = _local_2.next;
                };
                delete this._channels[_arg_1];
            }
            else
            {
                this.first = null;
                this.last = null;
                this._length = 0;
                this._channels = new Object();
            };
        }

        public function getLogsAsString(_arg_1:String, _arg_2:Boolean=true, _arg_3:Function=null):String
        {
            var _local_4:* = "";
            var _local_5:Log = this.first;
            while (_local_5)
            {
                if (((_arg_3 == null) || (_arg_3(_local_5))))
                {
                    if (this.first != _local_5)
                    {
                        _local_4 = (_local_4 + _arg_1);
                    };
                    _local_4 = (_local_4 + ((_arg_2) ? _local_5.toString() : _local_5.plainText()));
                };
                _local_5 = _local_5.next;
            };
            return (_local_4);
        }

        public function getChannels():Array
        {
            var _local_3:String;
            var _local_1:Array = new Array(Console.GLOBAL_CHANNEL);
            this.addIfexist(Console.DEFAULT_CHANNEL, _local_1);
            this.addIfexist(Console.FILTER_CHANNEL, _local_1);
            this.addIfexist(LogReferences.INSPECTING_CHANNEL, _local_1);
            this.addIfexist(Console.CONSOLE_CHANNEL, _local_1);
            var _local_2:Array = new Array();
            for (_local_3 in this._channels)
            {
                if (_local_1.indexOf(_local_3) < 0)
                {
                    _local_2.push(_local_3);
                };
            };
            return (_local_1.concat(_local_2.sort(Array.CASEINSENSITIVE)));
        }

        private function addIfexist(_arg_1:String, _arg_2:Array):void
        {
            if (this._channels.hasOwnProperty(_arg_1))
            {
                _arg_2.push(_arg_1);
            };
        }

        public function cleanChannels():void
        {
            this._channels = new Object();
            var _local_1:Log = this.first;
            while (_local_1)
            {
                this.addChannel(_local_1.ch);
                _local_1 = _local_1.next;
            };
        }

        public function addChannel(_arg_1:String):void
        {
            this._channels[_arg_1] = null;
        }

        private function push(_arg_1:Log):void
        {
            if (this.last == null)
            {
                this.first = _arg_1;
            }
            else
            {
                this.last.next = _arg_1;
                _arg_1.prev = this.last;
            };
            this.last = _arg_1;
            this._length++;
        }

        private function remove(_arg_1:Log):void
        {
            if (this.first == _arg_1)
            {
                this.first = _arg_1.next;
            };
            if (this.last == _arg_1)
            {
                this.last = _arg_1.prev;
            };
            if (_arg_1 == this._lastRepeat)
            {
                this._lastRepeat = null;
            };
            if (_arg_1 == this._newRepeat)
            {
                this._newRepeat = null;
            };
            if (_arg_1.next != null)
            {
                _arg_1.next.prev = _arg_1.prev;
            };
            if (_arg_1.prev != null)
            {
                _arg_1.prev.next = _arg_1.next;
            };
            this._length--;
        }


    }
}//package com.junkbyte.console.core

