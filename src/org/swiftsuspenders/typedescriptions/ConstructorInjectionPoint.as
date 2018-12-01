// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.swiftsuspenders.typedescriptions.ConstructorInjectionPoint

package org.swiftsuspenders.typedescriptions
{
    import flash.utils.Dictionary;
    import org.swiftsuspenders.Injector;

    public class ConstructorInjectionPoint extends MethodInjectionPoint 
    {

        public function ConstructorInjectionPoint(_arg_1:Array, _arg_2:uint, _arg_3:Dictionary)
        {
            super("ctor", _arg_1, _arg_2, false, _arg_3);
        }

        public function createInstance(_arg_1:Class, _arg_2:Injector):Object
        {
            var _local_4:Object;
            var _local_3:Array = gatherParameterValues(_arg_1, _arg_1, _arg_2);
            switch (_local_3.length)
            {
                case 1:
                    _local_4 = new _arg_1(_local_3[0]);
                    break;
                case 2:
                    _local_4 = new _arg_1(_local_3[0], _local_3[1]);
                    break;
                case 3:
                    _local_4 = new _arg_1(_local_3[0], _local_3[1], _local_3[2]);
                    break;
                case 4:
                    _local_4 = new _arg_1(_local_3[0], _local_3[1], _local_3[2], _local_3[3]);
                    break;
                case 5:
                    _local_4 = new _arg_1(_local_3[0], _local_3[1], _local_3[2], _local_3[3], _local_3[4]);
                    break;
                case 6:
                    _local_4 = new _arg_1(_local_3[0], _local_3[1], _local_3[2], _local_3[3], _local_3[4], _local_3[5]);
                    break;
                case 7:
                    _local_4 = new _arg_1(_local_3[0], _local_3[1], _local_3[2], _local_3[3], _local_3[4], _local_3[5], _local_3[6]);
                    break;
                case 8:
                    _local_4 = new _arg_1(_local_3[0], _local_3[1], _local_3[2], _local_3[3], _local_3[4], _local_3[5], _local_3[6], _local_3[7]);
                    break;
                case 9:
                    _local_4 = new _arg_1(_local_3[0], _local_3[1], _local_3[2], _local_3[3], _local_3[4], _local_3[5], _local_3[6], _local_3[7], _local_3[8]);
                    break;
                case 10:
                    _local_4 = new _arg_1(_local_3[0], _local_3[1], _local_3[2], _local_3[3], _local_3[4], _local_3[5], _local_3[6], _local_3[7], _local_3[8], _local_3[9]);
                    break;
            };
            _local_3.length = 0;
            return (_local_4);
        }


    }
}//package org.swiftsuspenders.typedescriptions

