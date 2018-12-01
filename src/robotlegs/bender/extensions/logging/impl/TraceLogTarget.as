// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.logging.impl.TraceLogTarget

package robotlegs.bender.extensions.logging.impl
{
    import robotlegs.bender.framework.api.ILogTarget;
    import robotlegs.bender.framework.api.IContext;
    import robotlegs.bender.framework.api.LogLevel;

    public class TraceLogTarget implements ILogTarget 
    {

        private const _messageParser:LogMessageParser = new LogMessageParser();

        private var _context:IContext;

        public function TraceLogTarget(_arg_1:IContext)
        {
            this._context = _arg_1;
        }

        public function log(_arg_1:Object, _arg_2:uint, _arg_3:int, _arg_4:String, _arg_5:Array=null):void
        {
            trace(((((((((_arg_3 + " ") + LogLevel.NAME[_arg_2]) + " ") + this._context) + " ") + _arg_1) + " - ") + this._messageParser.parseMessage(_arg_4, _arg_5)));
        }


    }
}//package robotlegs.bender.extensions.logging.impl

