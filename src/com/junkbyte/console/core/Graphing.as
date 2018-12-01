// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.junkbyte.console.core.Graphing

package com.junkbyte.console.core
{
    import com.junkbyte.console.vos.GraphGroup;
    import flash.utils.ByteArray;
    import com.junkbyte.console.Console;
    import com.junkbyte.console.vos.GraphInterest;
    import flash.geom.Rectangle;
    import flash.utils.getTimer;
    import flash.system.System;

    public class Graphing extends ConsoleCore 
    {

        private var _groups:Array = [];
        private var _map:Object = {};
        private var _fpsGroup:GraphGroup;
        private var _memGroup:GraphGroup;
        private var _hadGraph:Boolean;
        private var _previousTime:Number = -1;

        public function Graphing(m:Console)
        {
            super(m);
            remoter.registerCallback("fps", function (_arg_1:ByteArray):void
            {
                fpsMonitor = _arg_1.readBoolean();
            });
            remoter.registerCallback("mem", function (_arg_1:ByteArray):void
            {
                memoryMonitor = _arg_1.readBoolean();
            });
            remoter.registerCallback("removeGroup", function (_arg_1:ByteArray):void
            {
                removeGroup(_arg_1.readUTF());
            });
            remoter.registerCallback("graph", this.handleRemoteGraph, true);
        }

        public function add(n:String, obj:Object, prop:String, col:Number=-1, key:String=null, rect:Rectangle=null, inverse:Boolean=false):void
        {
            var newGroup:Boolean;
            var i:GraphInterest;
            if (obj == null)
            {
                report((((("ERROR: Graph [" + n) + "] received a null object to graph property [") + prop) + "]."), 10);
                return;
            };
            var group:GraphGroup = this._map[n];
            if (!group)
            {
                newGroup = true;
                group = new GraphGroup(n);
            };
            var interests:Array = group.interests;
            if (((isNaN(col)) || (col < 0)))
            {
                if (interests.length <= 5)
                {
                    col = config.style[("priority" + (10 - (interests.length * 2)))];
                }
                else
                {
                    col = (Math.random() * 0xFFFFFF);
                };
            };
            if (key == null)
            {
                key = prop;
            };
            for each (i in interests)
            {
                if (i.key == key)
                {
                    report((((("Graph with key [" + key) + "] already exists in [") + n) + "]"), 10);
                    return;
                };
            };
            if (rect)
            {
                group.rect = rect;
            };
            if (inverse)
            {
                group.inv = inverse;
            };
            var interest:GraphInterest = new GraphInterest(key, col);
            var v:Number = NaN;
            try
            {
                v = interest.setObject(obj, prop);
            }
            catch(e:Error)
            {
                report(((((("Error with graph value for [" + key) + "] in [") + n) + "]. ") + e), 10);
                return;
            };
            if (isNaN(v))
            {
                report((((("Graph value for key [" + key) + "] in [") + n) + "] is not a number (NaN)."), 10);
            }
            else
            {
                group.interests.push(interest);
                if (newGroup)
                {
                    this._map[n] = group;
                    this._groups.push(group);
                };
            };
        }

        public function fixRange(_arg_1:String, _arg_2:Number=NaN, _arg_3:Number=NaN):void
        {
            var _local_4:GraphGroup = this._map[_arg_1];
            if (!_local_4)
            {
                return;
            };
            _local_4.low = _arg_2;
            _local_4.hi = _arg_3;
            _local_4.fixed = (!((isNaN(_arg_2)) || (isNaN(_arg_3))));
        }

        public function remove(_arg_1:String, _arg_2:Object=null, _arg_3:String=null):void
        {
            var _local_4:Array;
            var _local_5:int;
            var _local_6:GraphInterest;
            if (((_arg_2 == null) && (_arg_3 == null)))
            {
                this.removeGroup(_arg_1);
            }
            else
            {
                if (this._map[_arg_1])
                {
                    _local_4 = this._map[_arg_1].interests;
                    _local_5 = (_local_4.length - 1);
                    while (_local_5 >= 0)
                    {
                        _local_6 = _local_4[_local_5];
                        if ((((_arg_2 == null) || (_local_6.obj == _arg_2)) && ((_arg_3 == null) || (_local_6.prop == _arg_3))))
                        {
                            _local_4.splice(_local_5, 1);
                        };
                        _local_5--;
                    };
                    if (_local_4.length == 0)
                    {
                        this.removeGroup(_arg_1);
                    };
                };
            };
        }

        private function removeGroup(_arg_1:String):void
        {
            var _local_2:ByteArray;
            var _local_3:GraphGroup;
            var _local_4:int;
            if (remoter.remoting == Remoting.RECIEVER)
            {
                _local_2 = new ByteArray();
                _local_2.writeUTF(_arg_1);
                remoter.send("removeGroup", _local_2);
            }
            else
            {
                _local_3 = this._map[_arg_1];
                _local_4 = this._groups.indexOf(_local_3);
                if (_local_4 >= 0)
                {
                    this._groups.splice(_local_4, 1);
                };
                delete this._map[_arg_1];
            };
        }

        public function get fpsMonitor():Boolean
        {
            if (remoter.remoting == Remoting.RECIEVER)
            {
                return (console.panels.fpsMonitor);
            };
            return (!(this._fpsGroup == null));
        }

        public function set fpsMonitor(_arg_1:Boolean):void
        {
            var _local_2:ByteArray;
            var _local_3:int;
            if (remoter.remoting == Remoting.RECIEVER)
            {
                _local_2 = new ByteArray();
                _local_2.writeBoolean(_arg_1);
                remoter.send("fps", _local_2);
            }
            else
            {
                if (_arg_1 != this.fpsMonitor)
                {
                    if (_arg_1)
                    {
                        this._fpsGroup = this.addSpecialGroup(GraphGroup.FPS);
                        this._fpsGroup.low = 0;
                        this._fpsGroup.fixed = true;
                        this._fpsGroup.averaging = 30;
                    }
                    else
                    {
                        this._previousTime = -1;
                        _local_3 = this._groups.indexOf(this._fpsGroup);
                        if (_local_3 >= 0)
                        {
                            this._groups.splice(_local_3, 1);
                        };
                        this._fpsGroup = null;
                    };
                    console.panels.mainPanel.updateMenu();
                };
            };
        }

        public function get memoryMonitor():Boolean
        {
            if (remoter.remoting == Remoting.RECIEVER)
            {
                return (console.panels.memoryMonitor);
            };
            return (!(this._memGroup == null));
        }

        public function set memoryMonitor(_arg_1:Boolean):void
        {
            var _local_2:ByteArray;
            var _local_3:int;
            if (remoter.remoting == Remoting.RECIEVER)
            {
                _local_2 = new ByteArray();
                _local_2.writeBoolean(_arg_1);
                remoter.send("mem", _local_2);
            }
            else
            {
                if (_arg_1 != this.memoryMonitor)
                {
                    if (_arg_1)
                    {
                        this._memGroup = this.addSpecialGroup(GraphGroup.MEM);
                        this._memGroup.freq = 20;
                    }
                    else
                    {
                        _local_3 = this._groups.indexOf(this._memGroup);
                        if (_local_3 >= 0)
                        {
                            this._groups.splice(_local_3, 1);
                        };
                        this._memGroup = null;
                    };
                    console.panels.mainPanel.updateMenu();
                };
            };
        }

        private function addSpecialGroup(_arg_1:int):GraphGroup
        {
            var _local_2:GraphGroup = new GraphGroup("special");
            _local_2.type = _arg_1;
            this._groups.push(_local_2);
            var _local_3:GraphInterest = new GraphInterest("special");
            if (_arg_1 == GraphGroup.FPS)
            {
                _local_3.col = 16724787;
            }
            else
            {
                _local_3.col = 5267711;
            };
            _local_2.interests.push(_local_3);
            return (_local_2);
        }

        public function update(_arg_1:Number=0):Array
        {
            var _local_2:GraphInterest;
            var _local_3:Number;
            var _local_4:GraphGroup;
            var _local_5:Boolean;
            var _local_6:uint;
            var _local_7:uint;
            var _local_8:Array;
            var _local_9:int;
            var _local_10:Number;
            var _local_11:uint;
            var _local_12:ByteArray;
            var _local_13:uint;
            for each (_local_4 in this._groups)
            {
                _local_5 = true;
                if (_local_4.freq > 1)
                {
                    _local_4.idle++;
                    if (_local_4.idle < _local_4.freq)
                    {
                        _local_5 = false;
                    }
                    else
                    {
                        _local_4.idle = 0;
                    };
                };
                if (_local_5)
                {
                    _local_6 = _local_4.type;
                    _local_7 = _local_4.averaging;
                    _local_8 = _local_4.interests;
                    if (_local_6 == GraphGroup.FPS)
                    {
                        _local_4.hi = _arg_1;
                        _local_2 = _local_8[0];
                        _local_9 = getTimer();
                        if (this._previousTime >= 0)
                        {
                            _local_10 = (_local_9 - this._previousTime);
                            _local_3 = (1000 / _local_10);
                            _local_2.setValue(_local_3, _local_7);
                        };
                        this._previousTime = _local_9;
                    }
                    else
                    {
                        if (_local_6 == GraphGroup.MEM)
                        {
                            _local_2 = _local_8[0];
                            _local_3 = (Math.round((System.totalMemory / 10485.76)) / 100);
                            _local_4.updateMinMax(_local_3);
                            _local_2.setValue(_local_3, _local_7);
                        }
                        else
                        {
                            this.updateExternalGraphGroup(_local_4);
                        };
                    };
                };
            };
            if (((remoter.canSend) && ((this._hadGraph) || (this._groups.length))))
            {
                _local_11 = this._groups.length;
                _local_12 = new ByteArray();
                _local_13 = 0;
                while (_local_13 < _local_11)
                {
                    GraphGroup(this._groups[_local_13]).toBytes(_local_12);
                    _local_13++;
                };
                remoter.send("graph", _local_12);
                this._hadGraph = (this._groups.length > 0);
            };
            return (this._groups);
        }

        private function updateExternalGraphGroup(group:GraphGroup):void
        {
            var i:GraphInterest;
            var v:Number;
            for each (i in group.interests)
            {
                try
                {
                    v = i.getCurrentValue();
                    i.setValue(v, group.averaging);
                }
                catch(e:Error)
                {
                    report(((((("Error with graph value for key [" + i.key) + "] in [") + group.name) + "]. ") + e), 10);
                    remove(group.name, i.obj, i.prop);
                };
                group.updateMinMax(v);
            };
        }

        private function handleRemoteGraph(_arg_1:ByteArray=null):void
        {
            var _local_2:Array;
            if (((_arg_1) && (_arg_1.length)))
            {
                _arg_1.position = 0;
                _local_2 = new Array();
                while (_arg_1.bytesAvailable)
                {
                    _local_2.push(GraphGroup.FromBytes(_arg_1));
                };
                console.panels.updateGraphs(_local_2);
            }
            else
            {
                console.panels.updateGraphs(new Array());
            };
        }


    }
}//package com.junkbyte.console.core

