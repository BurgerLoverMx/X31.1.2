// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.eventCommandMap.EventCommandMapExtension

package robotlegs.bender.extensions.eventCommandMap
{
    import robotlegs.bender.framework.api.IExtension;
    import robotlegs.bender.framework.impl.UID;
    import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
    import robotlegs.bender.extensions.eventCommandMap.impl.EventCommandMap;
    import robotlegs.bender.framework.api.IContext;

    public class EventCommandMapExtension implements IExtension 
    {

        private const _uid:String = UID.create(EventCommandMapExtension);


        public function extend(_arg_1:IContext):void
        {
            _arg_1.injector.map(IEventCommandMap).toSingleton(EventCommandMap);
        }

        public function toString():String
        {
            return (this._uid);
        }


    }
}//package robotlegs.bender.extensions.eventCommandMap

