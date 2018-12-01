// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.swiftsuspenders.InjectionEvent

package org.swiftsuspenders
{
    import flash.events.Event;

    public class InjectionEvent extends Event 
    {

        public static const POST_INSTANTIATE:String = "postInstantiate";
        public static const PRE_CONSTRUCT:String = "preConstruct";
        public static const POST_CONSTRUCT:String = "postConstruct";

        public var instance:*;
        public var instanceType:Class;

        public function InjectionEvent(_arg_1:String, _arg_2:Object, _arg_3:Class)
        {
            super(_arg_1);
            this.instance = _arg_2;
            this.instanceType = _arg_3;
        }

        override public function clone():Event
        {
            return (new InjectionEvent(type, this.instance, this.instanceType));
        }


    }
}//package org.swiftsuspenders

