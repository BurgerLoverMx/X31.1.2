// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.localEventMap.impl.EventMap

package robotlegs.bender.extensions.localEventMap.impl
{
    import robotlegs.bender.extensions.localEventMap.api.IEventMap;
    import __AS3__.vec.Vector;
    import flash.events.IEventDispatcher;
    import flash.events.Event;
    import __AS3__.vec.*;

    public class EventMap implements IEventMap 
    {

        private const _listeners:Vector.<EventMapConfig> = new Vector.<EventMapConfig>();
        private const _suspendedListeners:Vector.<EventMapConfig> = new Vector.<EventMapConfig>();

        private var _eventDispatcher:IEventDispatcher;
        private var _suspended:Boolean = false;

        public function EventMap(_arg_1:IEventDispatcher)
        {
            this._eventDispatcher = _arg_1;
        }

        public function mapListener(dispatcher:IEventDispatcher, eventString:String, listener:Function, eventClass:Class=null, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=true):void
        {
            var eventConfig:EventMapConfig;
            var callback:Function;
            eventClass = ((eventClass) || (Event));
            var currentListeners:Vector.<EventMapConfig> = ((this._suspended) ? this._suspendedListeners : this._listeners);
            var i:int = currentListeners.length;
            while (i--)
            {
                eventConfig = currentListeners[i];
                if ((((((eventConfig.dispatcher == dispatcher) && (eventConfig.eventString == eventString)) && (eventConfig.listener == listener)) && (eventConfig.useCapture == useCapture)) && (eventConfig.eventClass == eventClass)))
                {
                    return;
                };
            };
            if (eventClass != Event)
            {
                callback = function (_arg_1:Event):void
                {
                    routeEventToListener(_arg_1, listener, eventClass);
                };
            }
            else
            {
                callback = listener;
            };
            eventConfig = new EventMapConfig(dispatcher, eventString, listener, eventClass, callback, useCapture);
            currentListeners.push(eventConfig);
            if (!this._suspended)
            {
                dispatcher.addEventListener(eventString, callback, useCapture, priority, useWeakReference);
            };
        }

        public function unmapListener(_arg_1:IEventDispatcher, _arg_2:String, _arg_3:Function, _arg_4:Class=null, _arg_5:Boolean=false):void
        {
            var _local_6:EventMapConfig;
            _arg_4 = ((_arg_4) || (Event));
            var _local_7:Vector.<EventMapConfig> = ((this._suspended) ? this._suspendedListeners : this._listeners);
            var _local_8:int = _local_7.length;
            while (_local_8--)
            {
                _local_6 = _local_7[_local_8];
                if ((((((_local_6.dispatcher == _arg_1) && (_local_6.eventString == _arg_2)) && (_local_6.listener == _arg_3)) && (_local_6.useCapture == _arg_5)) && (_local_6.eventClass == _arg_4)))
                {
                    if (!this._suspended)
                    {
                        _arg_1.removeEventListener(_arg_2, _local_6.callback, _arg_5);
                    };
                    _local_7.splice(_local_8, 1);
                    return;
                };
            };
        }

        public function unmapListeners():void
        {
            var _local_2:EventMapConfig;
            var _local_3:IEventDispatcher;
            var _local_1:Vector.<EventMapConfig> = ((this._suspended) ? this._suspendedListeners : this._listeners);
            while ((_local_2 = _local_1.pop()))
            {
                if (!this._suspended)
                {
                    _local_3 = _local_2.dispatcher;
                    _local_3.removeEventListener(_local_2.eventString, _local_2.callback, _local_2.useCapture);
                };
            };
        }

        public function suspend():void
        {
            var _local_1:EventMapConfig;
            var _local_2:IEventDispatcher;
            if (this._suspended)
            {
                return;
            };
            this._suspended = true;
            while ((_local_1 = this._listeners.pop()))
            {
                _local_2 = _local_1.dispatcher;
                _local_2.removeEventListener(_local_1.eventString, _local_1.callback, _local_1.useCapture);
                this._suspendedListeners.push(_local_1);
            };
        }

        public function resume():void
        {
            var _local_1:EventMapConfig;
            var _local_2:IEventDispatcher;
            if (!this._suspended)
            {
                return;
            };
            this._suspended = false;
            while ((_local_1 = this._suspendedListeners.pop()))
            {
                _local_2 = _local_1.dispatcher;
                _local_2.addEventListener(_local_1.eventString, _local_1.callback, _local_1.useCapture);
                this._listeners.push(_local_1);
            };
        }

        private function routeEventToListener(_arg_1:Event, _arg_2:Function, _arg_3:Class):void
        {
            if ((_arg_1 is _arg_3))
            {
                (_arg_2(_arg_1));
            };
        }


    }
}//package robotlegs.bender.extensions.localEventMap.impl

