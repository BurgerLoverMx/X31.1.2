// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.viewManager.impl.ViewManager

package robotlegs.bender.extensions.viewManager.impl
{
    import flash.events.EventDispatcher;
    import robotlegs.bender.extensions.viewManager.api.IViewManager;
    import __AS3__.vec.Vector;
    import flash.display.DisplayObjectContainer;
    import robotlegs.bender.extensions.viewManager.api.IViewHandler;
    import __AS3__.vec.*;

    public class ViewManager extends EventDispatcher implements IViewManager 
    {

        private const _containers:Vector.<DisplayObjectContainer> = new Vector.<DisplayObjectContainer>();
        private const _handlers:Vector.<IViewHandler> = new Vector.<IViewHandler>();

        private var _registry:ContainerRegistry;

        public function ViewManager(_arg_1:ContainerRegistry)
        {
            this._registry = _arg_1;
        }

        public function get containers():Vector.<DisplayObjectContainer>
        {
            return (this._containers);
        }

        public function addContainer(_arg_1:DisplayObjectContainer):void
        {
            var _local_2:IViewHandler;
            if (!this.validContainer(_arg_1))
            {
                return;
            };
            this._containers.push(_arg_1);
            for each (_local_2 in this._handlers)
            {
                this._registry.addContainer(_arg_1).addHandler(_local_2);
            };
            dispatchEvent(new ViewManagerEvent(ViewManagerEvent.CONTAINER_ADD, _arg_1));
        }

        public function removeContainer(_arg_1:DisplayObjectContainer):void
        {
            var _local_4:IViewHandler;
            var _local_2:int = this._containers.indexOf(_arg_1);
            if (_local_2 == -1)
            {
                return;
            };
            this._containers.splice(_local_2, 1);
            var _local_3:ContainerBinding = this._registry.getBinding(_arg_1);
            for each (_local_4 in this._handlers)
            {
                _local_3.removeHandler(_local_4);
            };
            dispatchEvent(new ViewManagerEvent(ViewManagerEvent.CONTAINER_REMOVE, _arg_1));
        }

        public function addViewHandler(_arg_1:IViewHandler):void
        {
            var _local_2:DisplayObjectContainer;
            if (this._handlers.indexOf(_arg_1) != -1)
            {
                return;
            };
            this._handlers.push(_arg_1);
            for each (_local_2 in this._containers)
            {
                this._registry.addContainer(_local_2).addHandler(_arg_1);
            };
            dispatchEvent(new ViewManagerEvent(ViewManagerEvent.HANDLER_ADD, null, _arg_1));
        }

        public function removeViewHandler(_arg_1:IViewHandler):void
        {
            var _local_3:DisplayObjectContainer;
            var _local_2:int = this._handlers.indexOf(_arg_1);
            if (_local_2 == -1)
            {
                return;
            };
            this._handlers.splice(_local_2, 1);
            for each (_local_3 in this._containers)
            {
                this._registry.getBinding(_local_3).removeHandler(_arg_1);
            };
            dispatchEvent(new ViewManagerEvent(ViewManagerEvent.HANDLER_REMOVE, null, _arg_1));
        }

        public function removeAllHandlers():void
        {
            var _local_1:DisplayObjectContainer;
            var _local_2:ContainerBinding;
            var _local_3:IViewHandler;
            for each (_local_1 in this._containers)
            {
                _local_2 = this._registry.getBinding(_local_1);
                for each (_local_3 in this._handlers)
                {
                    _local_2.removeHandler(_local_3);
                };
            };
        }

        private function validContainer(_arg_1:DisplayObjectContainer):Boolean
        {
            var _local_2:DisplayObjectContainer;
            for each (_local_2 in this._containers)
            {
                if (_arg_1 == _local_2)
                {
                    return (false);
                };
                if (((_local_2.contains(_arg_1)) || (_arg_1.contains(_local_2))))
                {
                    throw (new Error("Containers can not be nested"));
                };
            };
            return (true);
        }


    }
}//package robotlegs.bender.extensions.viewManager.impl

