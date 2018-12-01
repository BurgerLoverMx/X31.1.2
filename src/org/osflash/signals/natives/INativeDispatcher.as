// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.osflash.signals.natives.INativeDispatcher

package org.osflash.signals.natives
{
    import org.osflash.signals.IPrioritySignal;
    import flash.events.IEventDispatcher;
    import flash.events.Event;

    public interface INativeDispatcher extends IPrioritySignal 
    {

        function get eventType():String;
        function get eventClass():Class;
        function get target():IEventDispatcher;
        function set target(_arg_1:IEventDispatcher):void;
        function dispatchEvent(_arg_1:Event):Boolean;

    }
}//package org.osflash.signals.natives

