// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.swiftsuspenders.dependencyproviders.ClassProvider

package org.swiftsuspenders.dependencyproviders
{
    import org.swiftsuspenders.utils.SsInternal;
    import org.swiftsuspenders.Injector;
    import flash.utils.Dictionary;

    public class ClassProvider implements DependencyProvider 
    {

        private var _responseType:Class;

        public function ClassProvider(_arg_1:Class)
        {
            this._responseType = _arg_1;
        }

        public function apply(_arg_1:Class, _arg_2:Injector, _arg_3:Dictionary):Object
        {
            return (_arg_2.SsInternal::instantiateUnmapped(this._responseType));
        }

        public function destroy():void
        {
        }


    }
}//package org.swiftsuspenders.dependencyproviders

