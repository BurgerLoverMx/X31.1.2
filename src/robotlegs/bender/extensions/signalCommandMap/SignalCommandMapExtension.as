// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.signalCommandMap.SignalCommandMapExtension

package robotlegs.bender.extensions.signalCommandMap
{
    import robotlegs.bender.framework.api.IExtension;
    import robotlegs.bender.framework.impl.UID;
    import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
    import robotlegs.bender.extensions.signalCommandMap.impl.SignalCommandMap;
    import robotlegs.bender.framework.api.IContext;

    public class SignalCommandMapExtension implements IExtension 
    {

        private const _uid:String = UID.create(SignalCommandMapExtension);


        public function extend(_arg_1:IContext):void
        {
            _arg_1.injector.map(ISignalCommandMap).toSingleton(SignalCommandMap);
        }

        public function toString():String
        {
            return (this._uid);
        }


    }
}//package robotlegs.bender.extensions.signalCommandMap

