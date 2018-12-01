// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.osflash.signals.OnceSignal

package org.osflash.signals
{
    import flash.utils.getQualifiedClassName;
    import flash.errors.IllegalOperationError;

    public class OnceSignal implements IOnceSignal 
    {

        protected var _valueClasses:Array;
        protected var slots:SlotList = SlotList.NIL;

        public function OnceSignal(... _args)
        {
            this.valueClasses = (((_args.length == 1) && (_args[0] is Array)) ? _args[0] : _args);
        }

        [ArrayElementType("Class")]
        public function get valueClasses():Array
        {
            return (this._valueClasses);
        }

        public function set valueClasses(_arg_1:Array):void
        {
            this._valueClasses = ((_arg_1) ? _arg_1.slice() : []);
            var _local_2:int = this._valueClasses.length;
            while (_local_2--)
            {
                if (!(this._valueClasses[_local_2] is Class))
                {
                    throw (new ArgumentError((((((("Invalid valueClasses argument: " + "item at index ") + _local_2) + " should be a Class but was:<") + this._valueClasses[_local_2]) + ">.") + getQualifiedClassName(this._valueClasses[_local_2]))));
                };
            };
        }

        public function get numListeners():uint
        {
            return (this.slots.length);
        }

        public function addOnce(_arg_1:Function):ISlot
        {
            return (this.registerListener(_arg_1, true));
        }

        public function remove(_arg_1:Function):ISlot
        {
            var _local_2:ISlot = this.slots.find(_arg_1);
            if (!_local_2)
            {
                return (null);
            };
            this.slots = this.slots.filterNot(_arg_1);
            return (_local_2);
        }

        public function removeAll():void
        {
            this.slots = SlotList.NIL;
        }

        public function dispatch(... _args):void
        {
            var _local_2:int = this._valueClasses.length;
            var _local_3:int = _args.length;
            if (_local_3 < _local_2)
            {
                throw (new ArgumentError(((((("Incorrect number of arguments. " + "Expected at least ") + _local_2) + " but received ") + _local_3) + ".")));
            };
            var _local_4:int;
            while (_local_4 < _local_2)
            {
                if (!((_args[_local_4] is this._valueClasses[_local_4]) || (_args[_local_4] === null)))
                {
                    throw (new ArgumentError((((("Value object <" + _args[_local_4]) + "> is not an instance of <") + this._valueClasses[_local_4]) + ">.")));
                };
                _local_4++;
            };
            var _local_5:SlotList = this.slots;
            if (_local_5.nonEmpty)
            {
                while (_local_5.nonEmpty)
                {
                    _local_5.head.execute(_args);
                    _local_5 = _local_5.tail;
                };
            };
        }

        protected function registerListener(_arg_1:Function, _arg_2:Boolean=false):ISlot
        {
            var _local_3:ISlot;
            if (this.registrationPossible(_arg_1, _arg_2))
            {
                _local_3 = new Slot(_arg_1, this, _arg_2);
                this.slots = this.slots.prepend(_local_3);
                return (_local_3);
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
            if (!_local_3)
            {
                return (true);
            };
            if (_local_3.once != _arg_2)
            {
                throw (new IllegalOperationError("You cannot addOnce() then add() the same listener without removing the relationship first."));
            };
            return (false);
        }


    }
}//package org.osflash.signals

