// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.mediatorMap.impl.MediatorMap

package robotlegs.bender.extensions.mediatorMap.impl
{
    import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
    import robotlegs.bender.extensions.viewManager.api.IViewHandler;
    import flash.utils.Dictionary;
    import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorUnmapper;
    import robotlegs.bender.extensions.mediatorMap.api.IMediatorViewHandler;
    import robotlegs.bender.extensions.mediatorMap.api.IMediatorFactory;
    import robotlegs.bender.extensions.matching.ITypeMatcher;
    import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMapper;
    import robotlegs.bender.extensions.matching.TypeMatcher;
    import flash.display.DisplayObject;

    public class MediatorMap implements IMediatorMap, IViewHandler 
    {

        private const _mappers:Dictionary = new Dictionary();
        private const NULL_UNMAPPER:IMediatorUnmapper = new NullMediatorUnmapper();

        private var _handler:IMediatorViewHandler;
        private var _factory:IMediatorFactory;

        public function MediatorMap(_arg_1:IMediatorFactory, _arg_2:IMediatorViewHandler=null)
        {
            this._factory = _arg_1;
            this._handler = ((_arg_2) || (new MediatorViewHandler(this._factory)));
        }

        public function mapMatcher(_arg_1:ITypeMatcher):IMediatorMapper
        {
            return (this._mappers[_arg_1.createTypeFilter().descriptor] = ((this._mappers[_arg_1.createTypeFilter().descriptor]) || (this.createMapper(_arg_1))));
        }

        public function map(_arg_1:Class):IMediatorMapper
        {
            var _local_2:ITypeMatcher = new TypeMatcher().allOf(_arg_1);
            return (this.mapMatcher(_local_2));
        }

        public function unmapMatcher(_arg_1:ITypeMatcher):IMediatorUnmapper
        {
            return ((this._mappers[_arg_1.createTypeFilter().descriptor]) || (this.NULL_UNMAPPER));
        }

        public function unmap(_arg_1:Class):IMediatorUnmapper
        {
            var _local_2:ITypeMatcher = new TypeMatcher().allOf(_arg_1);
            return (this.unmapMatcher(_local_2));
        }

        public function handleView(_arg_1:DisplayObject, _arg_2:Class):void
        {
            this._handler.handleView(_arg_1, _arg_2);
        }

        public function mediate(_arg_1:Object):void
        {
            var _local_2:Class = (_arg_1.constructor as Class);
            this._handler.handleItem(_arg_1, _local_2);
        }

        public function unmediate(_arg_1:Object):void
        {
            this._factory.removeMediators(_arg_1);
        }

        private function createMapper(_arg_1:ITypeMatcher, _arg_2:Class=null):IMediatorMapper
        {
            return (new MediatorMapper(_arg_1.createTypeFilter(), this._handler));
        }


    }
}//package robotlegs.bender.extensions.mediatorMap.impl

