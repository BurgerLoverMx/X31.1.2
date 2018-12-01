// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.commandCenter.impl.CommandMapper

package robotlegs.bender.extensions.commandCenter.impl
{
    import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
    import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;
    import flash.utils.Dictionary;
    import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
    import robotlegs.bender.extensions.commandCenter.dsl.ICommandMappingConfig;
    import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;

    public class CommandMapper implements ICommandMapper, ICommandUnmapper 
    {

        private const _mappings:Dictionary = new Dictionary();

        private var _trigger:ICommandTrigger;

        public function CommandMapper(_arg_1:ICommandTrigger)
        {
            this._trigger = _arg_1;
        }

        public function toCommand(_arg_1:Class):ICommandMappingConfig
        {
            return ((this.locked(this._mappings[_arg_1])) || (this.createMapping(_arg_1)));
        }

        public function fromCommand(_arg_1:Class):void
        {
            var _local_2:ICommandMapping = this._mappings[_arg_1];
            ((_local_2) && (this._trigger.removeMapping(_local_2)));
            delete this._mappings[_arg_1];
        }

        public function fromAll():void
        {
            var _local_1:ICommandMapping;
            for each (_local_1 in this._mappings)
            {
                this._trigger.removeMapping(_local_1);
                delete this._mappings[_local_1.commandClass];
            };
        }

        private function createMapping(_arg_1:Class):CommandMapping
        {
            var _local_2:CommandMapping = new CommandMapping(_arg_1);
            this._trigger.addMapping(_local_2);
            this._mappings[_arg_1] = _local_2;
            return (_local_2);
        }

        private function locked(_arg_1:CommandMapping):CommandMapping
        {
            if (!_arg_1)
            {
                return (null);
            };
            _arg_1.invalidate();
            return (_arg_1);
        }


    }
}//package robotlegs.bender.extensions.commandCenter.impl

