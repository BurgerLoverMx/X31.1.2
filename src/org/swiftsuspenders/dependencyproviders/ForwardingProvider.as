// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.swiftsuspenders.dependencyproviders.ForwardingProvider

package org.swiftsuspenders.dependencyproviders
{
    import org.swiftsuspenders.Injector;
    import flash.utils.Dictionary;

    public class ForwardingProvider implements DependencyProvider 
    {

        public var provider:DependencyProvider;

        public function ForwardingProvider(_arg_1:DependencyProvider)
        {
            this.provider = _arg_1;
        }

        public function apply(_arg_1:Class, _arg_2:Injector, _arg_3:Dictionary):Object
        {
            return (this.provider.apply(_arg_1, _arg_2, _arg_3));
        }

        public function destroy():void
        {
            this.provider.destroy();
        }


    }
}//package org.swiftsuspenders.dependencyproviders

