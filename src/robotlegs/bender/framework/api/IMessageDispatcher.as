// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.framework.api.IMessageDispatcher

package robotlegs.bender.framework.api
{
    public interface IMessageDispatcher 
    {

        function addMessageHandler(_arg_1:Object, _arg_2:Function):void;
        function removeMessageHandler(_arg_1:Object, _arg_2:Function):void;
        function hasMessageHandler(_arg_1:Object):Boolean;
        function dispatchMessage(_arg_1:Object, _arg_2:Function=null, _arg_3:Boolean=false):void;

    }
}//package robotlegs.bender.framework.api

