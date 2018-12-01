// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.viewManager.impl.ViewManagerEvent

package robotlegs.bender.extensions.viewManager.impl
{
    import flash.events.Event;
    import flash.display.DisplayObjectContainer;
    import robotlegs.bender.extensions.viewManager.api.IViewHandler;

    public class ViewManagerEvent extends Event 
    {

        public static const CONTAINER_ADD:String = "containerAdd";
        public static const CONTAINER_REMOVE:String = "containerRemove";
        public static const HANDLER_ADD:String = "handlerAdd";
        public static const HANDLER_REMOVE:String = "handlerRemove";

        private var _container:DisplayObjectContainer;
        private var _handler:IViewHandler;

        public function ViewManagerEvent(_arg_1:String, _arg_2:DisplayObjectContainer=null, _arg_3:IViewHandler=null)
        {
            super(_arg_1);
            this._container = _arg_2;
            this._handler = _arg_3;
        }

        public function get container():DisplayObjectContainer
        {
            return (this._container);
        }

        public function get handler():IViewHandler
        {
            return (this._handler);
        }

        override public function clone():Event
        {
            return (new ViewManagerEvent(type, this._container, this._handler));
        }


    }
}//package robotlegs.bender.extensions.viewManager.impl

