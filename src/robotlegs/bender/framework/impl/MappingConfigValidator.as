// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.framework.impl.MappingConfigValidator

package robotlegs.bender.framework.impl
{
    import robotlegs.bender.framework.api.MappingConfigError;

    public class MappingConfigValidator 
    {

        private const CANT_CHANGE_GUARDS_AND_HOOKS:String = "You can't change the guards and hooks on an existing mapping. Unmap first.";
        private const STORED_ERROR_EXPLANATION:String = " The stacktrace for this error was stored at the time when you duplicated the mapping - you may have failed to add guards and hooks that were already present.";

        private var _guards:Array;
        private var _hooks:Array;
        private var _trigger:*;
        private var _action:*;
        private var _storedError:MappingConfigError;
        private var _valid:Boolean = false;

        public function MappingConfigValidator(_arg_1:Array, _arg_2:Array, _arg_3:*, _arg_4:*)
        {
            this._guards = _arg_1;
            this._hooks = _arg_2;
            this._trigger = _arg_3;
            this._action = _arg_4;
            super();
        }

        public function get valid():Boolean
        {
            return (this._valid);
        }

        public function invalidate():void
        {
            this._valid = false;
            this._storedError = new MappingConfigError((this.CANT_CHANGE_GUARDS_AND_HOOKS + this.STORED_ERROR_EXPLANATION), this._trigger, this._action);
        }

        public function validate(_arg_1:Array, _arg_2:Array):void
        {
            if (((!(this.arraysMatch(this._guards, _arg_1))) || (!(this.arraysMatch(this._hooks, _arg_2)))))
            {
                ((this.throwStoredError()) || (this.throwMappingError()));
            };
            this._valid = true;
            this._storedError = null;
        }

        public function checkGuards(_arg_1:Array):void
        {
            if (this.changesContent(this._guards, _arg_1))
            {
                this.throwMappingError();
            };
        }

        public function checkHooks(_arg_1:Array):void
        {
            if (this.changesContent(this._hooks, _arg_1))
            {
                this.throwMappingError();
            };
        }

        private function changesContent(_arg_1:Array, _arg_2:Array):Boolean
        {
            var _local_3:*;
            _arg_2 = this.flatten(_arg_2);
            for each (_local_3 in _arg_2)
            {
                if (_arg_1.indexOf(_local_3) == -1)
                {
                    return (true);
                };
            };
            return (false);
        }

        private function arraysMatch(_arg_1:Array, _arg_2:Array):Boolean
        {
            var _local_3:int;
            _arg_1 = _arg_1.slice();
            if (_arg_1.length != _arg_2.length)
            {
                return (false);
            };
            var _local_4:uint = _arg_2.length;
            var _local_5:uint;
            while (_local_5 < _local_4)
            {
                _local_3 = _arg_1.indexOf(_arg_2[_local_5]);
                if (_local_3 == -1)
                {
                    return (false);
                };
                _arg_1.splice(_local_3, 1);
                _local_5++;
            };
            return (true);
        }

        public function flatten(_arg_1:Array):Array
        {
            var _local_3:*;
            var _local_2:Array = [];
            for each (_local_3 in _arg_1)
            {
                if ((_local_3 is Array))
                {
                    _local_2 = _local_2.concat(this.flatten((_local_3 as Array)));
                }
                else
                {
                    _local_2.push(_local_3);
                };
            };
            return (_local_2);
        }

        private function throwMappingError():void
        {
            throw (new MappingConfigError(this.CANT_CHANGE_GUARDS_AND_HOOKS, this._trigger, this._action));
        }

        private function throwStoredError():Boolean
        {
            if (this._storedError)
            {
                throw (this._storedError);
            };
            return (false);
        }


    }
}//package robotlegs.bender.framework.impl

