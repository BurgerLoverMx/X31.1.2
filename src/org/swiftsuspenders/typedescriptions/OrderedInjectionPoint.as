// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.swiftsuspenders.typedescriptions.OrderedInjectionPoint

package org.swiftsuspenders.typedescriptions
{
    public class OrderedInjectionPoint extends MethodInjectionPoint 
    {

        public var order:int;

        public function OrderedInjectionPoint(_arg_1:String, _arg_2:Array, _arg_3:uint, _arg_4:int)
        {
            super(_arg_1, _arg_2, _arg_3, false, null);
            this.order = _arg_4;
        }

    }
}//package org.swiftsuspenders.typedescriptions

