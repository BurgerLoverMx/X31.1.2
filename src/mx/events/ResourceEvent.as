// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//mx.events.ResourceEvent

package mx.events
{
    import flash.events.ProgressEvent;
    import mx.core.mx_internal;
    import flash.events.Event;

    use namespace mx_internal;

    public class ResourceEvent extends ProgressEvent 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";
        public static const COMPLETE:String = "complete";
        public static const ERROR:String = "error";
        public static const PROGRESS:String = "progress";

        public var errorText:String;

        public function ResourceEvent(_arg_1:String, _arg_2:Boolean=false, _arg_3:Boolean=false, _arg_4:uint=0, _arg_5:uint=0, _arg_6:String=null)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
            this.errorText = _arg_6;
        }

        override public function clone():Event
        {
            return (new ResourceEvent(type, bubbles, cancelable, bytesLoaded, bytesTotal, this.errorText));
        }


    }
}//package mx.events

