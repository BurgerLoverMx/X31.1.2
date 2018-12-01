// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.signalCommandMap.impl.SignalCommandTrigger

package robotlegs.bender.extensions.signalCommandMap.impl
{
    import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
    import __AS3__.vec.Vector;
    import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
    import org.osflash.signals.ISignal;
    import org.swiftsuspenders.Injector;
    import flash.utils.Dictionary;
    import flash.utils.describeType;
    import robotlegs.bender.framework.impl.guardsApprove;
    import robotlegs.bender.framework.impl.applyHooks;
    import __AS3__.vec.*;

    public class SignalCommandTrigger implements ICommandTrigger 
    {

        private const _mappings:Vector.<ICommandMapping> = new Vector.<ICommandMapping>();

        private var _signal:ISignal;
        private var _signalClass:Class;
        private var _once:Boolean;
        protected var _injector:Injector;
        protected var _signalMap:Dictionary;
        protected var _verifiedCommandClasses:Dictionary;

        public function SignalCommandTrigger(_arg_1:Injector, _arg_2:Class, _arg_3:Boolean=false)
        {
            this._injector = _arg_1;
            this._signalClass = _arg_2;
            this._once = _arg_3;
            this._signalMap = new Dictionary(false);
            this._verifiedCommandClasses = new Dictionary(false);
        }

        public function addMapping(_arg_1:ICommandMapping):void
        {
            this.verifyCommandClass(_arg_1);
            this._mappings.push(_arg_1);
            if (this._mappings.length == 1)
            {
                this.addSignal(_arg_1.commandClass);
            };
        }

        public function removeMapping(_arg_1:ICommandMapping):void
        {
            var _local_2:int = this._mappings.indexOf(_arg_1);
            if (_local_2 != -1)
            {
                this._mappings.splice(_local_2, 1);
                if (this._mappings.length == 0)
                {
                    this.removeSignal(_arg_1.commandClass);
                };
            };
        }

        protected function verifyCommandClass(mapping:ICommandMapping):void
        {
            if (this._verifiedCommandClasses[mapping.commandClass])
            {
                return;
            };
            if (describeType(mapping.commandClass).factory.method.(@name == "execute").length() == 0)
            {
                throw (new Error("Command Class must expose an execute method"));
            };
            this._verifiedCommandClasses[mapping.commandClass] = true;
        }

        protected function routeSignalToCommand(_arg_1:ISignal, _arg_2:Array, _arg_3:Class, _arg_4:Boolean):void
        {
            var _local_6:ICommandMapping;
            var _local_7:Boolean;
            var _local_8:Object;
            var _local_5:Vector.<ICommandMapping> = this._mappings.concat();
            for each (_local_6 in _local_5)
            {
                this.mapSignalValues(_arg_1.valueClasses, _arg_2);
                _local_7 = guardsApprove(_local_6.guards, this._injector);
                if (_local_7)
                {
                    ((this._once) && (this.removeMapping(_local_6)));
                    this._injector.map(_local_6.commandClass).asSingleton();
                    _local_8 = this._injector.getInstance(_local_6.commandClass);
                    applyHooks(_local_6.hooks, this._injector);
                    this._injector.unmap(_local_6.commandClass);
                };
                this.unmapSignalValues(_arg_1.valueClasses, _arg_2);
                if (_local_7)
                {
                    _local_8.execute();
                };
            };
            if (this._once)
            {
                this.removeSignal(_arg_3);
            };
        }

        protected function mapSignalValues(_arg_1:Array, _arg_2:Array):void
        {
            var _local_3:uint;
            while (_local_3 < _arg_1.length)
            {
                this._injector.map(_arg_1[_local_3]).toValue(_arg_2[_local_3]);
                _local_3++;
            };
        }

        protected function unmapSignalValues(_arg_1:Array, _arg_2:Array):void
        {
            var _local_3:uint;
            while (_local_3 < _arg_1.length)
            {
                this._injector.unmap(_arg_1[_local_3]);
                _local_3++;
            };
        }

        protected function hasSignalCommand(_arg_1:ISignal, _arg_2:Class):Boolean
        {
            var _local_3:Dictionary = this._signalMap[_arg_1];
            if (_local_3 == null)
            {
                return (false);
            };
            var _local_4:Function = _local_3[_arg_2];
            return (!(_local_4 == null));
        }

        private function addSignal(commandClass:Class):void
        {
            if (this.hasSignalCommand(this._signal, commandClass))
            {
                return;
            };
            this._signal = this._injector.getInstance(this._signalClass);
            this._injector.map(this._signalClass).toValue(this._signal);
            var signalCommandMap:Dictionary = (this._signalMap[this._signal] = ((this._signalMap[this._signal]) || (new Dictionary(false))));
            var callback:Function = function ():void
            {
                routeSignalToCommand(_signal, arguments, commandClass, _once);
            };
            signalCommandMap[commandClass] = callback;
            this._signal.add(callback);
        }

        private function removeSignal(_arg_1:Class):void
        {
            var _local_2:Dictionary = this._signalMap[this._signal];
            if (_local_2 == null)
            {
                return;
            };
            var _local_3:Function = _local_2[_arg_1];
            if (_local_3 == null)
            {
                return;
            };
            this._signal.remove(_local_3);
            delete _local_2[_arg_1];
        }


    }
}//package robotlegs.bender.extensions.signalCommandMap.impl

