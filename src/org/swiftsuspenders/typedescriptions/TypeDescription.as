// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.swiftsuspenders.typedescriptions.TypeDescription

package org.swiftsuspenders.typedescriptions
{
    import flash.utils.Dictionary;
    import org.swiftsuspenders.InjectorError;
    import flash.utils.getQualifiedClassName;

    public class TypeDescription 
    {

        public var ctor:ConstructorInjectionPoint;
        public var injectionPoints:InjectionPoint;
        public var preDestroyMethods:PreDestroyInjectionPoint;
        private var _postConstructAdded:Boolean;

        public function TypeDescription(_arg_1:Boolean=true)
        {
            if (_arg_1)
            {
                this.ctor = new NoParamsConstructorInjectionPoint();
            };
        }

        public function setConstructor(_arg_1:Array, _arg_2:Array=null, _arg_3:uint=2147483647, _arg_4:Dictionary=null):TypeDescription
        {
            this.ctor = new ConstructorInjectionPoint(this.createParameterMappings(_arg_1, ((_arg_2) || ([]))), _arg_3, _arg_4);
            return (this);
        }

        public function addFieldInjection(_arg_1:String, _arg_2:Class, _arg_3:String="", _arg_4:Boolean=false, _arg_5:Dictionary=null):TypeDescription
        {
            if (this._postConstructAdded)
            {
                throw (new InjectorError("Can't add injection point after post construct method"));
            };
            this.addInjectionPoint(new PropertyInjectionPoint(((getQualifiedClassName(_arg_2) + "|") + _arg_3), _arg_1, _arg_4, _arg_5));
            return (this);
        }

        public function addMethodInjection(_arg_1:String, _arg_2:Array, _arg_3:Array=null, _arg_4:uint=2147483647, _arg_5:Boolean=false, _arg_6:Dictionary=null):TypeDescription
        {
            if (this._postConstructAdded)
            {
                throw (new InjectorError("Can't add injection point after post construct method"));
            };
            this.addInjectionPoint(new MethodInjectionPoint(_arg_1, this.createParameterMappings(_arg_2, ((_arg_3) || ([]))), Math.min(_arg_4, _arg_2.length), _arg_5, _arg_6));
            return (this);
        }

        public function addPostConstructMethod(_arg_1:String, _arg_2:Array, _arg_3:Array=null, _arg_4:uint=2147483647):TypeDescription
        {
            this._postConstructAdded = true;
            this.addInjectionPoint(new PostConstructInjectionPoint(_arg_1, this.createParameterMappings(_arg_2, ((_arg_3) || ([]))), Math.min(_arg_4, _arg_2.length), 0));
            return (this);
        }

        public function addPreDestroyMethod(_arg_1:String, _arg_2:Array, _arg_3:Array=null, _arg_4:uint=2147483647):TypeDescription
        {
            var _local_5:PreDestroyInjectionPoint = new PreDestroyInjectionPoint(_arg_1, this.createParameterMappings(_arg_2, ((_arg_3) || ([]))), Math.min(_arg_4, _arg_2.length), 0);
            if (this.preDestroyMethods)
            {
                this.preDestroyMethods.last.next = _local_5;
                this.preDestroyMethods.last = _local_5;
            }
            else
            {
                this.preDestroyMethods = _local_5;
                this.preDestroyMethods.last = _local_5;
            };
            return (this);
        }

        public function addInjectionPoint(_arg_1:InjectionPoint):void
        {
            if (this.injectionPoints)
            {
                this.injectionPoints.last.next = _arg_1;
                this.injectionPoints.last = _arg_1;
            }
            else
            {
                this.injectionPoints = _arg_1;
                this.injectionPoints.last = _arg_1;
            };
        }

        private function createParameterMappings(_arg_1:Array, _arg_2:Array):Array
        {
            var _local_3:Array = new Array(_arg_1.length);
            var _local_4:int = _local_3.length;
            while (_local_4--)
            {
                _local_3[_local_4] = ((getQualifiedClassName(_arg_1[_local_4]) + "|") + ((_arg_2[_local_4]) || ("")));
            };
            return (_local_3);
        }


    }
}//package org.swiftsuspenders.typedescriptions

