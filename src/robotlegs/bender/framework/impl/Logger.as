// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.framework.impl.Logger

package robotlegs.bender.framework.impl
{
    import robotlegs.bender.framework.api.ILogger;
    import robotlegs.bender.framework.api.ILogTarget;
    import flash.utils.getTimer;

    public class Logger implements ILogger 
    {

        private var _source:Object;
        private var _target:ILogTarget;

        public function Logger(_arg_1:Object, _arg_2:ILogTarget)
        {
            this._source = _arg_1;
            this._target = _arg_2;
        }

        public function debug(_arg_1:*, _arg_2:Array=null):void
        {
            this._target.log(this._source, 32, getTimer(), _arg_1, _arg_2);
        }

        public function info(_arg_1:*, _arg_2:Array=null):void
        {
            this._target.log(this._source, 16, getTimer(), _arg_1, _arg_2);
        }

        public function warn(_arg_1:*, _arg_2:Array=null):void
        {
            this._target.log(this._source, 8, getTimer(), _arg_1, _arg_2);
        }

        public function error(_arg_1:*, _arg_2:Array=null):void
        {
            this._target.log(this._source, 4, getTimer(), _arg_1, _arg_2);
        }

        public function fatal(_arg_1:*, _arg_2:Array=null):void
        {
            this._target.log(this._source, 2, getTimer(), _arg_1, _arg_2);
        }


    }
}//package robotlegs.bender.framework.impl

