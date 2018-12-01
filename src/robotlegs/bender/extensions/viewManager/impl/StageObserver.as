// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.viewManager.impl.StageObserver

package robotlegs.bender.extensions.viewManager.impl
{
    import flash.events.Event;
    import flash.display.DisplayObjectContainer;
    import flash.display.DisplayObject;
    import flash.utils.getQualifiedClassName;

    public class StageObserver 
    {

        private const _filter:RegExp = /^mx\.|^spark\.|^flash\./;

        private var _registry:ContainerRegistry;

        public function StageObserver(_arg_1:ContainerRegistry)
        {
            var _local_2:ContainerBinding;
            super();
            this._registry = _arg_1;
            this._registry.addEventListener(ContainerRegistryEvent.ROOT_CONTAINER_ADD, this.onRootContainerAdd);
            this._registry.addEventListener(ContainerRegistryEvent.ROOT_CONTAINER_REMOVE, this.onRootContainerRemove);
            for each (_local_2 in this._registry.rootBindings)
            {
                this.addRootListener(_local_2.container);
            };
        }

        public function destroy():void
        {
            var _local_1:ContainerBinding;
            this._registry.removeEventListener(ContainerRegistryEvent.ROOT_CONTAINER_ADD, this.onRootContainerAdd);
            this._registry.removeEventListener(ContainerRegistryEvent.ROOT_CONTAINER_REMOVE, this.onRootContainerRemove);
            for each (_local_1 in this._registry.rootBindings)
            {
                this.removeRootListener(_local_1.container);
            };
        }

        private function onRootContainerAdd(_arg_1:ContainerRegistryEvent):void
        {
            this.addRootListener(_arg_1.container);
        }

        private function onRootContainerRemove(_arg_1:ContainerRegistryEvent):void
        {
            this.removeRootListener(_arg_1.container);
        }

        private function addRootListener(_arg_1:DisplayObjectContainer):void
        {
            _arg_1.addEventListener(Event.ADDED_TO_STAGE, this.onViewAddedToStage, true);
            _arg_1.addEventListener(Event.ADDED_TO_STAGE, this.onContainerRootAddedToStage);
        }

        private function removeRootListener(_arg_1:DisplayObjectContainer):void
        {
            _arg_1.removeEventListener(Event.ADDED_TO_STAGE, this.onViewAddedToStage, true);
            _arg_1.removeEventListener(Event.ADDED_TO_STAGE, this.onContainerRootAddedToStage);
        }

        private function onViewAddedToStage(_arg_1:Event):void
        {
            var _local_2:DisplayObject;
            var _local_3:String;
            _local_2 = (_arg_1.target as DisplayObject);
            _local_3 = getQualifiedClassName(_local_2);
            var _local_4:Boolean = this._filter.test(_local_3);
            if (_local_4)
            {
                return;
            };
            var _local_5:Class = _local_2["constructor"];
            var _local_6:ContainerBinding = this._registry.findParentBinding(_local_2);
            while (_local_6)
            {
                _local_6.handleView(_local_2, _local_5);
                _local_6 = _local_6.parent;
            };
        }

        private function onContainerRootAddedToStage(_arg_1:Event):void
        {
            var _local_2:DisplayObjectContainer;
            _local_2 = (_arg_1.target as DisplayObjectContainer);
            _local_2.removeEventListener(Event.ADDED_TO_STAGE, this.onContainerRootAddedToStage);
            var _local_3:Class = _local_2["constructor"];
            var _local_4:ContainerBinding = this._registry.getBinding(_local_2);
            _local_4.handleView(_local_2, _local_3);
        }


    }
}//package robotlegs.bender.extensions.viewManager.impl

