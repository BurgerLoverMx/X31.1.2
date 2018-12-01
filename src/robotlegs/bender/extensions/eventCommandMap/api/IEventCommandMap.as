// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap

package robotlegs.bender.extensions.eventCommandMap.api
{
    import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
    import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;

    public interface IEventCommandMap 
    {

        function map(_arg_1:String, _arg_2:Class=null):ICommandMapper;
        function unmap(_arg_1:String, _arg_2:Class=null):ICommandUnmapper;

    }
}//package robotlegs.bender.extensions.eventCommandMap.api

