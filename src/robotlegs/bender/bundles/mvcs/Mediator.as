// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.bundles.mvcs.Mediator

package robotlegs.bender.bundles.mvcs
{
    import robotlegs.bender.extensions.mediatorMap.api.IMediator;
    import robotlegs.bender.extensions.localEventMap.api.IEventMap;
    import flash.events.IEventDispatcher;
    import flash.events.Event;

    public class Mediator implements IMediator 
    {

        [Inject]
        public var eventMap:IEventMap;
        [Inject]
        public var eventDispatcher:IEventDispatcher;
        private var _viewComponent:Object;


        public function set viewComponent(_arg_1:Object):void
        {
            this._viewComponent = _arg_1;
        }

        public function initialize():void
        {
        }

        public function destroy():void
        {
            this.eventMap.unmapListeners();
        }

        protected function addViewListener(_arg_1:String, _arg_2:Function, _arg_3:Class=null):void
        {
            this.eventMap.mapListener(IEventDispatcher(this._viewComponent), _arg_1, _arg_2, _arg_3);
        }

        protected function addContextListener(_arg_1:String, _arg_2:Function, _arg_3:Class=null):void
        {
            this.eventMap.mapListener(this.eventDispatcher, _arg_1, _arg_2, _arg_3);
        }

        protected function removeViewListener(_arg_1:String, _arg_2:Function, _arg_3:Class=null):void
        {
            this.eventMap.unmapListener(IEventDispatcher(this._viewComponent), _arg_1, _arg_2, _arg_3);
        }

        protected function removeContextListener(_arg_1:String, _arg_2:Function, _arg_3:Class=null):void
        {
            this.eventMap.unmapListener(this.eventDispatcher, _arg_1, _arg_2, _arg_3);
        }

        protected function dispatch(_arg_1:Event):void
        {
            if (this.eventDispatcher.hasEventListener(_arg_1.type))
            {
                this.eventDispatcher.dispatchEvent(_arg_1);
            };
        }


    }
}//package robotlegs.bender.bundles.mvcs

