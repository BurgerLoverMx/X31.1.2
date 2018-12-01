// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.osflash.signals.Signal

package org.osflash.signals
{
    public class Signal extends OnceSignal implements ISignal 
    {

        public function Signal(... _args)
        {
            _args = (((_args.length == 1) && (_args[0] is Array)) ? _args[0] : _args);
            super(_args);
        }

        public function add(_arg_1:Function):ISlot
        {
            return (registerListener(_arg_1));
        }


    }
}//package org.osflash.signals

