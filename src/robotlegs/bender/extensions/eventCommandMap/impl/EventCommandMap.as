// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.eventCommandMap.impl.EventCommandMap

package robotlegs.bender.extensions.eventCommandMap.impl
{
    import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
    import flash.utils.Dictionary;
    import org.swiftsuspenders.Injector;
    import flash.events.IEventDispatcher;
    import robotlegs.bender.extensions.commandCenter.api.ICommandCenter;
    import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
    import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
    import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;

    public class EventCommandMap implements IEventCommandMap 
    {

        private const _triggers:Dictionary = new Dictionary();

        private var _injector:Injector;
        private var _dispatcher:IEventDispatcher;
        private var _commandCenter:ICommandCenter;

        public function EventCommandMap(_arg_1:Injector, _arg_2:IEventDispatcher, _arg_3:ICommandCenter)
        {
            this._injector = _arg_1;
            this._dispatcher = _arg_2;
            this._commandCenter = _arg_3;
        }

        public function map(_arg_1:String, _arg_2:Class=null):ICommandMapper
        {
            var _local_3:ICommandTrigger = (this._triggers[(_arg_1 + _arg_2)] = ((this._triggers[(_arg_1 + _arg_2)]) || (this.createTrigger(_arg_1, _arg_2))));
            return (this._commandCenter.map(_local_3));
        }

        public function unmap(_arg_1:String, _arg_2:Class=null):ICommandUnmapper
        {
            return (this._commandCenter.unmap(this.getTrigger(_arg_1, _arg_2)));
        }

        private function createTrigger(_arg_1:String, _arg_2:Class=null):ICommandTrigger
        {
            return (new EventCommandTrigger(this._injector, this._dispatcher, _arg_1, _arg_2));
        }

        private function getTrigger(_arg_1:String, _arg_2:Class=null):ICommandTrigger
        {
            return (this._triggers[(_arg_1 + _arg_2)]);
        }


    }
}//package robotlegs.bender.extensions.eventCommandMap.impl

