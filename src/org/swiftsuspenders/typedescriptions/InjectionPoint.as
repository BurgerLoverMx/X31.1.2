// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.swiftsuspenders.typedescriptions.InjectionPoint

package org.swiftsuspenders.typedescriptions
{
    import flash.utils.Dictionary;
    import org.swiftsuspenders.Injector;

    public class InjectionPoint 
    {

        public var next:InjectionPoint;
        public var last:InjectionPoint;
        public var injectParameters:Dictionary;


        public function applyInjection(_arg_1:Object, _arg_2:Class, _arg_3:Injector):void
        {
        }


    }
}//package org.swiftsuspenders.typedescriptions

