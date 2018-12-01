// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.commandCenter.CommandCenterExtension

package robotlegs.bender.extensions.commandCenter
{
    import robotlegs.bender.framework.api.IExtension;
    import robotlegs.bender.framework.impl.UID;
    import robotlegs.bender.extensions.commandCenter.api.ICommandCenter;
    import robotlegs.bender.extensions.commandCenter.impl.CommandCenter;
    import robotlegs.bender.framework.api.IContext;

    public class CommandCenterExtension implements IExtension 
    {

        private const _uid:String = UID.create(CommandCenterExtension);


        public function extend(_arg_1:IContext):void
        {
            _arg_1.injector.map(ICommandCenter).toSingleton(CommandCenter);
        }

        public function toString():String
        {
            return (this._uid);
        }


    }
}//package robotlegs.bender.extensions.commandCenter

