// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.contextView.ContextViewExtension

package robotlegs.bender.extensions.contextView
{
    import robotlegs.bender.framework.api.IExtension;
    import robotlegs.bender.framework.impl.UID;
    import org.swiftsuspenders.Injector;
    import robotlegs.bender.framework.api.ILogger;
    import org.hamcrest.object.instanceOf;
    import flash.display.DisplayObjectContainer;
    import robotlegs.bender.framework.api.IContext;

    public class ContextViewExtension implements IExtension 
    {

        private const _uid:String = UID.create(ContextViewExtension);

        private var _injector:Injector;
        private var _logger:ILogger;


        public function extend(_arg_1:IContext):void
        {
            this._injector = _arg_1.injector;
            this._logger = _arg_1.getLogger(this);
            _arg_1.addConfigHandler(instanceOf(DisplayObjectContainer), this.handleContextView);
        }

        public function toString():String
        {
            return (this._uid);
        }

        private function handleContextView(_arg_1:DisplayObjectContainer):void
        {
            if (this._injector.satisfiesDirectly(DisplayObjectContainer))
            {
                this._logger.warn("A contextView has already been mapped, ignoring {0}", [_arg_1]);
            }
            else
            {
                this._logger.debug("Mapping {0} as contextView", [_arg_1]);
                this._injector.map(DisplayObjectContainer).toValue(_arg_1);
            };
        }


    }
}//package robotlegs.bender.extensions.contextView

