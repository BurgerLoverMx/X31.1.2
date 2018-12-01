// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.modularity.ModularityExtension

package robotlegs.bender.extensions.modularity
{
    import robotlegs.bender.framework.api.IExtension;
    import robotlegs.bender.framework.impl.UID;
    import robotlegs.bender.framework.api.IContext;
    import org.swiftsuspenders.Injector;
    import robotlegs.bender.framework.api.ILogger;
    import flash.display.DisplayObjectContainer;
    import robotlegs.bender.extensions.modularity.impl.ModularContextEvent;
    import robotlegs.bender.extensions.viewManager.api.IViewManager;
    import robotlegs.bender.extensions.modularity.impl.ViewManagerBasedExistenceWatcher;
    import robotlegs.bender.extensions.modularity.impl.ContextViewBasedExistenceWatcher;

    public class ModularityExtension implements IExtension 
    {

        private const _uid:String = UID.create(ModularityExtension);

        private var _context:IContext;
        private var _injector:Injector;
        private var _logger:ILogger;
        private var _inherit:Boolean;
        private var _expose:Boolean;

        public function ModularityExtension(_arg_1:Boolean=true, _arg_2:Boolean=true)
        {
            this._inherit = _arg_1;
            this._expose = _arg_2;
        }

        public function extend(_arg_1:IContext):void
        {
            this._context = _arg_1;
            this._injector = _arg_1.injector;
            this._logger = _arg_1.getLogger(this);
            this._context.lifecycle.beforeInitializing(this.beforeInitializing);
        }

        public function toString():String
        {
            return (this._uid);
        }

        private function beforeInitializing():void
        {
            ((this._inherit) && (this.broadcastContextExistence()));
            ((this._expose) && (this.createContextWatcher()));
        }

        private function broadcastContextExistence():void
        {
            var _local_1:DisplayObjectContainer;
            if (this._injector.satisfiesDirectly(DisplayObjectContainer))
            {
                this._logger.debug("Context configured to inherit. Broadcasting existence event...");
                _local_1 = this._injector.getInstance(DisplayObjectContainer);
                _local_1.dispatchEvent(new ModularContextEvent(ModularContextEvent.CONTEXT_ADD, this._context));
            }
            else
            {
                this._logger.warn("Context has been configured to inherit dependencies but has no way to do so");
            };
        }

        private function createContextWatcher():void
        {
            var _local_1:IViewManager;
            var _local_2:DisplayObjectContainer;
            if (this._injector.satisfiesDirectly(IViewManager))
            {
                this._logger.debug("Context has a ViewManager. Configuring view manager based context existence watcher...");
                _local_1 = this._injector.getInstance(IViewManager);
                new ViewManagerBasedExistenceWatcher(this._context, _local_1);
            }
            else
            {
                if (this._injector.satisfiesDirectly(DisplayObjectContainer))
                {
                    this._logger.debug("Context has a ContextView. Configuring context view based context existence watcher...");
                    _local_2 = this._injector.getInstance(DisplayObjectContainer);
                    new ContextViewBasedExistenceWatcher(this._context, _local_2);
                }
                else
                {
                    this._logger.warn("Context has been configured to expose its dependencies but has no way to do so");
                };
            };
        }


    }
}//package robotlegs.bender.extensions.modularity

