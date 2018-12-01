// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.logging.TraceLoggingExtension

package robotlegs.bender.extensions.logging
{
    import robotlegs.bender.framework.api.IExtension;
    import robotlegs.bender.framework.impl.UID;
    import robotlegs.bender.extensions.logging.impl.TraceLogTarget;
    import robotlegs.bender.framework.api.IContext;

    public class TraceLoggingExtension implements IExtension 
    {

        private const _uid:String = UID.create(TraceLoggingExtension);


        public function extend(_arg_1:IContext):void
        {
            _arg_1.addLogTarget(new TraceLogTarget(_arg_1));
        }

        public function toString():String
        {
            return (this._uid);
        }


    }
}//package robotlegs.bender.extensions.logging

