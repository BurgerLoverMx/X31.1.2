// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.framework.impl.Lifecycle

package robotlegs.bender.framework.impl
{
    import flash.events.EventDispatcher;
    import robotlegs.bender.framework.api.ILifecycle;
    import flash.utils.Dictionary;
    import robotlegs.bender.framework.api.LifecycleState;
    import robotlegs.bender.framework.api.LifecycleEvent;
    import flash.events.IEventDispatcher;

    public class Lifecycle extends EventDispatcher implements ILifecycle 
    {

        private const _reversedEventTypes:Dictionary = new Dictionary();

        private var _state:String = "uninitialized";
        private var _target:Object;
        private var _reversePriority:int;
        private var _initialize:LifecycleTransition;
        private var _suspend:LifecycleTransition;
        private var _resume:LifecycleTransition;
        private var _destroy:LifecycleTransition;

        public function Lifecycle(_arg_1:Object)
        {
            this._target = _arg_1;
            this.configureTransitions();
        }

        public function get state():String
        {
            return (this._state);
        }

        public function get target():Object
        {
            return (this._target);
        }

        public function get initialized():Boolean
        {
            return ((!(this._state == LifecycleState.UNINITIALIZED)) && (!(this._state == LifecycleState.INITIALIZING)));
        }

        public function get active():Boolean
        {
            return (this._state == LifecycleState.ACTIVE);
        }

        public function get suspended():Boolean
        {
            return (this._state == LifecycleState.SUSPENDED);
        }

        public function get destroyed():Boolean
        {
            return (this._state == LifecycleState.DESTROYED);
        }

        public function initialize(_arg_1:Function=null):void
        {
            this._initialize.enter(_arg_1);
        }

        public function suspend(_arg_1:Function=null):void
        {
            this._suspend.enter(_arg_1);
        }

        public function resume(_arg_1:Function=null):void
        {
            this._resume.enter(_arg_1);
        }

        public function destroy(_arg_1:Function=null):void
        {
            this._destroy.enter(_arg_1);
        }

        public function beforeInitializing(_arg_1:Function):ILifecycle
        {
            this._initialize.addBeforeHandler(_arg_1);
            return (this);
        }

        public function beforeSuspending(_arg_1:Function):ILifecycle
        {
            this._suspend.addBeforeHandler(_arg_1);
            return (this);
        }

        public function beforeResuming(_arg_1:Function):ILifecycle
        {
            this._resume.addBeforeHandler(_arg_1);
            return (this);
        }

        public function beforeDestroying(_arg_1:Function):ILifecycle
        {
            this._destroy.addBeforeHandler(_arg_1);
            return (this);
        }

        public function whenInitializing(_arg_1:Function):ILifecycle
        {
            this.addEventListener(LifecycleEvent.INITIALIZE, this.createLifecycleListener(_arg_1, true));
            return (this);
        }

        public function whenSuspending(_arg_1:Function):ILifecycle
        {
            this.addEventListener(LifecycleEvent.SUSPEND, this.createLifecycleListener(_arg_1));
            return (this);
        }

        public function whenResuming(_arg_1:Function):ILifecycle
        {
            this.addEventListener(LifecycleEvent.RESUME, this.createLifecycleListener(_arg_1));
            return (this);
        }

        public function whenDestroying(_arg_1:Function):ILifecycle
        {
            this.addEventListener(LifecycleEvent.DESTROY, this.createLifecycleListener(_arg_1, true));
            return (this);
        }

        public function afterInitializing(_arg_1:Function):ILifecycle
        {
            this.addEventListener(LifecycleEvent.POST_INITIALIZE, this.createLifecycleListener(_arg_1, true));
            return (this);
        }

        public function afterSuspending(_arg_1:Function):ILifecycle
        {
            this.addEventListener(LifecycleEvent.POST_SUSPEND, this.createLifecycleListener(_arg_1));
            return (this);
        }

        public function afterResuming(_arg_1:Function):ILifecycle
        {
            this.addEventListener(LifecycleEvent.POST_RESUME, this.createLifecycleListener(_arg_1));
            return (this);
        }

        public function afterDestroying(_arg_1:Function):ILifecycle
        {
            this.addEventListener(LifecycleEvent.POST_DESTROY, this.createLifecycleListener(_arg_1, true));
            return (this);
        }

        override public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            _arg_4 = this.flipPriority(_arg_1, _arg_4);
            super.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        internal function setCurrentState(_arg_1:String):void
        {
            if (this._state == _arg_1)
            {
                return;
            };
            this._state = _arg_1;
        }

        internal function addReversedEventTypes(... _args):void
        {
            var _local_2:String;
            for each (_local_2 in _args)
            {
                this._reversedEventTypes[_local_2] = true;
            };
        }

        private function configureTransitions():void
        {
            this._initialize = new LifecycleTransition(LifecycleEvent.PRE_INITIALIZE, this).fromStates(LifecycleState.UNINITIALIZED).toStates(LifecycleState.INITIALIZING, LifecycleState.ACTIVE).withEvents(LifecycleEvent.PRE_INITIALIZE, LifecycleEvent.INITIALIZE, LifecycleEvent.POST_INITIALIZE);
            this._suspend = new LifecycleTransition(LifecycleEvent.PRE_SUSPEND, this).fromStates(LifecycleState.ACTIVE).toStates(LifecycleState.SUSPENDING, LifecycleState.SUSPENDED).withEvents(LifecycleEvent.PRE_SUSPEND, LifecycleEvent.SUSPEND, LifecycleEvent.POST_SUSPEND).inReverse();
            this._resume = new LifecycleTransition(LifecycleEvent.PRE_RESUME, this).fromStates(LifecycleState.SUSPENDED).toStates(LifecycleState.RESUMING, LifecycleState.ACTIVE).withEvents(LifecycleEvent.PRE_RESUME, LifecycleEvent.RESUME, LifecycleEvent.POST_RESUME);
            this._destroy = new LifecycleTransition(LifecycleEvent.PRE_DESTROY, this).fromStates(LifecycleState.SUSPENDED, LifecycleState.ACTIVE).toStates(LifecycleState.DESTROYING, LifecycleState.DESTROYED).withEvents(LifecycleEvent.PRE_DESTROY, LifecycleEvent.DESTROY, LifecycleEvent.POST_DESTROY).inReverse();
        }

        private function flipPriority(_arg_1:String, _arg_2:int):int
        {
            return (((_arg_2 == 0) && (this._reversedEventTypes[_arg_1])) ? this._reversePriority++ : _arg_2);
        }

        private function createLifecycleListener(handler:Function, once:Boolean=false):Function
        {
            if (handler.length > 1)
            {
                throw (new Error("When and After handlers must accept 0-1 arguments"));
            };
            if (handler.length == 1)
            {
                return (function (_arg_1:LifecycleEvent):void
                {
                    ((once) && (IEventDispatcher(_arg_1.target).removeEventListener(_arg_1.type, arguments.callee)));
                    handler(_arg_1.type);
                });
            };
            return (function (_arg_1:LifecycleEvent):void
            {
                ((once) && (IEventDispatcher(_arg_1.target).removeEventListener(_arg_1.type, arguments.callee)));
                handler();
            });
        }


    }
}//package robotlegs.bender.framework.impl

