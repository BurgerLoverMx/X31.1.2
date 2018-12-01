// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//mx.events.Request

package mx.events
{
    import flash.events.Event;
    import mx.core.mx_internal;

    use namespace mx_internal;

    public class Request extends Event 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";
        public static const GET_PARENT_FLEX_MODULE_FACTORY_REQUEST:String = "getParentFlexModuleFactoryRequest";

        public var value:Object;

        public function Request(_arg_1:String, _arg_2:Boolean=false, _arg_3:Boolean=false, _arg_4:Object=null)
        {
            super(_arg_1, _arg_2, _arg_3);
            this.value = _arg_4;
        }

        override public function clone():Event
        {
            return (new Request(type, bubbles, cancelable, this.value));
        }


    }
}//package mx.events

