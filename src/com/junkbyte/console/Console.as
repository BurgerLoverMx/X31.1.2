// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.junkbyte.console.Console

package com.junkbyte.console
{
    import flash.display.Sprite;
    import com.junkbyte.console.view.PanelsManager;
    import com.junkbyte.console.core.CommandLine;
    import com.junkbyte.console.core.KeyBinder;
    import com.junkbyte.console.core.LogReferences;
    import com.junkbyte.console.core.MemoryMonitor;
    import com.junkbyte.console.core.Graphing;
    import com.junkbyte.console.core.Remoting;
    import com.junkbyte.console.core.ConsoleTools;
    import com.junkbyte.console.core.Logs;
    import flash.net.SharedObject;
    import flash.system.Capabilities;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.IEventDispatcher;
    import flash.display.LoaderInfo;
    import flash.events.ErrorEvent;
    import flash.geom.Rectangle;
    import com.junkbyte.console.view.RollerPanel;
    import flash.display.DisplayObjectContainer;
    import flash.utils.getTimer;
    import com.junkbyte.console.vos.Log;

    public class Console extends Sprite 
    {

        public static const VERSION:Number = 2.6;
        public static const VERSION_STAGE:String = "";
        public static const BUILD:int = 611;
        public static const BUILD_DATE:String = "2012/02/22 00:11";
        public static const LOG:uint = 1;
        public static const INFO:uint = 3;
        public static const DEBUG:uint = 6;
        public static const WARN:uint = 8;
        public static const ERROR:uint = 9;
        public static const FATAL:uint = 10;
        public static const GLOBAL_CHANNEL:String = " * ";
        public static const DEFAULT_CHANNEL:String = "-";
        public static const CONSOLE_CHANNEL:String = "C";
        public static const FILTER_CHANNEL:String = "~";

        private var _config:ConsoleConfig;
        private var _panels:PanelsManager;
        private var _cl:CommandLine;
        private var _kb:KeyBinder;
        private var _refs:LogReferences;
        private var _mm:MemoryMonitor;
        private var _graphing:Graphing;
        private var _remoter:Remoting;
        private var _tools:ConsoleTools;
        private var _topTries:int = 50;
        private var _paused:Boolean;
        private var _rollerKey:KeyBind;
        private var _logs:Logs;
        private var _so:SharedObject;
        private var _soData:Object = {};

        public function Console(password:String="", config:ConsoleConfig=null)
        {
            super();
            name = "Console";
            if (config == null)
            {
                config = new ConsoleConfig();
            };
            this._config = config;
            if (password)
            {
                this._config.keystrokePassword = password;
            };
            this._remoter = new Remoting(this);
            this._logs = new Logs(this);
            this._refs = new LogReferences(this);
            this._cl = new CommandLine(this);
            this._tools = new ConsoleTools(this);
            this._graphing = new Graphing(this);
            this._mm = new MemoryMonitor(this);
            this._kb = new KeyBinder(this);
            this.cl.addCLCmd("remotingSocket", function (_arg_1:String=""):void
            {
                var _local_2:Array = _arg_1.split(/\s+|\:/);
                remotingSocket(_local_2[0], _local_2[1]);
            }, "Connect to socket remote. /remotingSocket ip port");
            if (this._config.sharedObjectName)
            {
                try
                {
                    this._so = SharedObject.getLocal(this._config.sharedObjectName, this._config.sharedObjectPath);
                    this._soData = this._so.data;
                }
                catch(e:Error)
                {
                };
            };
            this._config.style.updateStyleSheet();
            this._panels = new PanelsManager(this);
            if (password)
            {
                this.visible = false;
            };
            this.report(((((((((("<b>Console v" + VERSION) + VERSION_STAGE) + "</b> build ") + BUILD) + ". ") + Capabilities.playerType) + " ") + Capabilities.version) + "."), -2);
            addEventListener(Event.ENTER_FRAME, this._onEnterFrame);
            addEventListener(Event.ADDED_TO_STAGE, this.stageAddedHandle);
        }

        public static function MakeChannelName(_arg_1:*):String
        {
            if ((_arg_1 is String))
            {
                return (_arg_1 as String);
            };
            if (_arg_1)
            {
                return (LogReferences.ShortClassName(_arg_1));
            };
            return (DEFAULT_CHANNEL);
        }


        private function stageAddedHandle(_arg_1:Event=null):void
        {
            if (this._cl.base == null)
            {
                this._cl.base = parent;
            };
            if (loaderInfo)
            {
                this.listenUncaughtErrors(loaderInfo);
            };
            removeEventListener(Event.ADDED_TO_STAGE, this.stageAddedHandle);
            addEventListener(Event.REMOVED_FROM_STAGE, this.stageRemovedHandle);
            stage.addEventListener(Event.MOUSE_LEAVE, this.onStageMouseLeave, false, 0, true);
            stage.addEventListener(KeyboardEvent.KEY_DOWN, this._kb.keyDownHandler, false, 0, true);
            stage.addEventListener(KeyboardEvent.KEY_UP, this._kb.keyUpHandler, false, 0, true);
        }

        private function stageRemovedHandle(_arg_1:Event=null):void
        {
            this._cl.base = null;
            removeEventListener(Event.REMOVED_FROM_STAGE, this.stageRemovedHandle);
            addEventListener(Event.ADDED_TO_STAGE, this.stageAddedHandle);
            stage.removeEventListener(Event.MOUSE_LEAVE, this.onStageMouseLeave);
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, this._kb.keyDownHandler);
            stage.removeEventListener(KeyboardEvent.KEY_UP, this._kb.keyUpHandler);
        }

        private function onStageMouseLeave(_arg_1:Event):void
        {
            this._panels.tooltip(null);
        }

        public function listenUncaughtErrors(_arg_1:LoaderInfo):void
        {
            var _local_2:IEventDispatcher;
            try
            {
                _local_2 = _arg_1["uncaughtErrorEvents"];
                if (_local_2)
                {
                    _local_2.addEventListener("uncaughtError", this.uncaughtErrorHandle, false, 0, true);
                };
            }
            catch(err:Error)
            {
            };
        }

        private function uncaughtErrorHandle(_arg_1:Event):void
        {
            var _local_3:String;
            var _local_2:* = ((_arg_1.hasOwnProperty("error")) ? _arg_1["error"] : _arg_1);
            if ((_local_2 is Error))
            {
                _local_3 = this._refs.makeString(_local_2);
            }
            else
            {
                if ((_local_2 is ErrorEvent))
                {
                    _local_3 = ErrorEvent(_local_2).text;
                };
            };
            if (!_local_3)
            {
                _local_3 = String(_local_2);
            };
            this.report(_local_3, FATAL, false);
        }

        public function addGraph(_arg_1:String, _arg_2:Object, _arg_3:String, _arg_4:Number=-1, _arg_5:String=null, _arg_6:Rectangle=null, _arg_7:Boolean=false):void
        {
            this._graphing.add(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
        }

        public function fixGraphRange(_arg_1:String, _arg_2:Number=NaN, _arg_3:Number=NaN):void
        {
            this._graphing.fixRange(_arg_1, _arg_2, _arg_3);
        }

        public function removeGraph(_arg_1:String, _arg_2:Object=null, _arg_3:String=null):void
        {
            this._graphing.remove(_arg_1, _arg_2, _arg_3);
        }

        public function bindKey(_arg_1:KeyBind, _arg_2:Function, _arg_3:Array=null):void
        {
            if (_arg_1)
            {
                this._kb.bindKey(_arg_1, _arg_2, _arg_3);
            };
        }

        public function addMenu(_arg_1:String, _arg_2:Function, _arg_3:Array=null, _arg_4:String=null):void
        {
            this.panels.mainPanel.addMenu(_arg_1, _arg_2, _arg_3, _arg_4);
        }

        public function get displayRoller():Boolean
        {
            return (this._panels.displayRoller);
        }

        public function set displayRoller(_arg_1:Boolean):void
        {
            this._panels.displayRoller = _arg_1;
        }

        public function setRollerCaptureKey(_arg_1:String, _arg_2:Boolean=false, _arg_3:Boolean=false, _arg_4:Boolean=false):void
        {
            if (this._rollerKey)
            {
                this.bindKey(this._rollerKey, null);
                this._rollerKey = null;
            };
            if (((_arg_1) && (_arg_1.length == 1)))
            {
                this._rollerKey = new KeyBind(_arg_1, _arg_2, _arg_3, _arg_4);
                this.bindKey(this._rollerKey, this.onRollerCaptureKey);
            };
        }

        public function get rollerCaptureKey():KeyBind
        {
            return (this._rollerKey);
        }

        private function onRollerCaptureKey():void
        {
            if (this.displayRoller)
            {
                this.report(("Display Roller Capture:<br/>" + RollerPanel(this._panels.getPanel(RollerPanel.NAME)).getMapString(true)), -1);
            };
        }

        public function get fpsMonitor():Boolean
        {
            return (this._graphing.fpsMonitor);
        }

        public function set fpsMonitor(_arg_1:Boolean):void
        {
            this._graphing.fpsMonitor = _arg_1;
        }

        public function get memoryMonitor():Boolean
        {
            return (this._graphing.memoryMonitor);
        }

        public function set memoryMonitor(_arg_1:Boolean):void
        {
            this._graphing.memoryMonitor = _arg_1;
        }

        public function watch(_arg_1:Object, _arg_2:String=null):String
        {
            return (this._mm.watch(_arg_1, _arg_2));
        }

        public function unwatch(_arg_1:String):void
        {
            this._mm.unwatch(_arg_1);
        }

        public function gc():void
        {
            this._mm.gc();
        }

        public function store(_arg_1:String, _arg_2:Object, _arg_3:Boolean=false):void
        {
            this._cl.store(_arg_1, _arg_2, _arg_3);
        }

        public function map(_arg_1:DisplayObjectContainer, _arg_2:uint=0):void
        {
            this._tools.map(_arg_1, _arg_2, DEFAULT_CHANNEL);
        }

        public function mapch(_arg_1:*, _arg_2:DisplayObjectContainer, _arg_3:uint=0):void
        {
            this._tools.map(_arg_2, _arg_3, MakeChannelName(_arg_1));
        }

        public function inspect(_arg_1:Object, _arg_2:Boolean=true):void
        {
            this._refs.inspect(_arg_1, _arg_2, DEFAULT_CHANNEL);
        }

        public function inspectch(_arg_1:*, _arg_2:Object, _arg_3:Boolean=true):void
        {
            this._refs.inspect(_arg_2, _arg_3, MakeChannelName(_arg_1));
        }

        public function explode(_arg_1:Object, _arg_2:int=3):void
        {
            this.addLine(new Array(this._tools.explode(_arg_1, _arg_2)), 1, null, false, true);
        }

        public function explodech(_arg_1:*, _arg_2:Object, _arg_3:int=3):void
        {
            this.addLine(new Array(this._tools.explode(_arg_2, _arg_3)), 1, _arg_1, false, true);
        }

        public function get paused():Boolean
        {
            return (this._paused);
        }

        public function set paused(_arg_1:Boolean):void
        {
            if (this._paused == _arg_1)
            {
                return;
            };
            if (_arg_1)
            {
                this.report("Paused", 10);
            }
            else
            {
                this.report("Resumed", -1);
            };
            this._paused = _arg_1;
            this._panels.mainPanel.setPaused(_arg_1);
        }

        override public function get width():Number
        {
            return (this._panels.mainPanel.width);
        }

        override public function set width(_arg_1:Number):void
        {
            this._panels.mainPanel.width = _arg_1;
        }

        override public function set height(_arg_1:Number):void
        {
            this._panels.mainPanel.height = _arg_1;
        }

        override public function get height():Number
        {
            return (this._panels.mainPanel.height);
        }

        override public function get x():Number
        {
            return (this._panels.mainPanel.x);
        }

        override public function set x(_arg_1:Number):void
        {
            this._panels.mainPanel.x = _arg_1;
        }

        override public function set y(_arg_1:Number):void
        {
            this._panels.mainPanel.y = _arg_1;
        }

        override public function get y():Number
        {
            return (this._panels.mainPanel.y);
        }

        override public function set visible(_arg_1:Boolean):void
        {
            super.visible = _arg_1;
            if (_arg_1)
            {
                this._panels.mainPanel.visible = true;
            };
        }

        private function _onEnterFrame(_arg_1:Event):void
        {
            var _local_4:Array;
            var _local_2:int = getTimer();
            var _local_3:Boolean = this._logs.update(_local_2);
            this._refs.update(_local_2);
            this._mm.update();
            if (this.remoter.remoting != Remoting.RECIEVER)
            {
                _local_4 = this._graphing.update(((stage) ? stage.frameRate : 0));
            };
            this._remoter.update();
            if (((visible) && (parent)))
            {
                if ((((this.config.alwaysOnTop) && (!(parent.getChildAt((parent.numChildren - 1)) == this))) && (this._topTries > 0)))
                {
                    this._topTries--;
                    parent.addChild(this);
                    this.report((("Moved console on top (alwaysOnTop enabled), " + this._topTries) + " attempts left."), -1);
                };
                this._panels.update(this._paused, _local_3);
                if (_local_4)
                {
                    this._panels.updateGraphs(_local_4);
                };
            };
        }

        public function get remoting():Boolean
        {
            return (this._remoter.remoting == Remoting.SENDER);
        }

        public function set remoting(_arg_1:Boolean):void
        {
            this._remoter.remoting = ((_arg_1) ? Remoting.SENDER : Remoting.NONE);
        }

        public function remotingSocket(_arg_1:String, _arg_2:int):void
        {
            this._remoter.remotingSocket(_arg_1, _arg_2);
        }

        public function setViewingChannels(... _args):void
        {
            this._panels.mainPanel.setViewingChannels.apply(this, _args);
        }

        public function setIgnoredChannels(... _args):void
        {
            this._panels.mainPanel.setIgnoredChannels.apply(this, _args);
        }

        public function set minimumPriority(_arg_1:uint):void
        {
            this._panels.mainPanel.priority = _arg_1;
        }

        public function report(_arg_1:*, _arg_2:int=0, _arg_3:Boolean=true, _arg_4:String=null):void
        {
            if (!_arg_4)
            {
                _arg_4 = this._panels.mainPanel.reportChannel;
            };
            this.addLine([_arg_1], _arg_2, _arg_4, false, _arg_3, 0);
        }

        public function addLine(_arg_1:Array, _arg_2:int=0, _arg_3:*=null, _arg_4:Boolean=false, _arg_5:Boolean=false, _arg_6:int=-1):void
        {
            var _local_7:* = "";
            var _local_8:int = _arg_1.length;
            var _local_9:int;
            while (_local_9 < _local_8)
            {
                _local_7 = (_local_7 + (((_local_9) ? " " : "") + this._refs.makeString(_arg_1[_local_9], null, _arg_5)));
                _local_9++;
            };
            if (((_arg_2 >= this._config.autoStackPriority) && (_arg_6 < 0)))
            {
                _arg_6 = this._config.defaultStackDepth;
            };
            if (((!(_arg_5)) && (_arg_6 > 0)))
            {
                _local_7 = (_local_7 + this._tools.getStack(_arg_6, _arg_2));
            };
            this._logs.add(new Log(_local_7, MakeChannelName(_arg_3), _arg_2, _arg_4, _arg_5));
        }

        public function set commandLine(_arg_1:Boolean):void
        {
            this._panels.mainPanel.commandLine = _arg_1;
        }

        public function get commandLine():Boolean
        {
            return (this._panels.mainPanel.commandLine);
        }

        public function addSlashCommand(_arg_1:String, _arg_2:Function, _arg_3:String="", _arg_4:Boolean=true, _arg_5:String=";"):void
        {
            this._cl.addSlashCommand(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function add(_arg_1:*, _arg_2:int=2, _arg_3:Boolean=false):void
        {
            this.addLine([_arg_1], _arg_2, DEFAULT_CHANNEL, _arg_3);
        }

        public function stack(_arg_1:*, _arg_2:int=-1, _arg_3:int=5):void
        {
            this.addLine([_arg_1], _arg_3, DEFAULT_CHANNEL, false, false, ((_arg_2 >= 0) ? _arg_2 : this._config.defaultStackDepth));
        }

        public function stackch(_arg_1:*, _arg_2:*, _arg_3:int=-1, _arg_4:int=5):void
        {
            this.addLine([_arg_2], _arg_4, _arg_1, false, false, ((_arg_3 >= 0) ? _arg_3 : this._config.defaultStackDepth));
        }

        public function log(... _args):void
        {
            this.addLine(_args, LOG);
        }

        public function info(... _args):void
        {
            this.addLine(_args, INFO);
        }

        public function debug(... _args):void
        {
            this.addLine(_args, DEBUG);
        }

        public function warn(... _args):void
        {
            this.addLine(_args, WARN);
        }

        public function error(... _args):void
        {
            this.addLine(_args, ERROR);
        }

        public function fatal(... _args):void
        {
            this.addLine(_args, FATAL);
        }

        public function ch(_arg_1:*, _arg_2:*, _arg_3:int=2, _arg_4:Boolean=false):void
        {
            this.addLine([_arg_2], _arg_3, _arg_1, _arg_4);
        }

        public function logch(_arg_1:*, ... _args):void
        {
            this.addLine(_args, LOG, _arg_1);
        }

        public function infoch(_arg_1:*, ... _args):void
        {
            this.addLine(_args, INFO, _arg_1);
        }

        public function debugch(_arg_1:*, ... _args):void
        {
            this.addLine(_args, DEBUG, _arg_1);
        }

        public function warnch(_arg_1:*, ... _args):void
        {
            this.addLine(_args, WARN, _arg_1);
        }

        public function errorch(_arg_1:*, ... _args):void
        {
            this.addLine(_args, ERROR, _arg_1);
        }

        public function fatalch(_arg_1:*, ... _args):void
        {
            this.addLine(_args, FATAL, _arg_1);
        }

        public function addCh(_arg_1:*, _arg_2:Array, _arg_3:int=2, _arg_4:Boolean=false):void
        {
            this.addLine(_arg_2, _arg_3, _arg_1, _arg_4);
        }

        public function addHTML(... _args):void
        {
            this.addLine(_args, 2, DEFAULT_CHANNEL, false, this.testHTML(_args));
        }

        public function addHTMLch(_arg_1:*, _arg_2:int, ... _args):void
        {
            this.addLine(_args, _arg_2, _arg_1, false, this.testHTML(_args));
        }

        private function testHTML(args:Array):Boolean
        {
            try
            {
                new XML((("<p>" + args.join("")) + "</p>"));
            }
            catch(err:Error)
            {
                return (false);
            };
            return (true);
        }

        public function clear(_arg_1:String=null):void
        {
            this._logs.clear(_arg_1);
            if (!this._paused)
            {
                this._panels.mainPanel.updateToBottom();
            };
            this._panels.updateMenu();
        }

        public function getAllLog(_arg_1:String="\r\n"):String
        {
            return (this._logs.getLogsAsString(_arg_1));
        }

        public function get config():ConsoleConfig
        {
            return (this._config);
        }

        public function get panels():PanelsManager
        {
            return (this._panels);
        }

        public function get cl():CommandLine
        {
            return (this._cl);
        }

        public function get remoter():Remoting
        {
            return (this._remoter);
        }

        public function get graphing():Graphing
        {
            return (this._graphing);
        }

        public function get refs():LogReferences
        {
            return (this._refs);
        }

        public function get logs():Logs
        {
            return (this._logs);
        }

        public function get mapper():ConsoleTools
        {
            return (this._tools);
        }

        public function get so():Object
        {
            return (this._soData);
        }

        public function updateSO(_arg_1:String=null):void
        {
            if (this._so)
            {
                if (_arg_1)
                {
                    this._so.setDirty(_arg_1);
                }
                else
                {
                    this._so.clear();
                };
            };
        }


    }
}//package com.junkbyte.console

