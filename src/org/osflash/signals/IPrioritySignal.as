// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.osflash.signals.IPrioritySignal

package org.osflash.signals
{
    public interface IPrioritySignal extends ISignal 
    {

        function addWithPriority(_arg_1:Function, _arg_2:int=0):ISlot;
        function addOnceWithPriority(_arg_1:Function, _arg_2:int=0):ISlot;

    }
}//package org.osflash.signals

