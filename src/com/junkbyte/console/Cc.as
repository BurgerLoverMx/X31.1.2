// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.junkbyte.console.Cc

package com.junkbyte.console
{
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    import flash.display.DisplayObject;
    import flash.display.LoaderInfo;
    import flash.geom.Rectangle;

    public class Cc 
    {

        private static var _console:Console;
        private static var _config:ConsoleConfig;


        public static function get config():ConsoleConfig
        {
            if (!_config)
            {
                _config = new ConsoleConfig();
            };
            return (_config);
        }

        public static function start(_arg_1:DisplayObjectContainer, _arg_2:String=""):void
        {
            if (_console)
            {
                if (((_arg_1) && (!(_console.parent))))
                {
                    _arg_1.addChild(_console);
                };
            }
            else
            {
                _console = new Console(_arg_2, config);
                if (_arg_1)
                {
                    _arg_1.addChild(_console);
                };
            };
        }

        public static function startOnStage(_arg_1:DisplayObject, _arg_2:String=""):void
        {
            if (_console)
            {
                if ((((_arg_1) && (_arg_1.stage)) && (!(_console.parent == _arg_1.stage))))
                {
                    _arg_1.stage.addChild(_console);
                };
            }
            else
            {
                if (((_arg_1) && (_arg_1.stage)))
                {
                    start(_arg_1.stage, _arg_2);
                }
                else
                {
                    _console = new Console(_arg_2, config);
                    if (_arg_1)
                    {
                        _arg_1.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandle);
                    };
                };
            };
        }

        public static function add(_arg_1:*, _arg_2:int=2, _arg_3:Boolean=false):void
        {
            if (_console)
            {
                _console.add(_arg_1, _arg_2, _arg_3);
            };
        }

        public static function ch(_arg_1:*, _arg_2:*, _arg_3:int=2, _arg_4:Boolean=false):void
        {
            if (_console)
            {
                _console.ch(_arg_1, _arg_2, _arg_3, _arg_4);
            };
        }

        public static function log(... _args):void
        {
            if (_console)
            {
                _console.log.apply(null, _args);
            };
        }

        public static function info(... _args):void
        {
            if (_console)
            {
                _console.info.apply(null, _args);
            };
        }

        public static function debug(... _args):void
        {
            if (_console)
            {
                _console.debug.apply(null, _args);
            };
        }

        public static function warn(... _args):void
        {
            if (_console)
            {
                _console.warn.apply(null, _args);
            };
        }

        public static function error(... _args):void
        {
            if (_console)
            {
                _console.error.apply(null, _args);
            };
        }

        public static function fatal(... _args):void
        {
            if (_console)
            {
                _console.fatal.apply(null, _args);
            };
        }

        public static function logch(_arg_1:*, ... _args):void
        {
            if (_console)
            {
                _console.addCh(_arg_1, _args, Console.LOG);
            };
        }

        public static function infoch(_arg_1:*, ... _args):void
        {
            if (_console)
            {
                _console.addCh(_arg_1, _args, Console.INFO);
            };
        }

        public static function debugch(_arg_1:*, ... _args):void
        {
            if (_console)
            {
                _console.addCh(_arg_1, _args, Console.DEBUG);
            };
        }

        public static function warnch(_arg_1:*, ... _args):void
        {
            if (_console)
            {
                _console.addCh(_arg_1, _args, Console.WARN);
            };
        }

        public static function errorch(_arg_1:*, ... _args):void
        {
            if (_console)
            {
                _console.addCh(_arg_1, _args, Console.ERROR);
            };
        }

        public static function fatalch(_arg_1:*, ... _args):void
        {
            if (_console)
            {
                _console.addCh(_arg_1, _args, Console.FATAL);
            };
        }

        public static function stack(_arg_1:*, _arg_2:int=-1, _arg_3:int=5):void
        {
            if (_console)
            {
                _console.stack(_arg_1, _arg_2, _arg_3);
            };
        }

        public static function stackch(_arg_1:*, _arg_2:*, _arg_3:int=-1, _arg_4:int=5):void
        {
            if (_console)
            {
                _console.stackch(_arg_1, _arg_2, _arg_3, _arg_4);
            };
        }

        public static function inspect(_arg_1:Object, _arg_2:Boolean=true):void
        {
            if (_console)
            {
                _console.inspect(_arg_1, _arg_2);
            };
        }

        public static function inspectch(_arg_1:*, _arg_2:Object, _arg_3:Boolean=true):void
        {
            if (_console)
            {
                _console.inspectch(_arg_1, _arg_2, _arg_3);
            };
        }

        public static function explode(_arg_1:Object, _arg_2:int=3):void
        {
            if (_console)
            {
                _console.explode(_arg_1, _arg_2);
            };
        }

        public static function explodech(_arg_1:*, _arg_2:Object, _arg_3:int=3):void
        {
            if (_console)
            {
                _console.explodech(_arg_1, _arg_2, _arg_3);
            };
        }

        public static function addHTML(... _args):void
        {
            if (_console)
            {
                _console.addHTML.apply(null, _args);
            };
        }

        public static function addHTMLch(_arg_1:*, _arg_2:int, ... _args):void
        {
            if (_console)
            {
                _console.addHTMLch.apply(null, new Array(_arg_1, _arg_2).concat(_args));
            };
        }

        public static function map(_arg_1:DisplayObjectContainer, _arg_2:uint=0):void
        {
            if (_console)
            {
                _console.map(_arg_1, _arg_2);
            };
        }

        public static function mapch(_arg_1:*, _arg_2:DisplayObjectContainer, _arg_3:uint=0):void
        {
            if (_console)
            {
                _console.mapch(_arg_1, _arg_2, _arg_3);
            };
        }

        public static function clear(_arg_1:String=null):void
        {
            if (_console)
            {
                _console.clear(_arg_1);
            };
        }

        public static function bindKey(_arg_1:KeyBind, _arg_2:Function=null, _arg_3:Array=null):void
        {
            if (_console)
            {
                _console.bindKey(_arg_1, _arg_2, _arg_3);
            };
        }

        public static function addMenu(_arg_1:String, _arg_2:Function, _arg_3:Array=null, _arg_4:String=null):void
        {
            if (_console)
            {
                _console.addMenu(_arg_1, _arg_2, _arg_3, _arg_4);
            };
        }

        public static function listenUncaughtErrors(_arg_1:LoaderInfo):void
        {
            if (_console)
            {
                _console.listenUncaughtErrors(_arg_1);
            };
        }

        public static function store(_arg_1:String, _arg_2:Object, _arg_3:Boolean=false):void
        {
            if (_console)
            {
                _console.store(_arg_1, _arg_2, _arg_3);
            };
        }

        public static function addSlashCommand(_arg_1:String, _arg_2:Function, _arg_3:String="", _arg_4:Boolean=true, _arg_5:String=";"):void
        {
            if (_console)
            {
                _console.addSlashCommand(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
            };
        }

        public static function watch(_arg_1:Object, _arg_2:String=null):String
        {
            if (_console)
            {
                return (_console.watch(_arg_1, _arg_2));
            };
            return (null);
        }

        public static function unwatch(_arg_1:String):void
        {
            if (_console)
            {
                _console.unwatch(_arg_1);
            };
        }

        public static function addGraph(_arg_1:String, _arg_2:Object, _arg_3:String, _arg_4:Number=-1, _arg_5:String=null, _arg_6:Rectangle=null, _arg_7:Boolean=false):void
        {
            if (_console)
            {
                _console.addGraph(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
            };
        }

        public static function fixGraphRange(_arg_1:String, _arg_2:Number=NaN, _arg_3:Number=NaN):void
        {
            if (_console)
            {
                _console.fixGraphRange(_arg_1, _arg_2, _arg_3);
            };
        }

        public static function removeGraph(_arg_1:String, _arg_2:Object=null, _arg_3:String=null):void
        {
            if (_console)
            {
                _console.removeGraph(_arg_1, _arg_2, _arg_3);
            };
        }

        public static function setViewingChannels(... _args):void
        {
            if (_console)
            {
                _console.setViewingChannels.apply(null, _args);
            };
        }

        public static function setIgnoredChannels(... _args):void
        {
            if (_console)
            {
                _console.setIgnoredChannels.apply(null, _args);
            };
        }

        public static function set minimumPriority(_arg_1:uint):void
        {
            if (_console)
            {
                _console.minimumPriority = _arg_1;
            };
        }

        public static function get width():Number
        {
            if (_console)
            {
                return (_console.width);
            };
            return (0);
        }

        public static function set width(_arg_1:Number):void
        {
            if (_console)
            {
                _console.width = _arg_1;
            };
        }

        public static function get height():Number
        {
            if (_console)
            {
                return (_console.height);
            };
            return (0);
        }

        public static function set height(_arg_1:Number):void
        {
            if (_console)
            {
                _console.height = _arg_1;
            };
        }

        public static function get x():Number
        {
            if (_console)
            {
                return (_console.x);
            };
            return (0);
        }

        public static function set x(_arg_1:Number):void
        {
            if (_console)
            {
                _console.x = _arg_1;
            };
        }

        public static function get y():Number
        {
            if (_console)
            {
                return (_console.y);
            };
            return (0);
        }

        public static function set y(_arg_1:Number):void
        {
            if (_console)
            {
                _console.y = _arg_1;
            };
        }

        public static function get visible():Boolean
        {
            if (_console)
            {
                return (_console.visible);
            };
            return (false);
        }

        public static function set visible(_arg_1:Boolean):void
        {
            if (_console)
            {
                _console.visible = _arg_1;
            };
        }

        public static function get fpsMonitor():Boolean
        {
            if (_console)
            {
                return (_console.fpsMonitor);
            };
            return (false);
        }

        public static function set fpsMonitor(_arg_1:Boolean):void
        {
            if (_console)
            {
                _console.fpsMonitor = _arg_1;
            };
        }

        public static function get memoryMonitor():Boolean
        {
            if (_console)
            {
                return (_console.memoryMonitor);
            };
            return (false);
        }

        public static function set memoryMonitor(_arg_1:Boolean):void
        {
            if (_console)
            {
                _console.memoryMonitor = _arg_1;
            };
        }

        public static function get commandLine():Boolean
        {
            if (_console)
            {
                return (_console.commandLine);
            };
            return (false);
        }

        public static function set commandLine(_arg_1:Boolean):void
        {
            if (_console)
            {
                _console.commandLine = _arg_1;
            };
        }

        public static function get displayRoller():Boolean
        {
            if (_console)
            {
                return (_console.displayRoller);
            };
            return (false);
        }

        public static function set displayRoller(_arg_1:Boolean):void
        {
            if (_console)
            {
                _console.displayRoller = _arg_1;
            };
        }

        public static function setRollerCaptureKey(_arg_1:String, _arg_2:Boolean=false, _arg_3:Boolean=false, _arg_4:Boolean=false):void
        {
            if (_console)
            {
                _console.setRollerCaptureKey(_arg_1, _arg_4, _arg_2, _arg_3);
            };
        }

        public static function get remoting():Boolean
        {
            if (_console)
            {
                return (_console.remoting);
            };
            return (false);
        }

        public static function set remoting(_arg_1:Boolean):void
        {
            if (_console)
            {
                _console.remoting = _arg_1;
            };
        }

        public static function remotingSocket(_arg_1:String, _arg_2:int):void
        {
            if (_console)
            {
                _console.remotingSocket(_arg_1, _arg_2);
            };
        }

        public static function remove():void
        {
            if (_console)
            {
                if (_console.parent)
                {
                    _console.parent.removeChild(_console);
                };
                _console = null;
            };
        }

        public static function getAllLog(_arg_1:String="\r\n"):String
        {
            if (_console)
            {
                return (_console.getAllLog(_arg_1));
            };
            return ("");
        }

        public static function get instance():Console
        {
            return (_console);
        }

        private static function addedToStageHandle(_arg_1:Event):void
        {
            var _local_2:DisplayObjectContainer = (_arg_1.currentTarget as DisplayObjectContainer);
            _local_2.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandle);
            if (((_console) && (_console.parent == null)))
            {
                _local_2.stage.addChild(_console);
            };
        }


    }
}//package com.junkbyte.console

