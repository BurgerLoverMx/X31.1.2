// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.modularity.impl.ViewManagerBasedExistenceWatcher

package robotlegs.bender.extensions.modularity.impl
{
    import robotlegs.bender.framework.impl.UID;
    import robotlegs.bender.framework.api.ILogger;
    import org.swiftsuspenders.Injector;
    import robotlegs.bender.extensions.viewManager.api.IViewManager;
    import robotlegs.bender.framework.api.IContext;
    import flash.display.DisplayObjectContainer;
    import robotlegs.bender.extensions.viewManager.impl.ViewManagerEvent;

    public class ViewManagerBasedExistenceWatcher 
    {

        private const _uid:String = UID.create(ViewManagerBasedExistenceWatcher);

        private var _logger:ILogger;
        private var _injector:Injector;
        private var _viewManager:IViewManager;
        private var _childContext:IContext;

        public function ViewManagerBasedExistenceWatcher(_arg_1:IContext, _arg_2:IViewManager)
        {
            this._logger = _arg_1.getLogger(this);
            this._injector = _arg_1.injector;
            this._viewManager = _arg_2;
            _arg_1.lifecycle.whenDestroying(this.destroy);
            this.init();
        }

        public function toString():String
        {
            return (this._uid);
        }

        private function init():void
        {
            var _local_1:DisplayObjectContainer;
            for each (_local_1 in this._viewManager.containers)
            {
                this._logger.debug("Adding context existence event listener to container {0}", [_local_1]);
                _local_1.addEventListener(ModularContextEvent.CONTEXT_ADD, this.onContextAdd);
            };
            this._viewManager.addEventListener(ViewManagerEvent.CONTAINER_ADD, this.onContainerAdd);
            this._viewManager.addEventListener(ViewManagerEvent.CONTAINER_REMOVE, this.onContainerRemove);
        }

        private function destroy():void
        {
            var _local_1:DisplayObjectContainer;
            for each (_local_1 in this._viewManager.containers)
            {
                this._logger.debug("Removing context existence event listener from container {0}", [_local_1]);
                _local_1.removeEventListener(ModularContextEvent.CONTEXT_ADD, this.onContextAdd);
            };
            this._viewManager.removeEventListener(ViewManagerEvent.CONTAINER_ADD, this.onContainerAdd);
            this._viewManager.removeEventListener(ViewManagerEvent.CONTAINER_REMOVE, this.onContainerRemove);
            if (this._childContext)
            {
                this._logger.debug("Unlinking parent injector for child context {0}", [this._childContext]);
                this._childContext.injector.parentInjector = null;
            };
        }

        private function onContainerAdd(_arg_1:ViewManagerEvent):void
        {
            this._logger.debug("Adding context existence event listener to container {0}", [_arg_1.container]);
            _arg_1.container.addEventListener(ModularContextEvent.CONTEXT_ADD, this.onContextAdd);
        }

        private function onContainerRemove(_arg_1:ViewManagerEvent):void
        {
            this._logger.debug("Removing context existence event listener from container {0}", [_arg_1.container]);
            _arg_1.container.removeEventListener(ModularContextEvent.CONTEXT_ADD, this.onContextAdd);
        }

        private function onContextAdd(_arg_1:ModularContextEvent):void
        {
            _arg_1.stopImmediatePropagation();
            this._childContext = _arg_1.context;
            this._logger.debug("Context existence event caught. Configuring child context {0}", [this._childContext]);
            this._childContext.injector.parentInjector = this._injector;
        }


    }
}//package robotlegs.bender.extensions.modularity.impl

