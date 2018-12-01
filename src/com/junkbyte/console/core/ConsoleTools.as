// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.junkbyte.console.core.ConsoleTools

package com.junkbyte.console.core
{
    import com.junkbyte.console.Console;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.utils.ByteArray;
    import flash.utils.describeType;
    import flash.utils.getQualifiedClassName;
    import com.junkbyte.console.Cc;

    public class ConsoleTools extends ConsoleCore 
    {

        public function ConsoleTools(_arg_1:Console)
        {
            super(_arg_1);
        }

        public function map(_arg_1:DisplayObjectContainer, _arg_2:uint=0, _arg_3:String=null):void
        {
            var _local_5:Boolean;
            var _local_9:DisplayObject;
            var _local_10:String;
            var _local_11:DisplayObjectContainer;
            var _local_12:int;
            var _local_13:int;
            var _local_14:DisplayObject;
            var _local_15:uint;
            var _local_16:String;
            if (!_arg_1)
            {
                report("Not a DisplayObjectContainer.", 10, true, _arg_3);
                return;
            };
            var _local_4:int;
            var _local_6:int;
            var _local_7:DisplayObject;
            var _local_8:Array = new Array();
            _local_8.push(_arg_1);
            while (_local_6 < _local_8.length)
            {
                _local_9 = _local_8[_local_6];
                _local_6++;
                if ((_local_9 is DisplayObjectContainer))
                {
                    _local_11 = (_local_9 as DisplayObjectContainer);
                    _local_12 = _local_11.numChildren;
                    _local_13 = 0;
                    while (_local_13 < _local_12)
                    {
                        _local_14 = _local_11.getChildAt(_local_13);
                        _local_8.splice((_local_6 + _local_13), 0, _local_14);
                        _local_13++;
                    };
                };
                if (_local_7)
                {
                    if (((_local_7 is DisplayObjectContainer) && ((_local_7 as DisplayObjectContainer).contains(_local_9))))
                    {
                        _local_4++;
                    }
                    else
                    {
                        while (_local_7)
                        {
                            _local_7 = _local_7.parent;
                            if ((_local_7 is DisplayObjectContainer))
                            {
                                if (_local_4 > 0)
                                {
                                    _local_4--;
                                };
                                if ((_local_7 as DisplayObjectContainer).contains(_local_9))
                                {
                                    _local_4++;
                                    break;
                                };
                            };
                        };
                    };
                };
                _local_10 = "";
                _local_13 = 0;
                while (_local_13 < _local_4)
                {
                    _local_10 = (_local_10 + ((_local_13 == (_local_4 - 1)) ? " ∟ " : " - "));
                    _local_13++;
                };
                if (((_arg_2 <= 0) || (_local_4 <= _arg_2)))
                {
                    _local_5 = false;
                    _local_15 = console.refs.setLogRef(_local_9);
                    _local_16 = _local_9.name;
                    if (_local_15)
                    {
                        _local_16 = (((("<a href='event:cl_" + _local_15) + "'>") + _local_16) + "</a>");
                    };
                    if ((_local_9 is DisplayObjectContainer))
                    {
                        _local_16 = (("<b>" + _local_16) + "</b>");
                    }
                    else
                    {
                        _local_16 = (("<i>" + _local_16) + "</i>");
                    };
                    _local_10 = (_local_10 + ((_local_16 + " ") + console.refs.makeRefTyped(_local_9)));
                    report(_local_10, ((_local_9 is DisplayObjectContainer) ? 5 : 2), true, _arg_3);
                }
                else
                {
                    if (!_local_5)
                    {
                        _local_5 = true;
                        report((_local_10 + "..."), 5, true, _arg_3);
                    };
                };
                _local_7 = _local_9;
            };
            report((((((_arg_1.name + ":") + console.refs.makeRefTyped(_arg_1)) + " has ") + (_local_8.length - 1)) + " children/sub-children."), 9, true, _arg_3);
            if (config.commandLineAllowed)
            {
                report("Click on the child display's name to set scope.", -2, true, _arg_3);
            };
        }

        public function explode(_arg_1:Object, _arg_2:int=3, _arg_3:int=9):String
        {
            var _local_6:XMLList;
            var _local_7:String;
            var _local_9:XML;
            var _local_10:XML;
            var _local_11:String;
            var _local_4:* = typeof(_arg_1);
            if (_arg_1 == null)
            {
                return (("<p-2>" + _arg_1) + "</p-2>");
            };
            if ((_arg_1 is String))
            {
                return (('"' + LogReferences.EscHTML((_arg_1 as String))) + '"');
            };
            if ((((!(_local_4 == "object")) || (_arg_2 == 0)) || (_arg_1 is ByteArray)))
            {
                return (console.refs.makeString(_arg_1));
            };
            if (_arg_3 < 0)
            {
                _arg_3 = 0;
            };
            var _local_5:XML = describeType(_arg_1);
            var _local_8:Array = [];
            _local_6 = _local_5["accessor"];
            for each (_local_9 in _local_6)
            {
                _local_7 = _local_9.@name;
                if (_local_9.@access != "writeonly")
                {
                    try
                    {
                        _local_8.push(this.stepExp(_arg_1, _local_7, _arg_2, _arg_3));
                    }
                    catch(e:Error)
                    {
                    };
                }
                else
                {
                    _local_8.push(_local_7);
                };
            };
            _local_6 = _local_5["variable"];
            for each (_local_10 in _local_6)
            {
                _local_7 = _local_10.@name;
                _local_8.push(this.stepExp(_arg_1, _local_7, _arg_2, _arg_3));
            };
            try
            {
                for (_local_11 in _arg_1)
                {
                    _local_8.push(this.stepExp(_arg_1, _local_11, _arg_2, _arg_3));
                };
            }
            catch(e:Error)
            {
            };
            return (((((((((((("<p" + _arg_3) + ">{") + LogReferences.ShortClassName(_arg_1)) + "</p") + _arg_3) + "> ") + _local_8.join(", ")) + "<p") + _arg_3) + ">}</p") + _arg_3) + ">");
        }

        private function stepExp(_arg_1:*, _arg_2:String, _arg_3:int, _arg_4:int):String
        {
            return ((_arg_2 + ":") + this.explode(_arg_1[_arg_2], (_arg_3 - 1), (_arg_4 - 1)));
        }

        public function getStack(_arg_1:int, _arg_2:int):String
        {
            var _local_3:Error = new Error();
            var _local_4:String = ((_local_3.hasOwnProperty("getStackTrace")) ? _local_3.getStackTrace() : null);
            if (!_local_4)
            {
                return ("");
            };
            var _local_5:* = "";
            var _local_6:Array = _local_4.split(/\n\sat\s/);
            var _local_7:int = _local_6.length;
            var _local_8:RegExp = new RegExp(((("Function|" + getQualifiedClassName(Console)) + "|") + getQualifiedClassName(Cc)));
            var _local_9:Boolean;
            var _local_10:int = 2;
            while (_local_10 < _local_7)
            {
                if (((!(_local_9)) && (!(_local_6[_local_10].search(_local_8) == 0))))
                {
                    _local_9 = true;
                };
                if (_local_9)
                {
                    _local_5 = (_local_5 + (((((("\n<p" + _arg_2) + "> @ ") + _local_6[_local_10]) + "</p") + _arg_2) + ">"));
                    if (_arg_2 > 0)
                    {
                        _arg_2--;
                    };
                    _arg_1--;
                    if (_arg_1 <= 0) break;
                };
                _local_10++;
            };
            return (_local_5);
        }


    }
}//package com.junkbyte.console.core

