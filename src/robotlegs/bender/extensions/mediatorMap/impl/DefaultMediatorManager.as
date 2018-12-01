// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.mediatorMap.impl.DefaultMediatorManager

package robotlegs.bender.extensions.mediatorMap.impl
{
    import robotlegs.bender.extensions.mediatorMap.api.IMediatorFactory;
    import robotlegs.bender.extensions.mediatorMap.api.MediatorFactoryEvent;
    import flash.utils.getDefinitionByName;
    import flash.display.DisplayObject;
    import flash.events.Event;

    public class DefaultMediatorManager 
    {

        private static var UIComponentClass:Class;
        private static const flexAvailable:Boolean = checkFlex();

        private var _factory:IMediatorFactory;

        public function DefaultMediatorManager(_arg_1:IMediatorFactory)
        {
            this._factory = _arg_1;
            this._factory.addEventListener(MediatorFactoryEvent.MEDIATOR_CREATE, this.onMediatorCreate);
            this._factory.addEventListener(MediatorFactoryEvent.MEDIATOR_REMOVE, this.onMediatorRemove);
        }

        private static function checkFlex():Boolean
        {
            try
            {
                UIComponentClass = (getDefinitionByName("mx.core::UIComponent") as Class);
            }
            catch(error:Error)
            {
            };
            return (!(UIComponentClass == null));
        }


        private function onMediatorCreate(event:MediatorFactoryEvent):void
        {
            var mediator:Object;
            var displayObject:DisplayObject;
            mediator = event.mediator;
            displayObject = (event.view as DisplayObject);
            if (!displayObject)
            {
                this.initializeMediator(event.view, mediator);
                return;
            };
            displayObject.addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
            if ((((flexAvailable) && (displayObject is UIComponentClass)) && (!(displayObject["initialized"]))))
            {
                displayObject.addEventListener("creationComplete", function (_arg_1:Event):void
                {
                    displayObject.removeEventListener("creationComplete", arguments.callee);
                    if (_factory.getMediator(displayObject, event.mapping))
                    {
                        initializeMediator(displayObject, mediator);
                    };
                });
            }
            else
            {
                this.initializeMediator(displayObject, mediator);
            };
        }

        private function onMediatorRemove(_arg_1:MediatorFactoryEvent):void
        {
            var _local_2:DisplayObject = (_arg_1.view as DisplayObject);
            if (_local_2)
            {
                _local_2.removeEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
            };
            if (_arg_1.mediator)
            {
                this.destroyMediator(_arg_1.mediator);
            };
        }

        private function onRemovedFromStage(_arg_1:Event):void
        {
            this._factory.removeMediators(_arg_1.target);
        }

        private function initializeMediator(_arg_1:Object, _arg_2:Object):void
        {
            if (_arg_2.hasOwnProperty("viewComponent"))
            {
                _arg_2.viewComponent = _arg_1;
            };
            if (_arg_2.hasOwnProperty("initialize"))
            {
                _arg_2.initialize();
            };
        }

        private function destroyMediator(_arg_1:Object):void
        {
            if (_arg_1.hasOwnProperty("destroy"))
            {
                _arg_1.destroy();
            };
        }


    }
}//package robotlegs.bender.extensions.mediatorMap.impl

