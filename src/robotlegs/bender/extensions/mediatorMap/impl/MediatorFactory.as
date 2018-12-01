// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.mediatorMap.impl.MediatorFactory

package robotlegs.bender.extensions.mediatorMap.impl
{
    import flash.events.EventDispatcher;
    import robotlegs.bender.extensions.mediatorMap.api.IMediatorFactory;
    import flash.utils.Dictionary;
    import org.swiftsuspenders.Injector;
    import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;
    import robotlegs.bender.extensions.matching.ITypeFilter;
    import robotlegs.bender.extensions.mediatorMap.api.MediatorFactoryEvent;
    import robotlegs.bender.framework.impl.guardsApprove;
    import robotlegs.bender.framework.impl.applyHooks;
    import __AS3__.vec.Vector;

    public class MediatorFactory extends EventDispatcher implements IMediatorFactory 
    {

        private const _mediators:Dictionary = new Dictionary();

        private var _injector:Injector;

        public function MediatorFactory(_arg_1:Injector)
        {
            this._injector = _arg_1;
        }

        public function getMediator(_arg_1:Object, _arg_2:IMediatorMapping):Object
        {
            return ((this._mediators[_arg_1]) ? this._mediators[_arg_1][_arg_2] : null);
        }

        public function createMediators(_arg_1:Object, _arg_2:Class, _arg_3:Array):Array
        {
            var _local_5:ITypeFilter;
            var _local_6:Object;
            var _local_7:IMediatorMapping;
            var _local_4:Array = [];
            for each (_local_7 in _arg_3)
            {
                _local_6 = this.getMediator(_arg_1, _local_7);
                if (!_local_6)
                {
                    _local_5 = _local_7.matcher;
                    this.mapTypeForFilterBinding(_local_5, _arg_2, _arg_1);
                    _local_6 = this.createMediator(_arg_1, _local_7);
                    this.unmapTypeForFilterBinding(_local_5, _arg_2, _arg_1);
                };
                if (_local_6)
                {
                    _local_4.push(_local_6);
                };
            };
            return (_local_4);
        }

        public function removeMediators(_arg_1:Object):void
        {
            var _local_3:Object;
            var _local_2:Dictionary = this._mediators[_arg_1];
            if (!_local_2)
            {
                return;
            };
            if (hasEventListener(MediatorFactoryEvent.MEDIATOR_REMOVE))
            {
                for (_local_3 in _local_2)
                {
                    dispatchEvent(new MediatorFactoryEvent(MediatorFactoryEvent.MEDIATOR_REMOVE, _local_2[_local_3], _arg_1, (_local_3 as IMediatorMapping), this));
                };
            };
            delete this._mediators[_arg_1];
        }

        public function removeAllMediators():void
        {
            var _local_1:Object;
            for (_local_1 in this._mediators)
            {
                this.removeMediators(_local_1);
            };
        }

        private function createMediator(_arg_1:Object, _arg_2:IMediatorMapping):Object
        {
            var _local_3:Object = this.getMediator(_arg_1, _arg_2);
            if (_local_3)
            {
                return (_local_3);
            };
            if (guardsApprove(_arg_2.guards, this._injector))
            {
                _local_3 = this._injector.getInstance(_arg_2.mediatorClass);
                this._injector.map(_arg_2.mediatorClass).toValue(_local_3);
                applyHooks(_arg_2.hooks, this._injector);
                this._injector.unmap(_arg_2.mediatorClass);
                this.addMediator(_local_3, _arg_1, _arg_2);
            };
            return (_local_3);
        }

        private function addMediator(_arg_1:Object, _arg_2:Object, _arg_3:IMediatorMapping):void
        {
            this._mediators[_arg_2] = ((this._mediators[_arg_2]) || (new Dictionary()));
            this._mediators[_arg_2][_arg_3] = _arg_1;
            if (hasEventListener(MediatorFactoryEvent.MEDIATOR_CREATE))
            {
                dispatchEvent(new MediatorFactoryEvent(MediatorFactoryEvent.MEDIATOR_CREATE, _arg_1, _arg_2, _arg_3, this));
            };
        }

        private function mapTypeForFilterBinding(_arg_1:ITypeFilter, _arg_2:Class, _arg_3:Object):void
        {
            var _local_4:Class;
            var _local_5:Vector.<Class> = this.requiredTypesFor(_arg_1, _arg_2);
            for each (_local_4 in _local_5)
            {
                this._injector.map(_local_4).toValue(_arg_3);
            };
        }

        private function unmapTypeForFilterBinding(_arg_1:ITypeFilter, _arg_2:Class, _arg_3:Object):void
        {
            var _local_4:Class;
            var _local_5:Vector.<Class> = this.requiredTypesFor(_arg_1, _arg_2);
            for each (_local_4 in _local_5)
            {
                if (this._injector.satisfiesDirectly(_local_4))
                {
                    this._injector.unmap(_local_4);
                };
            };
        }

        private function requiredTypesFor(_arg_1:ITypeFilter, _arg_2:Class):Vector.<Class>
        {
            var _local_3:Vector.<Class> = _arg_1.allOfTypes.concat(_arg_1.anyOfTypes);
            if (_local_3.indexOf(_arg_2) == -1)
            {
                _local_3.push(_arg_2);
            };
            return (_local_3);
        }


    }
}//package robotlegs.bender.extensions.mediatorMap.impl

