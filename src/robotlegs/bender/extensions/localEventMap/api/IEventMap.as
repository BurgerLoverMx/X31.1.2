// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.localEventMap.api.IEventMap

package robotlegs.bender.extensions.localEventMap.api
{
    import flash.events.IEventDispatcher;

    public interface IEventMap 
    {

        function mapListener(_arg_1:IEventDispatcher, _arg_2:String, _arg_3:Function, _arg_4:Class=null, _arg_5:Boolean=false, _arg_6:int=0, _arg_7:Boolean=true):void;
        function unmapListener(_arg_1:IEventDispatcher, _arg_2:String, _arg_3:Function, _arg_4:Class=null, _arg_5:Boolean=false):void;
        function unmapListeners():void;
        function suspend():void;
        function resume():void;

    }
}//package robotlegs.bender.extensions.localEventMap.api

