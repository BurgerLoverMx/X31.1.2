// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.viewManager.api.IViewManager

package robotlegs.bender.extensions.viewManager.api
{
    import flash.events.IEventDispatcher;
    import __AS3__.vec.Vector;
    import flash.display.DisplayObjectContainer;

    public interface IViewManager extends IEventDispatcher 
    {

        function get containers():Vector.<DisplayObjectContainer>;
        function addContainer(_arg_1:DisplayObjectContainer):void;
        function removeContainer(_arg_1:DisplayObjectContainer):void;
        function addViewHandler(_arg_1:IViewHandler):void;
        function removeViewHandler(_arg_1:IViewHandler):void;
        function removeAllHandlers():void;

    }
}//package robotlegs.bender.extensions.viewManager.api

