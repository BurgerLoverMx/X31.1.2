// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap

package robotlegs.bender.extensions.signalCommandMap.api
{
    import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
    import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;

    public interface ISignalCommandMap 
    {

        function map(_arg_1:Class, _arg_2:Boolean=false):ICommandMapper;
        function unmap(_arg_1:Class):ICommandUnmapper;

    }
}//package robotlegs.bender.extensions.signalCommandMap.api

