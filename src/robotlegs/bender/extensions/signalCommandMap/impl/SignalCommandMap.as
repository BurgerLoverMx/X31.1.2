// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.signalCommandMap.impl.SignalCommandMap

package robotlegs.bender.extensions.signalCommandMap.impl
{
    import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
    import flash.utils.Dictionary;
    import org.swiftsuspenders.Injector;
    import robotlegs.bender.extensions.commandCenter.api.ICommandCenter;
    import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
    import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
    import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;

    public class SignalCommandMap implements ISignalCommandMap 
    {

        private const _signalTriggers:Dictionary = new Dictionary();

        private var _injector:Injector;
        private var _commandMap:ICommandCenter;

        public function SignalCommandMap(_arg_1:Injector, _arg_2:ICommandCenter)
        {
            this._injector = _arg_1;
            this._commandMap = _arg_2;
        }

        public function map(_arg_1:Class, _arg_2:Boolean=false):ICommandMapper
        {
            var _local_3:ICommandTrigger = (this._signalTriggers[_arg_1] = ((this._signalTriggers[_arg_1]) || (this.createSignalTrigger(_arg_1, _arg_2))));
            return (this._commandMap.map(_local_3));
        }

        public function unmap(_arg_1:Class):ICommandUnmapper
        {
            return (this._commandMap.unmap(this.getSignalTrigger(_arg_1)));
        }

        private function createSignalTrigger(_arg_1:Class, _arg_2:Boolean=false):ICommandTrigger
        {
            return (new SignalCommandTrigger(this._injector, _arg_1, _arg_2));
        }

        private function getSignalTrigger(_arg_1:Class):ICommandTrigger
        {
            return (this._signalTriggers[_arg_1]);
        }


    }
}//package robotlegs.bender.extensions.signalCommandMap.impl

