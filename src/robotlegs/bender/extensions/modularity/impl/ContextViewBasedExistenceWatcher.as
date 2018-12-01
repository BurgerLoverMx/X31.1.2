// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.modularity.impl.ContextViewBasedExistenceWatcher

package robotlegs.bender.extensions.modularity.impl
{
    import robotlegs.bender.framework.impl.UID;
    import robotlegs.bender.framework.api.ILogger;
    import org.swiftsuspenders.Injector;
    import flash.display.DisplayObjectContainer;
    import robotlegs.bender.framework.api.IContext;

    public class ContextViewBasedExistenceWatcher 
    {

        private const _uid:String = UID.create(ContextViewBasedExistenceWatcher);

        private var _logger:ILogger;
        private var _injector:Injector;
        private var _contextView:DisplayObjectContainer;
        private var _childContext:IContext;

        public function ContextViewBasedExistenceWatcher(_arg_1:IContext, _arg_2:DisplayObjectContainer)
        {
            this._logger = _arg_1.getLogger(this);
            this._injector = _arg_1.injector;
            this._contextView = _arg_2;
            _arg_1.lifecycle.whenDestroying(this.destroy);
            this.init();
        }

        public function toString():String
        {
            return (this._uid);
        }

        private function init():void
        {
            this._logger.debug("Listening for context existence events on contextView {0}", [this._contextView]);
            this._contextView.addEventListener(ModularContextEvent.CONTEXT_ADD, this.onContextAdd);
        }

        private function destroy():void
        {
            this._logger.debug("Removing modular context existence event listener from contextView {0}", [this._contextView]);
            this._contextView.removeEventListener(ModularContextEvent.CONTEXT_ADD, this.onContextAdd);
            if (this._childContext)
            {
                this._logger.debug("Unlinking parent injector for child context {0}", [this._childContext]);
                this._childContext.injector.parentInjector = null;
            };
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

