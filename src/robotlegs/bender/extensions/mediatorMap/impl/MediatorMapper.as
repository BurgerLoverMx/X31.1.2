// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.mediatorMap.impl.MediatorMapper

package robotlegs.bender.extensions.mediatorMap.impl
{
    import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMapper;
    import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMappingFinder;
    import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorUnmapper;
    import flash.utils.Dictionary;
    import robotlegs.bender.extensions.matching.ITypeFilter;
    import robotlegs.bender.extensions.mediatorMap.api.IMediatorViewHandler;
    import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMappingConfig;
    import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;

    public class MediatorMapper implements IMediatorMapper, IMediatorMappingFinder, IMediatorUnmapper 
    {

        private const _mappings:Dictionary = new Dictionary();

        private var _matcher:ITypeFilter;
        private var _handler:IMediatorViewHandler;

        public function MediatorMapper(_arg_1:ITypeFilter, _arg_2:IMediatorViewHandler)
        {
            this._matcher = _arg_1;
            this._handler = _arg_2;
        }

        public function toMediator(_arg_1:Class):IMediatorMappingConfig
        {
            return ((this.lockedMappingFor(_arg_1)) || (this.createMapping(_arg_1)));
        }

        public function forMediator(_arg_1:Class):IMediatorMapping
        {
            return (this._mappings[_arg_1]);
        }

        public function fromMediator(_arg_1:Class):void
        {
            var _local_2:IMediatorMapping = this._mappings[_arg_1];
            delete this._mappings[_arg_1];
            this._handler.removeMapping(_local_2);
        }

        public function fromMediators():void
        {
            var _local_1:IMediatorMapping;
            for each (_local_1 in this._mappings)
            {
                delete this._mappings[_local_1.mediatorClass];
                this._handler.removeMapping(_local_1);
            };
        }

        private function createMapping(_arg_1:Class):MediatorMapping
        {
            var _local_2:MediatorMapping = new MediatorMapping(this._matcher, _arg_1);
            this._handler.addMapping(_local_2);
            this._mappings[_arg_1] = _local_2;
            return (_local_2);
        }

        private function lockedMappingFor(_arg_1:Class):MediatorMapping
        {
            var _local_2:MediatorMapping = this._mappings[_arg_1];
            if (_local_2)
            {
                _local_2.invalidate();
            };
            return (_local_2);
        }


    }
}//package robotlegs.bender.extensions.mediatorMap.impl

