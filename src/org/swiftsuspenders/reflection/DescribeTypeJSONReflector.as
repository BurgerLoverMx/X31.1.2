// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.swiftsuspenders.reflection.DescribeTypeJSONReflector

package org.swiftsuspenders.reflection
{
    import avmplus.DescribeTypeJSON;
    import flash.utils.getQualifiedClassName;
    import org.swiftsuspenders.typedescriptions.TypeDescription;
    import flash.utils.Dictionary;
    import org.swiftsuspenders.typedescriptions.NoParamsConstructorInjectionPoint;
    import org.swiftsuspenders.typedescriptions.ConstructorInjectionPoint;
    import org.swiftsuspenders.typedescriptions.MethodInjectionPoint;
    import org.swiftsuspenders.typedescriptions.PostConstructInjectionPoint;
    import org.swiftsuspenders.typedescriptions.PreDestroyInjectionPoint;
    import org.swiftsuspenders.typedescriptions.PropertyInjectionPoint;
    import org.swiftsuspenders.InjectorError;

    public class DescribeTypeJSONReflector extends ReflectorBase implements Reflector 
    {

        private const _descriptor:DescribeTypeJSON = new DescribeTypeJSON();


        public function typeImplements(_arg_1:Class, _arg_2:Class):Boolean
        {
            if (_arg_1 == _arg_2)
            {
                return (true);
            };
            var _local_3:String = getQualifiedClassName(_arg_2);
            var _local_4:Object = this._descriptor.getInstanceDescription(_arg_1).traits;
            return (((_local_4.bases as Array).indexOf(_local_3) > -1) || ((_local_4.interfaces as Array).indexOf(_local_3) > -1));
        }

        public function describeInjections(_arg_1:Class):TypeDescription
        {
            var _local_2:Object;
            _local_2 = this._descriptor.getInstanceDescription(_arg_1);
            var _local_3:Object = _local_2.traits;
            var _local_4:String = _local_2.name;
            var _local_5:TypeDescription = new TypeDescription(false);
            this.addCtorInjectionPoint(_local_5, _local_3, _local_4);
            this.addFieldInjectionPoints(_local_5, _local_3.variables);
            this.addFieldInjectionPoints(_local_5, _local_3.accessors);
            this.addMethodInjectionPoints(_local_5, _local_3.methods, _local_4);
            this.addPostConstructMethodPoints(_local_5, _local_3.variables, _local_4);
            this.addPostConstructMethodPoints(_local_5, _local_3.accessors, _local_4);
            this.addPostConstructMethodPoints(_local_5, _local_3.methods, _local_4);
            this.addPreDestroyMethodPoints(_local_5, _local_3.methods, _local_4);
            return (_local_5);
        }

        private function addCtorInjectionPoint(_arg_1:TypeDescription, _arg_2:Object, _arg_3:String):void
        {
            var _local_5:Dictionary;
            var _local_6:Array;
            var _local_4:Array = _arg_2.constructor;
            if (!_local_4)
            {
                _arg_1.ctor = ((_arg_2.bases.length > 0) ? new NoParamsConstructorInjectionPoint() : null);
                return;
            };
            _local_5 = this.extractTagParameters("Inject", _arg_2.metadata);
            _local_6 = (((_local_5) && (_local_5.name)) || ("")).split(",");
            var _local_7:int = this.gatherMethodParameters(_local_4, _local_6, _arg_3);
            _arg_1.ctor = new ConstructorInjectionPoint(_local_4, _local_7, _local_5);
        }

        private function addMethodInjectionPoints(_arg_1:TypeDescription, _arg_2:Array, _arg_3:String):void
        {
            var _local_6:Object;
            var _local_7:Dictionary;
            var _local_8:Boolean;
            var _local_9:Array;
            var _local_10:Array;
            var _local_11:uint;
            var _local_12:MethodInjectionPoint;
            if (!_arg_2)
            {
                return;
            };
            var _local_4:uint = _arg_2.length;
            var _local_5:int;
            while (_local_5 < _local_4)
            {
                _local_6 = _arg_2[_local_5];
                _local_7 = this.extractTagParameters("Inject", _local_6.metadata);
                if (_local_7)
                {
                    _local_8 = (_local_7.optional == "true");
                    _local_9 = ((_local_7.name) || ("")).split(",");
                    _local_10 = _local_6.parameters;
                    _local_11 = this.gatherMethodParameters(_local_10, _local_9, _arg_3);
                    _local_12 = new MethodInjectionPoint(_local_6.name, _local_10, _local_11, _local_8, _local_7);
                    _arg_1.addInjectionPoint(_local_12);
                };
                _local_5++;
            };
        }

        private function addPostConstructMethodPoints(_arg_1:TypeDescription, _arg_2:Array, _arg_3:String):void
        {
            var _local_4:Array = this.gatherOrderedInjectionPointsForTag(PostConstructInjectionPoint, "PostConstruct", _arg_2, _arg_3);
            var _local_5:int;
            var _local_6:int = _local_4.length;
            while (_local_5 < _local_6)
            {
                _arg_1.addInjectionPoint(_local_4[_local_5]);
                _local_5++;
            };
        }

        private function addPreDestroyMethodPoints(_arg_1:TypeDescription, _arg_2:Array, _arg_3:String):void
        {
            var _local_4:Array = this.gatherOrderedInjectionPointsForTag(PreDestroyInjectionPoint, "PreDestroy", _arg_2, _arg_3);
            if (!_local_4.length)
            {
                return;
            };
            _arg_1.preDestroyMethods = _local_4[0];
            _arg_1.preDestroyMethods.last = _local_4[0];
            var _local_5:int = 1;
            var _local_6:int = _local_4.length;
            while (_local_5 < _local_6)
            {
                _arg_1.preDestroyMethods.last.next = _local_4[_local_5];
                _arg_1.preDestroyMethods.last = _local_4[_local_5];
                _local_5++;
            };
        }

        private function addFieldInjectionPoints(_arg_1:TypeDescription, _arg_2:Array):void
        {
            var _local_5:Object;
            var _local_6:Dictionary;
            var _local_7:String;
            var _local_8:Boolean;
            var _local_9:PropertyInjectionPoint;
            if (!_arg_2)
            {
                return;
            };
            var _local_3:uint = _arg_2.length;
            var _local_4:int;
            while (_local_4 < _local_3)
            {
                _local_5 = _arg_2[_local_4];
                _local_6 = this.extractTagParameters("Inject", _local_5.metadata);
                if (_local_6)
                {
                    _local_7 = ((_local_6.name) || (""));
                    _local_8 = (_local_6.optional == "true");
                    _local_9 = new PropertyInjectionPoint(((_local_5.type + "|") + _local_7), _local_5.name, _local_8, _local_6);
                    _arg_1.addInjectionPoint(_local_9);
                };
                _local_4++;
            };
        }

        private function gatherMethodParameters(_arg_1:Array, _arg_2:Array, _arg_3:String):uint
        {
            var _local_7:Object;
            var _local_8:String;
            var _local_9:String;
            var _local_4:uint;
            var _local_5:uint = _arg_1.length;
            var _local_6:int;
            while (_local_6 < _local_5)
            {
                _local_7 = _arg_1[_local_6];
                _local_8 = ((_arg_2[_local_6]) || (""));
                _local_9 = _local_7.type;
                if (_local_9 == "*")
                {
                    if (!_local_7.optional)
                    {
                        throw (new InjectorError((('Error in method definition of injectee "' + _arg_3) + ". Required parameters can't have type \"*\".")));
                    };
                    _local_9 = null;
                };
                if (!_local_7.optional)
                {
                    _local_4++;
                };
                _arg_1[_local_6] = ((_local_9 + "|") + _local_8);
                _local_6++;
            };
            return (_local_4);
        }

        private function gatherOrderedInjectionPointsForTag(_arg_1:Class, _arg_2:String, _arg_3:Array, _arg_4:String):Array
        {
            var _local_8:Object;
            var _local_9:Object;
            var _local_10:Array;
            var _local_11:Array;
            var _local_12:uint;
            var _local_13:int;
            var _local_5:Array = [];
            if (!_arg_3)
            {
                return (_local_5);
            };
            var _local_6:uint = _arg_3.length;
            var _local_7:int;
            while (_local_7 < _local_6)
            {
                _local_8 = _arg_3[_local_7];
                _local_9 = this.extractTagParameters(_arg_2, _local_8.metadata);
                if (_local_9)
                {
                    _local_10 = ((_local_9.name) || ("")).split(",");
                    _local_11 = _local_8.parameters;
                    if (_local_11)
                    {
                        _local_12 = this.gatherMethodParameters(_local_11, _local_10, _arg_4);
                    }
                    else
                    {
                        _local_11 = [];
                        _local_12 = 0;
                    };
                    _local_13 = parseInt(_local_9.order, 10);
                    if (_local_13.toString(10) != _local_9.order)
                    {
                        _local_13 = int.MAX_VALUE;
                    };
                    _local_5.push(new _arg_1(_local_8.name, _local_11, _local_12, _local_13));
                };
                _local_7++;
            };
            if (_local_5.length > 0)
            {
                _local_5.sortOn("order", Array.NUMERIC);
            };
            return (_local_5);
        }

        private function extractTagParameters(_arg_1:String, _arg_2:Array):Dictionary
        {
            var _local_5:Object;
            var _local_6:Array;
            var _local_7:Dictionary;
            var _local_8:int;
            var _local_9:int;
            var _local_10:Object;
            var _local_3:uint = ((_arg_2) ? _arg_2.length : 0);
            var _local_4:int;
            while (_local_4 < _local_3)
            {
                _local_5 = _arg_2[_local_4];
                if (_local_5.name == _arg_1)
                {
                    _local_6 = _local_5.value;
                    _local_7 = new Dictionary();
                    _local_8 = _local_6.length;
                    _local_9 = 0;
                    while (_local_9 < _local_8)
                    {
                        _local_10 = _local_6[_local_9];
                        _local_7[_local_10.key] = ((_local_7[_local_10.key]) ? ((_local_7[_local_10.key] + ",") + _local_10.value) : _local_10.value);
                        _local_9++;
                    };
                    return (_local_7);
                };
                _local_4++;
            };
            return (null);
        }


    }
}//package org.swiftsuspenders.reflection

