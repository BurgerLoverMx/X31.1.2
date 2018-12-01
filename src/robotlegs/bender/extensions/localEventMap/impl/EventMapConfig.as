// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.localEventMap.impl.EventMapConfig

package robotlegs.bender.extensions.localEventMap.impl
{
    import flash.events.IEventDispatcher;

    public class EventMapConfig 
    {

        private var _dispatcher:IEventDispatcher;
        private var _eventString:String;
        private var _listener:Function;
        private var _eventClass:Class;
        private var _callback:Function;
        private var _useCapture:Boolean;

        public function EventMapConfig(_arg_1:IEventDispatcher, _arg_2:String, _arg_3:Function, _arg_4:Class, _arg_5:Function, _arg_6:Boolean)
        {
            this._dispatcher = _arg_1;
            this._eventString = _arg_2;
            this._listener = _arg_3;
            this._eventClass = _arg_4;
            this._callback = _arg_5;
            this._useCapture = _arg_6;
        }

        public function get dispatcher():IEventDispatcher
        {
            return (this._dispatcher);
        }

        public function get eventString():String
        {
            return (this._eventString);
        }

        public function get listener():Function
        {
            return (this._listener);
        }

        public function get eventClass():Class
        {
            return (this._eventClass);
        }

        public function get callback():Function
        {
            return (this._callback);
        }

        public function get useCapture():Boolean
        {
            return (this._useCapture);
        }


    }
}//package robotlegs.bender.extensions.localEventMap.impl

