// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.logging.LoggingExtension

package robotlegs.bender.extensions.logging
{
    import robotlegs.bender.framework.api.IExtension;
    import robotlegs.bender.framework.impl.UID;
    import robotlegs.bender.framework.api.ILogger;
    import robotlegs.bender.extensions.logging.integration.LoggerProvider;
    import robotlegs.bender.framework.api.IContext;

    public class LoggingExtension implements IExtension 
    {

        private const _uid:String = UID.create(LoggingExtension);


        public function extend(_arg_1:IContext):void
        {
            _arg_1.injector.map(ILogger).toProvider(new LoggerProvider(_arg_1));
        }

        public function toString():String
        {
            return (this._uid);
        }


    }
}//package robotlegs.bender.extensions.logging

