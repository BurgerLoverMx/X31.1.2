// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.mediatorMap.api.IMediatorFactory

package robotlegs.bender.extensions.mediatorMap.api
{
    import flash.events.IEventDispatcher;

    public interface IMediatorFactory extends IEventDispatcher 
    {

        function getMediator(_arg_1:Object, _arg_2:IMediatorMapping):Object;
        function createMediators(_arg_1:Object, _arg_2:Class, _arg_3:Array):Array;
        function removeMediators(_arg_1:Object):void;
        function removeAllMediators():void;

    }
}//package robotlegs.bender.extensions.mediatorMap.api

