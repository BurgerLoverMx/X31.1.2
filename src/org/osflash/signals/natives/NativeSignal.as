// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.osflash.signals.natives.NativeSignal

package org.osflash.signals.natives
{
    import flash.events.IEventDispatcher;
    import org.osflash.signals.SlotList;
    import flash.events.Event;
    import org.osflash.signals.ISlot;
    import org.osflash.signals.Slot;
    import flash.errors.IllegalOperationError;

    public class NativeSignal implements INativeDispatcher 
    {

        protected var _target:IEventDispatcher;
        protected var _eventType:String;
        protected var _eventClass:Class;
        protected var _valueClasses:Array;
        protected var slots:SlotList;

        public function NativeSignal(_arg_1:IEventDispatcher=null, _arg_2:String="", _arg_3:Class=null)
        {
            this.slots = SlotList.NIL;
            this.target = _arg_1;
            this.eventType = _arg_2;
            this.eventClass = _arg_3;
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
            this._valueClasses = [this._eventClass];
        }

        [ArrayElementType("Class")]
        public function get valueClasses():Array
        {
            return (this._valueClasses);
        }

        public function set valueClasses(_arg_1:Array):void
        {
            this.eventClass = (((_arg_1) && (_arg_1.length > 0)) ? _arg_1[0] : null);
        }

        public function get numListeners():uint
        {
            return (this.slots.length);
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

        public function add(_arg_1:Function):ISlot
        {
            return (this.addWithPriority(_arg_1));
        }

        public function addWithPriority(_arg_1:Function, _arg_2:int=0):ISlot
        {
            return (this.registerListenerWithPriority(_arg_1, false, _arg_2));
        }

        public function addOnce(_arg_1:Function):ISlot
        {
            return (this.addOnceWithPriority(_arg_1));
        }

        public function addOnceWithPriority(_arg_1:Function, _arg_2:int=0):ISlot
        {
            return (this.registerListenerWithPriority(_arg_1, true, _arg_2));
        }

        public function remove(_arg_1:Function):ISlot
        {
            var _local_2:ISlot = this.slots.find(_arg_1);
            if (!_local_2)
            {
                return (null);
            };
            this._target.removeEventListener(this._eventType, _local_2.execute1);
            this.slots = this.slots.filterNot(_arg_1);
            return (_local_2);
        }

        public function removeAll():void
        {
            var _local_1:SlotList = this.slots;
            while (_local_1.nonEmpty)
            {
                this.target.removeEventListener(this._eventType, _local_1.head.execute1);
                _local_1 = _local_1.tail;
            };
            this.slots = SlotList.NIL;
        }

        public function dispatch(... _args):void
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

        protected function registerListenerWithPriority(_arg_1:Function, _arg_2:Boolean=false, _arg_3:int=0):ISlot
        {
            var _local_4:ISlot;
            if (!this.target)
            {
                throw (new ArgumentError("Target object cannot be null."));
            };
            if (this.registrationPossible(_arg_1, _arg_2))
            {
                _local_4 = new Slot(_arg_1, this, _arg_2, _arg_3);
                this.slots = this.slots.prepend(_local_4);
                this._target.addEventListener(this._eventType, _local_4.execute1, false, _arg_3);
                return (_local_4);
            };
            return (this.slots.find(_arg_1));
        }

        protected function registrationPossible(_arg_1:Function, _arg_2:Boolean):Boolean
        {
            if (!this.slots.nonEmpty)
            {
                return (true);
            };
            var _local_3:ISlot = this.slots.find(_arg_1);
            if (_local_3)
            {
                if (_local_3.once != _arg_2)
                {
                    throw (new IllegalOperationError("You cannot addOnce() then add() the same listener without removing the relationship first."));
                };
                return (false);
            };
            return (true);
        }


    }
}//package org.osflash.signals.natives

