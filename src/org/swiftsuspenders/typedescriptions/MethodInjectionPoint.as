// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.swiftsuspenders.typedescriptions.MethodInjectionPoint

package org.swiftsuspenders.typedescriptions
{
    import flash.utils.Dictionary;
    import org.swiftsuspenders.Injector;
    import org.swiftsuspenders.dependencyproviders.DependencyProvider;
    import org.swiftsuspenders.utils.SsInternal;
    import org.swiftsuspenders.errors.InjectorMissingMappingError;
    import avmplus.getQualifiedClassName;

    public class MethodInjectionPoint extends InjectionPoint 
    {

        private static const _parameterValues:Array = [];

        protected var _parameterMappingIDs:Array;
        protected var _requiredParameters:int;
        private var _isOptional:Boolean;
        private var _methodName:String;

        public function MethodInjectionPoint(_arg_1:String, _arg_2:Array, _arg_3:uint, _arg_4:Boolean, _arg_5:Dictionary)
        {
            this._methodName = _arg_1;
            this._parameterMappingIDs = _arg_2;
            this._requiredParameters = _arg_3;
            this._isOptional = _arg_4;
            this.injectParameters = _arg_5;
        }

        override public function applyInjection(_arg_1:Object, _arg_2:Class, _arg_3:Injector):void
        {
            var _local_4:Array = this.gatherParameterValues(_arg_1, _arg_2, _arg_3);
            if (_local_4.length >= this._requiredParameters)
            {
                (_arg_1[this._methodName] as Function).apply(_arg_1, _local_4);
            };
            _local_4.length = 0;
        }

        protected function gatherParameterValues(_arg_1:Object, _arg_2:Class, _arg_3:Injector):Array
        {
            var _local_7:String;
            var _local_8:DependencyProvider;
            var _local_4:int = this._parameterMappingIDs.length;
            var _local_5:Array = _parameterValues;
            _local_5.length = _local_4;
            var _local_6:int;
            while (_local_6 < _local_4)
            {
                _local_7 = this._parameterMappingIDs[_local_6];
                _local_8 = _arg_3.SsInternal::getProvider(_local_7);
                if (!_local_8)
                {
                    if (((_local_6 >= this._requiredParameters) || (this._isOptional))) break;
                    throw (new InjectorMissingMappingError(((((((((('Injector is missing a mapping to handle injection into target "' + _arg_1) + '" of type "') + getQualifiedClassName(_arg_2)) + '". \t\t\t\t\t\tTarget dependency: ') + _local_7) + ", method: ") + this._methodName) + ", parameter: ") + (_local_6 + 1))));
                };
                _local_5[_local_6] = _local_8.apply(_arg_2, _arg_3, injectParameters);
                _local_6++;
            };
            return (_local_5);
        }


    }
}//package org.swiftsuspenders.typedescriptions

