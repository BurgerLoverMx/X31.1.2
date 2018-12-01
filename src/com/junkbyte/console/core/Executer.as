// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.junkbyte.console.core.Executer

package com.junkbyte.console.core
{
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import flash.utils.getDefinitionByName;
    import com.junkbyte.console.vos.WeakObject;

    public class Executer extends EventDispatcher 
    {

        public static const RETURNED:String = "returned";
        public static const CLASSES:String = "ExeValue|((com.junkbyte.console.core::)?Executer)";
        private static const VALKEY:String = "#";

        private var _values:Array;
        private var _running:Boolean;
        private var _scope:*;
        private var _returned:*;
        private var _saved:Object;
        private var _reserved:Array;
        public var autoScope:Boolean;


        public static function Exec(_arg_1:Object, _arg_2:String, _arg_3:Object=null):*
        {
            var _local_4:Executer = new (Executer)();
            _local_4.setStored(_arg_3);
            return (_local_4.exec(_arg_1, _arg_2));
        }


        public function get returned():*
        {
            return (this._returned);
        }

        public function get scope():*
        {
            return (this._scope);
        }

        public function setStored(_arg_1:Object):void
        {
            this._saved = _arg_1;
        }

        public function setReserved(_arg_1:Array):void
        {
            this._reserved = _arg_1;
        }

        public function exec(s:*, str:String):*
        {
            if (this._running)
            {
                throw (new Error("CommandExec.exec() is already runnnig. Does not support loop backs."));
            };
            this._running = true;
            this._scope = s;
            this._values = [];
            if (!this._saved)
            {
                this._saved = new Object();
            };
            if (!this._reserved)
            {
                this._reserved = new Array();
            };
            try
            {
                this._exec(str);
            }
            catch(e:Error)
            {
                reset();
                throw (e);
            };
            this.reset();
            return (this._returned);
        }

        private function reset():void
        {
            this._saved = null;
            this._reserved = null;
            this._values = null;
            this._running = false;
        }

        private function _exec(_arg_1:String):void
        {
            var _local_5:String;
            var _local_6:String;
            var _local_7:String;
            var _local_8:int;
            var _local_9:int;
            var _local_10:String;
            var _local_11:*;
            var _local_2:RegExp = /''|""|('(.*?)[^\\]')|("(.*?)[^\\]")/;
            var _local_3:Object = _local_2.exec(_arg_1);
            while (_local_3 != null)
            {
                _local_6 = _local_3[0];
                _local_7 = _local_6.charAt(0);
                _local_8 = _local_6.indexOf(_local_7);
                _local_9 = _local_6.lastIndexOf(_local_7);
                _local_10 = _local_6.substring((_local_8 + 1), _local_9).replace(/\\(.)/g, "$1");
                _arg_1 = this.tempValue(_arg_1, new ExeValue(_local_10), (_local_3.index + _local_8), ((_local_3.index + _local_9) + 1));
                _local_3 = _local_2.exec(_arg_1);
            };
            if (_arg_1.search(new RegExp("'|\"")) >= 0)
            {
                throw (new Error("Bad syntax extra quotation marks"));
            };
            var _local_4:Array = _arg_1.split(/\s*;\s*/);
            for each (_local_5 in _local_4)
            {
                if (_local_5.length)
                {
                    _local_11 = this._saved[RETURNED];
                    if (((_local_11) && (_local_5 == "/")))
                    {
                        this._scope = _local_11;
                        dispatchEvent(new Event(Event.COMPLETE));
                    }
                    else
                    {
                        this.execNest(_local_5);
                    };
                };
            };
        }

        private function execNest(_arg_1:String):*
        {
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:String;
            var _local_7:Boolean;
            var _local_8:int;
            var _local_9:String;
            var _local_10:Array;
            var _local_11:String;
            var _local_12:ExeValue;
            var _local_13:String;
            _arg_1 = this.ignoreWhite(_arg_1);
            var _local_2:int = _arg_1.lastIndexOf("(");
            while (_local_2 >= 0)
            {
                _local_3 = _arg_1.indexOf(")", _local_2);
                if (_arg_1.substring((_local_2 + 1), _local_3).search(/\w/) >= 0)
                {
                    _local_4 = _local_2;
                    _local_5 = (_local_2 + 1);
                    while (((_local_4 >= 0) && (_local_4 < _local_5)))
                    {
                        _local_4 = _arg_1.indexOf("(", ++_local_4);
                        _local_5 = _arg_1.indexOf(")", (_local_5 + 1));
                    };
                    _local_6 = _arg_1.substring((_local_2 + 1), _local_5);
                    _local_7 = false;
                    _local_8 = (_local_2 - 1);
                    while (true)
                    {
                        _local_9 = _arg_1.charAt(_local_8);
                        if (((_local_9.match(/[^\s]/)) || (_local_8 <= 0)))
                        {
                            if (_local_9.match(/\w/))
                            {
                                _local_7 = true;
                            };
                            break;
                        };
                        _local_8--;
                    };
                    if (_local_7)
                    {
                        _local_10 = _local_6.split(",");
                        _arg_1 = this.tempValue(_arg_1, new ExeValue(_local_10), (_local_2 + 1), _local_5);
                        for (_local_11 in _local_10)
                        {
                            _local_10[_local_11] = this.execOperations(this.ignoreWhite(_local_10[_local_11])).value;
                        };
                    }
                    else
                    {
                        _local_12 = new ExeValue(_local_12);
                        _arg_1 = this.tempValue(_arg_1, _local_12, _local_2, (_local_5 + 1));
                        _local_12.setValue(this.execOperations(this.ignoreWhite(_local_6)).value);
                    };
                };
                _local_2 = _arg_1.lastIndexOf("(", (_local_2 - 1));
            };
            this._returned = this.execOperations(_arg_1).value;
            if (((this._returned) && (this.autoScope)))
            {
                _local_13 = typeof(this._returned);
                if (((_local_13 == "object") || (_local_13 == "xml")))
                {
                    this._scope = this._returned;
                };
            };
            dispatchEvent(new Event(Event.COMPLETE));
            return (this._returned);
        }

        private function tempValue(_arg_1:String, _arg_2:*, _arg_3:int, _arg_4:int):String
        {
            _arg_1 = (((_arg_1.substring(0, _arg_3) + VALKEY) + this._values.length) + _arg_1.substring(_arg_4));
            this._values.push(_arg_2);
            return (_arg_1);
        }

        private function execOperations(_arg_1:String):ExeValue
        {
            var _local_7:String;
            var _local_8:*;
            var _local_11:int;
            var _local_12:int;
            var _local_13:String;
            var _local_14:ExeValue;
            var _local_15:ExeValue;
            var _local_2:RegExp = /\s*(((\|\||\&\&|[+|\-|*|\/|\%|\||\&|\^]|\=\=?|\!\=|\>\>?\>?|\<\<?)\=?)|=|\~|\sis\s|typeof|delete\s)\s*/g;
            var _local_3:Object = _local_2.exec(_arg_1);
            var _local_4:Array = [];
            if (_local_3 == null)
            {
                _local_4.push(_arg_1);
            }
            else
            {
                _local_11 = 0;
                while (_local_3 != null)
                {
                    _local_12 = _local_3.index;
                    _local_13 = _local_3[0];
                    _local_3 = _local_2.exec(_arg_1);
                    if (_local_3 == null)
                    {
                        _local_4.push(_arg_1.substring(_local_11, _local_12));
                        _local_4.push(this.ignoreWhite(_local_13));
                        _local_4.push(_arg_1.substring((_local_12 + _local_13.length)));
                    }
                    else
                    {
                        _local_4.push(_arg_1.substring(_local_11, _local_12));
                        _local_4.push(this.ignoreWhite(_local_13));
                        _local_11 = (_local_12 + _local_13.length);
                    };
                };
            };
            var _local_5:int = _local_4.length;
            var _local_6:int;
            while (_local_6 < _local_5)
            {
                _local_4[_local_6] = this.execSimple(_local_4[_local_6]);
                _local_6 = (_local_6 + 2);
            };
            var _local_9:RegExp = /((\|\||\&\&|[+|\-|*|\/|\%|\||\&|\^]|\>\>\>?|\<\<)\=)|=/;
            _local_6 = 1;
            while (_local_6 < _local_5)
            {
                _local_7 = _local_4[_local_6];
                if (_local_7.replace(_local_9, "") != "")
                {
                    _local_8 = this.operate(_local_4[(_local_6 - 1)], _local_7, _local_4[(_local_6 + 1)]);
                    _local_14 = ExeValue(_local_4[(_local_6 - 1)]);
                    _local_14.setValue(_local_8);
                    _local_4.splice(_local_6, 2);
                    _local_6 = (_local_6 - 2);
                    _local_5 = (_local_5 - 2);
                };
                _local_6 = (_local_6 + 2);
            };
            _local_4.reverse();
            var _local_10:ExeValue = _local_4[0];
            _local_6 = 1;
            while (_local_6 < _local_5)
            {
                _local_7 = _local_4[_local_6];
                if (_local_7.replace(_local_9, "") == "")
                {
                    _local_10 = _local_4[(_local_6 - 1)];
                    _local_15 = _local_4[(_local_6 + 1)];
                    if (_local_7.length > 1)
                    {
                        _local_7 = _local_7.substring(0, (_local_7.length - 1));
                    };
                    _local_8 = this.operate(_local_15, _local_7, _local_10);
                    _local_15.setValue(_local_8);
                };
                _local_6 = (_local_6 + 2);
            };
            return (_local_10);
        }

        private function execSimple(str:String):ExeValue
        {
            var firstparts:Array;
            var newstr:String;
            var defclose:int;
            var newobj:* = undefined;
            var classstr:String;
            var def:* = undefined;
            var havemore:Boolean;
            var index:int;
            var isFun:Boolean;
            var basestr:String;
            var newv:ExeValue;
            var newbase:* = undefined;
            var closeindex:int;
            var paramstr:String;
            var params:Array;
            var nss:Array;
            var ns:Namespace;
            var nsv:* = undefined;
            var v:ExeValue = new ExeValue(this._scope);
            if (str.indexOf("new ") == 0)
            {
                newstr = str;
                defclose = str.indexOf(")");
                if (defclose >= 0)
                {
                    newstr = str.substring(0, (defclose + 1));
                };
                newobj = this.makeNew(newstr.substring(4));
                str = this.tempValue(str, new ExeValue(newobj), 0, newstr.length);
            };
            var reg:RegExp = /\.|\(/g;
            var result:Object = reg.exec(str);
            if (((result == null) || (!(isNaN(Number(str))))))
            {
                return (this.execValue(str, this._scope));
            };
            firstparts = String(str.split("(")[0]).split(".");
            if (firstparts.length > 0)
            {
                while (firstparts.length)
                {
                    classstr = firstparts.join(".");
                    try
                    {
                        def = getDefinitionByName(this.ignoreWhite(classstr));
                        havemore = (str.length > classstr.length);
                        str = this.tempValue(str, new ExeValue(def), 0, classstr.length);
                        if (havemore)
                        {
                            reg.lastIndex = 0;
                            result = reg.exec(str);
                        }
                        else
                        {
                            return (this.execValue(str));
                        };
                        break;
                    }
                    catch(e:Error)
                    {
                        firstparts.pop();
                    };
                };
            };
            var previndex:int;
            while (result != null)
            {
                index = result.index;
                isFun = (str.charAt(index) == "(");
                basestr = this.ignoreWhite(str.substring(previndex, index));
                newv = ((previndex == 0) ? this.execValue(basestr, v.value) : new ExeValue(v.value, basestr));
                if (isFun)
                {
                    newbase = newv.value;
                    closeindex = str.indexOf(")", index);
                    paramstr = str.substring((index + 1), closeindex);
                    paramstr = this.ignoreWhite(paramstr);
                    params = [];
                    if (paramstr)
                    {
                        params = this.execValue(paramstr).value;
                    };
                    if (!(newbase is Function))
                    {
                        try
                        {
                            nss = [AS3];
                            for each (ns in nss)
                            {
                                nsv = v.obj.ns::[basestr];
                                if ((nsv is Function))
                                {
                                    newbase = nsv;
                                    break;
                                };
                            };
                        }
                        catch(e:Error)
                        {
                        };
                        if (!(newbase is Function))
                        {
                            throw (new Error((basestr + " is not a function.")));
                        };
                    };
                    v.obj = (newbase as Function).apply(v.value, params);
                    v.prop = null;
                    index = (closeindex + 1);
                }
                else
                {
                    v = newv;
                };
                previndex = (index + 1);
                reg.lastIndex = (index + 1);
                result = reg.exec(str);
                if (result == null)
                {
                    if ((index + 1) < str.length)
                    {
                        reg.lastIndex = str.length;
                        result = {"index":str.length};
                    };
                };
            };
            return (v);
        }

        private function execValue(str:String, base:*=null):ExeValue
        {
            var v:ExeValue;
            var vv:ExeValue;
            var key:String;
            v = new ExeValue();
            if (str == "true")
            {
                v.obj = true;
            }
            else
            {
                if (str == "false")
                {
                    v.obj = false;
                }
                else
                {
                    if (str == "this")
                    {
                        v.obj = this._scope;
                    }
                    else
                    {
                        if (str == "null")
                        {
                            v.obj = null;
                        }
                        else
                        {
                            if (!isNaN(Number(str)))
                            {
                                v.obj = Number(str);
                            }
                            else
                            {
                                if (str.indexOf(VALKEY) == 0)
                                {
                                    vv = this._values[str.substring(VALKEY.length)];
                                    v.obj = vv.value;
                                }
                                else
                                {
                                    if (str.charAt(0) == "$")
                                    {
                                        key = str.substring(1);
                                        if (this._reserved.indexOf(key) < 0)
                                        {
                                            v.obj = this._saved;
                                            v.prop = key;
                                        }
                                        else
                                        {
                                            if ((this._saved is WeakObject))
                                            {
                                                v.obj = WeakObject(this._saved).get(key);
                                            }
                                            else
                                            {
                                                v.obj = this._saved[key];
                                            };
                                        };
                                    }
                                    else
                                    {
                                        try
                                        {
                                            v.obj = getDefinitionByName(str);
                                        }
                                        catch(e:Error)
                                        {
                                            v.obj = base;
                                            v.prop = str;
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
            return (v);
        }

        private function operate(_arg_1:ExeValue, _arg_2:String, _arg_3:ExeValue):*
        {
            switch (_arg_2)
            {
                case "=":
                    return (_arg_3.value);
                case "+":
                    return (_arg_1.value + _arg_3.value);
                case "-":
                    return (_arg_1.value - _arg_3.value);
                case "*":
                    return (_arg_1.value * _arg_3.value);
                case "/":
                    return (_arg_1.value / _arg_3.value);
                case "%":
                    return (_arg_1.value % _arg_3.value);
                case "^":
                    return (_arg_1.value ^ _arg_3.value);
                case "&":
                    return (_arg_1.value & _arg_3.value);
                case ">>":
                    return (_arg_1.value >> _arg_3.value);
                case ">>>":
                    return (_arg_1.value >>> _arg_3.value);
                case "<<":
                    return (_arg_1.value << _arg_3.value);
                case "~":
                    return (~(_arg_3.value));
                case "|":
                    return (_arg_1.value | _arg_3.value);
                case "!":
                    return (!(_arg_3.value));
                case ">":
                    return (_arg_1.value > _arg_3.value);
                case ">=":
                    return (_arg_1.value >= _arg_3.value);
                case "<":
                    return (_arg_1.value < _arg_3.value);
                case "<=":
                    return (_arg_1.value <= _arg_3.value);
                case "||":
                    return ((_arg_1.value) || (_arg_3.value));
                case "&&":
                    return ((_arg_1.value) && (_arg_3.value));
                case "is":
                    return (_arg_1.value is _arg_3.value);
                case "typeof":
                    return (typeof(_arg_3.value));
                case "delete":
                    return (delete _arg_3.obj[_arg_3.prop]);
                case "==":
                    return (_arg_1.value == _arg_3.value);
                case "===":
                    return (_arg_1.value === _arg_3.value);
                case "!=":
                    return (!(_arg_1.value == _arg_3.value));
                case "!==":
                    return (!(_arg_1.value === _arg_3.value));
            };
        }

        private function makeNew(_arg_1:String):*
        {
            var _local_5:int;
            var _local_6:String;
            var _local_7:Array;
            var _local_8:int;
            var _local_2:int = _arg_1.indexOf("(");
            var _local_3:String = ((_local_2 > 0) ? _arg_1.substring(0, _local_2) : _arg_1);
            _local_3 = this.ignoreWhite(_local_3);
            var _local_4:* = this.execValue(_local_3).value;
            if (_local_2 > 0)
            {
                _local_5 = _arg_1.indexOf(")", _local_2);
                _local_6 = _arg_1.substring((_local_2 + 1), _local_5);
                _local_6 = this.ignoreWhite(_local_6);
                _local_7 = [];
                if (_local_6)
                {
                    _local_7 = this.execValue(_local_6).value;
                };
                _local_8 = _local_7.length;
                if (_local_8 == 0)
                {
                    return (new (_local_4)());
                };
                if (_local_8 == 1)
                {
                    return (new _local_4(_local_7[0]));
                };
                if (_local_8 == 2)
                {
                    return (new _local_4(_local_7[0], _local_7[1]));
                };
                if (_local_8 == 3)
                {
                    return (new _local_4(_local_7[0], _local_7[1], _local_7[2]));
                };
                if (_local_8 == 4)
                {
                    return (new _local_4(_local_7[0], _local_7[1], _local_7[2], _local_7[3]));
                };
                if (_local_8 == 5)
                {
                    return (new _local_4(_local_7[0], _local_7[1], _local_7[2], _local_7[3], _local_7[4]));
                };
                if (_local_8 == 6)
                {
                    return (new _local_4(_local_7[0], _local_7[1], _local_7[2], _local_7[3], _local_7[4], _local_7[5]));
                };
                if (_local_8 == 7)
                {
                    return (new _local_4(_local_7[0], _local_7[1], _local_7[2], _local_7[3], _local_7[4], _local_7[5], _local_7[6]));
                };
                if (_local_8 == 8)
                {
                    return (new _local_4(_local_7[0], _local_7[1], _local_7[2], _local_7[3], _local_7[4], _local_7[5], _local_7[6], _local_7[7]));
                };
                if (_local_8 == 9)
                {
                    return (new _local_4(_local_7[0], _local_7[1], _local_7[2], _local_7[3], _local_7[4], _local_7[5], _local_7[6], _local_7[7], _local_7[8]));
                };
                if (_local_8 == 10)
                {
                    return (new _local_4(_local_7[0], _local_7[1], _local_7[2], _local_7[3], _local_7[4], _local_7[5], _local_7[6], _local_7[7], _local_7[8], _local_7[9]));
                };
                throw (new Error("CommandLine can't create new class instances with more than 10 arguments."));
            };
            return (null);
        }

        private function ignoreWhite(_arg_1:String):String
        {
            _arg_1 = _arg_1.replace(/\s*(.*)/, "$1");
            var _local_2:int = (_arg_1.length - 1);
            while (_local_2 > 0)
            {
                if (_arg_1.charAt(_local_2).match(/\s/))
                {
                    _arg_1 = _arg_1.substring(0, _local_2);
                }
                else
                {
                    break;
                };
                _local_2--;
            };
            return (_arg_1);
        }


    }
}//package com.junkbyte.console.core

class ExeValue 
{

    public var obj:*;
    public var prop:String;

    public function ExeValue(_arg_1:Object=null, _arg_2:String=null):void
    {
        this.obj = _arg_1;
        this.prop = _arg_2;
    }

    public function get value():*
    {
        return ((this.prop) ? this.obj[this.prop] : this.obj);
    }

    public function setValue(_arg_1:*):void
    {
        if (this.prop)
        {
            this.obj[this.prop] = _arg_1;
        }
        else
        {
            this.obj = _arg_1;
        };
    }


}


