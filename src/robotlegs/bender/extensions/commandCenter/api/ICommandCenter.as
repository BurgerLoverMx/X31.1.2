// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.commandCenter.api.ICommandCenter

package robotlegs.bender.extensions.commandCenter.api
{
    import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
    import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;

    public interface ICommandCenter 
    {

        function map(_arg_1:ICommandTrigger):ICommandMapper;
        function unmap(_arg_1:ICommandTrigger):ICommandUnmapper;

    }
}//package robotlegs.bender.extensions.commandCenter.api

