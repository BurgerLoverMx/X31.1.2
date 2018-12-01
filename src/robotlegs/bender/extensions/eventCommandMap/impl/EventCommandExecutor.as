// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.eventCommandMap.impl.EventCommandExecutor

package robotlegs.bender.extensions.eventCommandMap.impl
{
    import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
    import __AS3__.vec.Vector;
    import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
    import robotlegs.bender.extensions.commandCenter.impl.CommandMappingList;
    import org.swiftsuspenders.Injector;
    import flash.events.Event;

    public class EventCommandExecutor 
    {

        private var _trigger:ICommandTrigger;
        private var _mappings:Vector.<ICommandMapping>;
        private var _mappingList:CommandMappingList;
        private var _injector:Injector;
        private var _eventClass:Class;
        private var _factory:EventCommandFactory;

        public function EventCommandExecutor(_arg_1:ICommandTrigger, _arg_2:CommandMappingList, _arg_3:Injector, _arg_4:Class)
        {
            this._trigger = _arg_1;
            this._mappingList = _arg_2;
            this._injector = _arg_3.createChildInjector();
            this._eventClass = _arg_4;
            this._factory = new EventCommandFactory(this._injector);
        }

        public function execute(_arg_1:Event):void
        {
            var _local_2:Class = (_arg_1["constructor"] as Class);
            if (this.isTriggerEvent(_local_2))
            {
                this.runCommands(_arg_1, _local_2);
            };
        }

        private function isTriggerEvent(_arg_1:Class):Boolean
        {
            return ((!(this._eventClass)) || (_arg_1 == this._eventClass));
        }

        private function isStronglyTyped(_arg_1:Class):Boolean
        {
            return (!(_arg_1 == Event));
        }

        private function mapEventForInjection(_arg_1:Event, _arg_2:Class):void
        {
            this._injector.map(Event).toValue(_arg_1);
            if (this.isStronglyTyped(_arg_2))
            {
                this._injector.map(((this._eventClass) || (_arg_2))).toValue(_arg_1);
            };
        }

        private function unmapEventAfterInjection(_arg_1:Class):void
        {
            this._injector.unmap(Event);
            if (this.isStronglyTyped(_arg_1))
            {
                this._injector.unmap(((this._eventClass) || (_arg_1)));
            };
        }

        private function runCommands(_arg_1:Event, _arg_2:Class):void
        {
            var _local_3:Object;
            var _local_4:ICommandMapping = this._mappingList.head;
            while (_local_4)
            {
                _local_4.validate();
                this.mapEventForInjection(_arg_1, _arg_2);
                _local_3 = this._factory.create(_local_4);
                this.unmapEventAfterInjection(_arg_2);
                if (_local_3)
                {
                    this.removeFireOnceMapping(_local_4);
                    _local_3.execute();
                };
                _local_4 = _local_4.next;
            };
        }

        private function removeFireOnceMapping(_arg_1:ICommandMapping):void
        {
            if (_arg_1.fireOnce)
            {
                this._trigger.removeMapping(_arg_1);
            };
        }


    }
}//package robotlegs.bender.extensions.eventCommandMap.impl

