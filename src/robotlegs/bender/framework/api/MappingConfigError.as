// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.framework.api.MappingConfigError

package robotlegs.bender.framework.api
{
    public class MappingConfigError extends Error 
    {

        private var _trigger:Object;
        private var _action:Object;

        public function MappingConfigError(_arg_1:String, _arg_2:*, _arg_3:*)
        {
            super(_arg_1);
            this._trigger = _arg_2;
            this._action = _arg_3;
        }

        public function get trigger():Object
        {
            return (this._trigger);
        }

        public function get action():Object
        {
            return (this._action);
        }


    }
}//package robotlegs.bender.framework.api

