// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.framework.impl.LogManager

package robotlegs.bender.framework.impl
{
    import robotlegs.bender.framework.api.ILogTarget;
    import __AS3__.vec.Vector;
    import robotlegs.bender.framework.api.ILogger;
    import __AS3__.vec.*;

    public class LogManager implements ILogTarget 
    {

        private const _targets:Vector.<ILogTarget> = new Vector.<ILogTarget>();

        private var _logLevel:uint = 16;


        public function get logLevel():uint
        {
            return (this._logLevel);
        }

        public function set logLevel(_arg_1:uint):void
        {
            this._logLevel = _arg_1;
        }

        public function getLogger(_arg_1:Object):ILogger
        {
            return (new Logger(_arg_1, this));
        }

        public function addLogTarget(_arg_1:ILogTarget):void
        {
            this._targets.push(_arg_1);
        }

        public function log(_arg_1:Object, _arg_2:uint, _arg_3:int, _arg_4:String, _arg_5:Array=null):void
        {
            var _local_6:ILogTarget;
            if (_arg_2 > this._logLevel)
            {
                return;
            };
            for each (_local_6 in this._targets)
            {
                _local_6.log(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
            };
        }


    }
}//package robotlegs.bender.framework.impl

