// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.framework.api.ILifecycle

package robotlegs.bender.framework.api
{
    import flash.events.IEventDispatcher;

    public interface ILifecycle extends IEventDispatcher 
    {

        function get state():String;
        function get target():Object;
        function get initialized():Boolean;
        function get active():Boolean;
        function get suspended():Boolean;
        function get destroyed():Boolean;
        function initialize(_arg_1:Function=null):void;
        function suspend(_arg_1:Function=null):void;
        function resume(_arg_1:Function=null):void;
        function destroy(_arg_1:Function=null):void;
        function beforeInitializing(_arg_1:Function):ILifecycle;
        function whenInitializing(_arg_1:Function):ILifecycle;
        function afterInitializing(_arg_1:Function):ILifecycle;
        function beforeSuspending(_arg_1:Function):ILifecycle;
        function whenSuspending(_arg_1:Function):ILifecycle;
        function afterSuspending(_arg_1:Function):ILifecycle;
        function beforeResuming(_arg_1:Function):ILifecycle;
        function whenResuming(_arg_1:Function):ILifecycle;
        function afterResuming(_arg_1:Function):ILifecycle;
        function beforeDestroying(_arg_1:Function):ILifecycle;
        function whenDestroying(_arg_1:Function):ILifecycle;
        function afterDestroying(_arg_1:Function):ILifecycle;

    }
}//package robotlegs.bender.framework.api

