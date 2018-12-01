// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.mediatorMap.api.IMediatorViewHandler

package robotlegs.bender.extensions.mediatorMap.api
{
    import robotlegs.bender.extensions.viewManager.api.IViewHandler;

    public interface IMediatorViewHandler extends IViewHandler 
    {

        function addMapping(_arg_1:IMediatorMapping):void;
        function removeMapping(_arg_1:IMediatorMapping):void;
        function handleItem(_arg_1:Object, _arg_2:Class):void;

    }
}//package robotlegs.bender.extensions.mediatorMap.api

