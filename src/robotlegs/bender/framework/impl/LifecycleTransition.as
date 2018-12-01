// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.framework.impl.LifecycleTransition

package robotlegs.bender.framework.impl
{
    import __AS3__.vec.Vector;
    import robotlegs.bender.framework.api.LifecycleEvent;
    import __AS3__.vec.*;

    public class LifecycleTransition 
    {

        private const _fromStates:Vector.<String> = new Vector.<String>();
        private const _dispatcher:MessageDispatcher = new MessageDispatcher();
        private const _callbacks:Array = [];

        private var _name:String;
        private var _lifecycle:Lifecycle;
        private var _transitionState:String;
        private var _finalState:String;
        private var _preTransitionEvent:String;
        private var _transitionEvent:String;
        private var _postTransitionEvent:String;
        private var _reverse:Boolean;

        public function LifecycleTransition(_arg_1:String, _arg_2:Lifecycle)
        {
            this._name = _arg_1;
            this._lifecycle = _arg_2;
        }

        public function fromStates(... _args):LifecycleTransition
        {
            var _local_2:String;
            for each (_local_2 in _args)
            {
                this._fromStates.push(_local_2);
            };
            return (this);
        }

        public function toStates(_arg_1:String, _arg_2:String):LifecycleTransition
        {
            this._transitionState = _arg_1;
            this._finalState = _arg_2;
            return (this);
        }

        public function withEvents(_arg_1:String, _arg_2:String, _arg_3:String):LifecycleTransition
        {
            this._preTransitionEvent = _arg_1;
            this._transitionEvent = _arg_2;
            this._postTransitionEvent = _arg_3;
            ((this._reverse) && (this._lifecycle.addReversedEventTypes(_arg_1, _arg_2, _arg_3)));
            return (this);
        }

        public function inReverse():LifecycleTransition
        {
            this._reverse = true;
            this._lifecycle.addReversedEventTypes(this._preTransitionEvent, this._transitionEvent, this._postTransitionEvent);
            return (this);
        }

        public function addBeforeHandler(_arg_1:Function):LifecycleTransition
        {
            this._dispatcher.addMessageHandler(this._name, _arg_1);
            return (this);
        }

        public function enter(callback:Function=null):void
        {
            var initialState:String;
            if (this._lifecycle.state == this._finalState)
            {
                ((callback) && (safelyCallBack(callback, null, this._name)));
                return;
            };
            if (this._lifecycle.state == this._transitionState)
            {
                ((callback) && (this._callbacks.push(callback)));
                return;
            };
            if (this.invalidTransition())
            {
                this.reportError("Invalid transition", [callback]);
                return;
            };
            initialState = this._lifecycle.state;
            ((callback) && (this._callbacks.push(callback)));
            this.setState(this._transitionState);
            this._dispatcher.dispatchMessage(this._name, function (_arg_1:Object):void
            {
                var _local_3:Function;
                if (_arg_1)
                {
                    setState(initialState);
                    reportError(_arg_1, _callbacks);
                    return;
                };
                dispatch(_preTransitionEvent);
                dispatch(_transitionEvent);
                setState(_finalState);
                var _local_2:Array = _callbacks.concat();
                _callbacks.length = 0;
                for each (_local_3 in _local_2)
                {
                    safelyCallBack(_local_3, null, _name);
                };
                dispatch(_postTransitionEvent);
            }, this._reverse);
        }

        private function invalidTransition():Boolean
        {
            return ((this._fromStates.length > 0) && (this._fromStates.indexOf(this._lifecycle.state) == -1));
        }

        private function setState(_arg_1:String):void
        {
            ((_arg_1) && (this._lifecycle.setCurrentState(_arg_1)));
        }

        private function dispatch(_arg_1:String):void
        {
            if (((_arg_1) && (this._lifecycle.hasEventListener(_arg_1))))
            {
                this._lifecycle.dispatchEvent(new LifecycleEvent(_arg_1));
            };
        }

        private function reportError(_arg_1:Object, _arg_2:Array=null):void
        {
            var _local_4:LifecycleEvent;
            var _local_5:Function;
            var _local_3:Error = ((_arg_1 is Error) ? (_arg_1 as Error) : new Error(_arg_1));
            if (this._lifecycle.hasEventListener(LifecycleEvent.ERROR))
            {
                _local_4 = new LifecycleEvent(LifecycleEvent.ERROR);
                _local_4.error = _local_3;
                this._lifecycle.dispatchEvent(_local_4);
                if (_arg_2)
                {
                    for each (_local_5 in _arg_2)
                    {
                        ((_local_5) && (safelyCallBack(_local_5, _local_3, this._name)));
                    };
                    _arg_2.length = 0;
                };
            }
            else
            {
                throw (_local_3);
            };
        }


    }
}//package robotlegs.bender.framework.impl

