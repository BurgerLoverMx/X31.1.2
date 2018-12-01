// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.swiftsuspenders.dependencyproviders.ValueProvider

package org.swiftsuspenders.dependencyproviders
{
    import org.swiftsuspenders.Injector;
    import flash.utils.Dictionary;

    public class ValueProvider implements DependencyProvider 
    {

        private var _value:Object;

        public function ValueProvider(_arg_1:Object)
        {
            this._value = _arg_1;
        }

        public function apply(_arg_1:Class, _arg_2:Injector, _arg_3:Dictionary):Object
        {
            return (this._value);
        }

        public function destroy():void
        {
        }


    }
}//package org.swiftsuspenders.dependencyproviders

