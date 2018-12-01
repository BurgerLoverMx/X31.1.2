// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.eventCommandMap.impl.EventCommandFactory

package robotlegs.bender.extensions.eventCommandMap.impl
{
    import org.swiftsuspenders.Injector;
    import robotlegs.bender.framework.impl.guardsApprove;
    import robotlegs.bender.framework.impl.applyHooks;
    import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;

    public class EventCommandFactory 
    {

        private var _injector:Injector;

        public function EventCommandFactory(_arg_1:Injector)
        {
            this._injector = _arg_1;
        }

        public function create(_arg_1:ICommandMapping):Object
        {
            var _local_2:Class;
            var _local_3:Object;
            if (guardsApprove(_arg_1.guards, this._injector))
            {
                _local_2 = _arg_1.commandClass;
                this._injector.map(_local_2).asSingleton();
                _local_3 = this._injector.getInstance(_local_2);
                applyHooks(_arg_1.hooks, this._injector);
                this._injector.unmap(_local_2);
                return (_local_3);
            };
            return (null);
        }


    }
}//package robotlegs.bender.extensions.eventCommandMap.impl

