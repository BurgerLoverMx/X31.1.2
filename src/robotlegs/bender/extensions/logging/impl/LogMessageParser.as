// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.logging.impl.LogMessageParser

package robotlegs.bender.extensions.logging.impl
{
    public class LogMessageParser 
    {


        public function parseMessage(_arg_1:String, _arg_2:Array):String
        {
            var _local_3:int;
            var _local_4:int;
            if (_arg_2)
            {
                _local_3 = _arg_2.length;
                _local_4 = 0;
                while (_local_4 < _local_3)
                {
                    _arg_1 = _arg_1.split((("{" + _local_4) + "}")).join(_arg_2[_local_4]);
                    _local_4++;
                };
            };
            return (_arg_1);
        }


    }
}//package robotlegs.bender.extensions.logging.impl

