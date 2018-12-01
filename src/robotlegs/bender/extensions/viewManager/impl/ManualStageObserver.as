// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.viewManager.impl.ManualStageObserver

package robotlegs.bender.extensions.viewManager.impl
{
    import flash.display.DisplayObjectContainer;
    import flash.display.DisplayObject;

    public class ManualStageObserver 
    {

        private var _registry:ContainerRegistry;

        public function ManualStageObserver(_arg_1:ContainerRegistry)
        {
            var _local_2:ContainerBinding;
            super();
            this._registry = _arg_1;
            this._registry.addEventListener(ContainerRegistryEvent.CONTAINER_ADD, this.onContainerAdd);
            this._registry.addEventListener(ContainerRegistryEvent.CONTAINER_REMOVE, this.onContainerRemove);
            for each (_local_2 in this._registry.bindings)
            {
                this.addContainerListener(_local_2.container);
            };
        }

        public function destroy():void
        {
            var _local_1:ContainerBinding;
            this._registry.removeEventListener(ContainerRegistryEvent.CONTAINER_ADD, this.onContainerAdd);
            this._registry.removeEventListener(ContainerRegistryEvent.CONTAINER_REMOVE, this.onContainerRemove);
            for each (_local_1 in this._registry.bindings)
            {
                this.removeContainerListener(_local_1.container);
            };
        }

        private function onContainerAdd(_arg_1:ContainerRegistryEvent):void
        {
            this.addContainerListener(_arg_1.container);
        }

        private function onContainerRemove(_arg_1:ContainerRegistryEvent):void
        {
            this.removeContainerListener(_arg_1.container);
        }

        private function addContainerListener(_arg_1:DisplayObjectContainer):void
        {
            _arg_1.addEventListener(ConfigureViewEvent.CONFIGURE_VIEW, this.onConfigureView);
        }

        private function removeContainerListener(_arg_1:DisplayObjectContainer):void
        {
            _arg_1.removeEventListener(ConfigureViewEvent.CONFIGURE_VIEW, this.onConfigureView);
        }

        private function onConfigureView(_arg_1:ConfigureViewEvent):void
        {
            var _local_3:DisplayObject;
            _arg_1.stopImmediatePropagation();
            var _local_2:DisplayObjectContainer = (_arg_1.currentTarget as DisplayObjectContainer);
            _local_3 = (_arg_1.target as DisplayObject);
            var _local_4:Class = _local_3["constructor"];
            this._registry.getBinding(_local_2).handleView(_local_3, _local_4);
        }


    }
}//package robotlegs.bender.extensions.viewManager.impl

