// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.framework.api.IContext

package robotlegs.bender.framework.api
{
    import org.swiftsuspenders.Injector;
    import org.hamcrest.Matcher;

    public interface IContext 
    {

        function get injector():Injector;
        function get lifecycle():ILifecycle;
        function get logLevel():uint;
        function set logLevel(_arg_1:uint):void;
        function extend(... _args):IContext;
        function configure(... _args):IContext;
        function addConfigHandler(_arg_1:Matcher, _arg_2:Function):IContext;
        function getLogger(_arg_1:Object):ILogger;
        function addLogTarget(_arg_1:ILogTarget):IContext;
        function detain(... _args):IContext;
        function release(... _args):IContext;

    }
}//package robotlegs.bender.framework.api

