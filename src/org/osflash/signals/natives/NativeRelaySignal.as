// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.osflash.signals.natives.NativeRelaySignal

package org.osflash.signals.natives
{
    import org.osflash.signals.Signal;
    import flash.events.IEventDispatcher;
    import flash.events.Event;
    import org.osflash.signals.ISlot;
    import org.osflash.signals.SlotList;
    import org.osflash.signals.Slot;

    public class NativeRelaySignal extends Signal implements INativeDispatcher 
    {

        protected var _target:IEventDispatcher;
        protected var _eventType:String;
        protected var _eventClass:Class;

        public function NativeRelaySignal(_arg_1:IEventDispatcher, _arg_2:String, _arg_3:Class=null)
        {
            super(((_arg_3) || (Event)));
            this.eventType = _arg_2;
            this.eventClass = _arg_3;
            this.target = _arg_1;
        }

        public function get target():IEventDispatcher
        {
            return (this._target);
        }

        public function set target(_arg_1:IEventDispatcher):void
        {
            if (_arg_1 == this._target)
            {
                return;
            };
            if (this._target)
            {
                this.removeAll();
            };
            this._target = _arg_1;
        }

        public function get eventType():String
        {
            return (this._eventType);
        }

        public function set eventType(_arg_1:String):void
        {
            this._eventType = _arg_1;
        }

        public function get eventClass():Class
        {
            return (this._eventClass);
        }

        public function set eventClass(_arg_1:Class):void
        {
            this._eventClass = ((_arg_1) || (Event));
            _valueClasses = [this._eventClass];
        }

        override public function set valueClasses(_arg_1:Array):void
        {
            this.eventClass = (((_arg_1) && (_arg_1.length > 0)) ? _arg_1[0] : null);
        }

        override public function add(_arg_1:Function):ISlot
        {
            return (this.addWithPriority(_arg_1));
        }

        override public function addOnce(_arg_1:Function):ISlot
        {
            return (this.addOnceWithPriority(_arg_1));
        }

        public function addWithPriority(_arg_1:Function, _arg_2:int=0):ISlot
        {
            return (this.registerListenerWithPriority(_arg_1, false, _arg_2));
        }

        public function addOnceWithPriority(_arg_1:Function, _arg_2:int=0):ISlot
        {
            return (this.registerListenerWithPriority(_arg_1, true, _arg_2));
        }

        override public function remove(_arg_1:Function):ISlot
        {
            var _local_2:Boolean = slots.nonEmpty;
            var _local_3:ISlot = super.remove(_arg_1);
            if (_local_2 != slots.nonEmpty)
            {
                this.target.removeEventListener(this.eventType, this.onNativeEvent);
            };
            return (_local_3);
        }

        override public function removeAll():void
        {
            if (this.target)
            {
                this.target.removeEventListener(this.eventType, this.onNativeEvent);
            };
            super.removeAll();
        }

        override public function dispatch(... _args):void
        {
            if (null == _args)
            {
                throw (new ArgumentError("Event object expected."));
            };
            if (_args.length != 1)
            {
                throw (new ArgumentError("No more than one Event object expected."));
            };
            this.dispatchEvent((_args[0] as Event));
        }

        public function dispatchEvent(_arg_1:Event):Boolean
        {
            if (!this.target)
            {
                throw (new ArgumentError("Target object cannot be null."));
            };
            if (!_arg_1)
            {
                throw (new ArgumentError("Event object cannot be null."));
            };
            if (!(_arg_1 is this.eventClass))
            {
                throw (new ArgumentError((((("Event object " + _arg_1) + " is not an instance of ") + this.eventClass) + ".")));
            };
            if (_arg_1.type != this.eventType)
            {
                throw (new ArgumentError((((("Event object has incorrect type. Expected <" + this.eventType) + "> but was <") + _arg_1.type) + ">.")));
            };
            return (this.target.dispatchEvent(_arg_1));
        }

        protected function onNativeEvent(_arg_1:Event):void
        {
            var _local_2:SlotList = slots;
            while (_local_2.nonEmpty)
            {
                _local_2.head.execute1(_arg_1);
                _local_2 = _local_2.tail;
            };
        }

        protected function registerListenerWithPriority(_arg_1:Function, _arg_2:Boolean=false, _arg_3:int=0):ISlot
        {
            if (!this.target)
            {
                throw (new ArgumentError("Target object cannot be null."));
            };
            var _local_4:Boolean = slots.nonEmpty;
            var _local_5:ISlot;
            if (registrationPossible(_arg_1, _arg_2))
            {
                _local_5 = new Slot(_arg_1, this, _arg_2, _arg_3);
                slots = slots.insertWithPriority(_local_5);
            }
            else
            {
                _local_5 = slots.find(_arg_1);
            };
            if (_local_4 != slots.nonEmpty)
            {
                this.target.addEventListener(this.eventType, this.onNativeEvent, false, _arg_3);
            };
            return (_local_5);
        }


    }
}//package org.osflash.signals.natives

