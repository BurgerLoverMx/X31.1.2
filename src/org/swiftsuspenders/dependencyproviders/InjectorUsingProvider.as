// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.swiftsuspenders.dependencyproviders.InjectorUsingProvider

package org.swiftsuspenders.dependencyproviders
{
    import org.swiftsuspenders.Injector;
    import flash.utils.Dictionary;

    public class InjectorUsingProvider extends ForwardingProvider 
    {

        public var injector:Injector;

        public function InjectorUsingProvider(_arg_1:Injector, _arg_2:DependencyProvider)
        {
            super(_arg_2);
            this.injector = _arg_1;
        }

        override public function apply(_arg_1:Class, _arg_2:Injector, _arg_3:Dictionary):Object
        {
            return (provider.apply(_arg_1, this.injector, _arg_3));
        }


    }
}//package org.swiftsuspenders.dependencyproviders

