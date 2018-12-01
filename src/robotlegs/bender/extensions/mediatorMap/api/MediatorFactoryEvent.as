// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.mediatorMap.api.MediatorFactoryEvent

package robotlegs.bender.extensions.mediatorMap.api
{
    import flash.events.Event;

    public class MediatorFactoryEvent extends Event 
    {

        public static const MEDIATOR_CREATE:String = "mediatorCreate";
        public static const MEDIATOR_REMOVE:String = "mediatorRemove";

        private var _mediator:Object;
        private var _view:Object;
        private var _mapping:IMediatorMapping;
        private var _factory:IMediatorFactory;

        public function MediatorFactoryEvent(_arg_1:String, _arg_2:Object, _arg_3:Object, _arg_4:IMediatorMapping, _arg_5:IMediatorFactory)
        {
            super(_arg_1);
            this._mediator = _arg_2;
            this._view = _arg_3;
            this._mapping = _arg_4;
            this._factory = _arg_5;
        }

        public function get mediator():Object
        {
            return (this._mediator);
        }

        public function get view():Object
        {
            return (this._view);
        }

        public function get mapping():IMediatorMapping
        {
            return (this._mapping);
        }

        public function get factory():IMediatorFactory
        {
            return (this._factory);
        }

        override public function clone():Event
        {
            return (new MediatorFactoryEvent(type, this._mediator, this._view, this._mapping, this._factory));
        }


    }
}//package robotlegs.bender.extensions.mediatorMap.api

