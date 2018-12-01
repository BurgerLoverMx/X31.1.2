// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.commandCenter.impl.CommandCenter

package robotlegs.bender.extensions.commandCenter.impl
{
    import robotlegs.bender.extensions.commandCenter.api.ICommandCenter;
    import flash.utils.Dictionary;
    import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;
    import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
    import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;

    public class CommandCenter implements ICommandCenter 
    {

        private const _mappers:Dictionary = new Dictionary();
        private const NULL_UNMAPPER:ICommandUnmapper = new NullCommandUnmapper();


        public function map(_arg_1:ICommandTrigger):ICommandMapper
        {
            return (this._mappers[_arg_1] = ((this._mappers[_arg_1]) || (new CommandMapper(_arg_1))));
        }

        public function unmap(_arg_1:ICommandTrigger):ICommandUnmapper
        {
            return ((this._mappers[_arg_1]) || (this.NULL_UNMAPPER));
        }


    }
}//package robotlegs.bender.extensions.commandCenter.impl

