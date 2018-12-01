// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.swiftsuspenders.typedescriptions.PropertyInjectionPoint

package org.swiftsuspenders.typedescriptions
{
    import flash.utils.Dictionary;
    import org.swiftsuspenders.utils.SsInternal;
    import org.swiftsuspenders.dependencyproviders.DependencyProvider;
    import org.swiftsuspenders.errors.InjectorMissingMappingError;
    import flash.utils.getQualifiedClassName;
    import org.swiftsuspenders.Injector;

    public class PropertyInjectionPoint extends InjectionPoint 
    {

        private var _propertyName:String;
        private var _mappingId:String;
        private var _optional:Boolean;

        public function PropertyInjectionPoint(_arg_1:String, _arg_2:String, _arg_3:Boolean, _arg_4:Dictionary)
        {
            this._propertyName = _arg_2;
            this._mappingId = _arg_1;
            this._optional = _arg_3;
            this.injectParameters = _arg_4;
        }

        override public function applyInjection(_arg_1:Object, _arg_2:Class, _arg_3:Injector):void
        {
            var _local_4:DependencyProvider = _arg_3.SsInternal::getProvider(this._mappingId);
            if (!_local_4)
            {
                if (this._optional)
                {
                    return;
                };
                throw (new InjectorMissingMappingError((((((((('Injector is missing a mapping to handle injection into property "' + this._propertyName) + '" of object "') + _arg_1) + '" with type "') + getQualifiedClassName(_arg_2)) + '". Target dependency: "') + this._mappingId) + '"')));
            };
            _arg_1[this._propertyName] = _local_4.apply(_arg_2, _arg_3, injectParameters);
        }


    }
}//package org.swiftsuspenders.typedescriptions

