// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.framework.impl.MessageDispatcher

package robotlegs.bender.framework.impl
{
    import robotlegs.bender.framework.api.IMessageDispatcher;
    import flash.utils.Dictionary;

    public final class MessageDispatcher implements IMessageDispatcher 
    {

        private const _handlers:Dictionary = new Dictionary();


        public function addMessageHandler(_arg_1:Object, _arg_2:Function):void
        {
            var _local_3:Array = this._handlers[_arg_1];
            if (_local_3)
            {
                if (_local_3.indexOf(_arg_2) == -1)
                {
                    _local_3.push(_arg_2);
                };
            }
            else
            {
                this._handlers[_arg_1] = [_arg_2];
            };
        }

        public function hasMessageHandler(_arg_1:Object):Boolean
        {
            return (this._handlers[_arg_1]);
        }

        public function removeMessageHandler(_arg_1:Object, _arg_2:Function):void
        {
            var _local_3:Array;
            _local_3 = this._handlers[_arg_1];
            var _local_4:int = ((_local_3) ? _local_3.indexOf(_arg_2) : -1);
            if (_local_4 != -1)
            {
                _local_3.splice(_local_4, 1);
                if (_local_3.length == 0)
                {
                    delete this._handlers[_arg_1];
                };
            };
        }

        public function dispatchMessage(_arg_1:Object, _arg_2:Function=null, _arg_3:Boolean=false):void
        {
            var _local_4:Array = this._handlers[_arg_1];
            if (_local_4)
            {
                _local_4 = _local_4.concat();
                ((_arg_3) || (_local_4.reverse()));
                new MessageRunner(_arg_1, _local_4, _arg_2).run();
            }
            else
            {
                ((_arg_2) && (safelyCallBack(_arg_2)));
            };
        }


    }
}//package robotlegs.bender.framework.impl

import robotlegs.bender.framework.impl.safelyCallBack;

class MessageRunner 
{

    /*private*/ var _message:Object;
    /*private*/ var _handlers:Array;
    /*private*/ var _callback:Function;

    public function MessageRunner(_arg_1:Object, _arg_2:Array, _arg_3:Function)
    {
        this._message = _arg_1;
        this._handlers = _arg_2;
        this._callback = _arg_3;
    }

    public function run():void
    {
        this.next();
    }

    /*private*/ function next():void
    {
        var handler:Function;
        var handled:Boolean;
        while ((handler = this._handlers.pop()))
        {
            if (handler.length == 0)
            {
                (handler());
            }
            else
            {
                if (handler.length == 1)
                {
                    (handler(this._message));
                }
                else
                {
                    if (handler.length == 2)
                    {
                        (handler(this._message, function (_arg_1:Object=null, _arg_2:Object=null):void
                        {
                            if (handled)
                            {
                                return;
                            };
                            handled = true;
                            if (((_arg_1) || (_handlers.length == 0)))
                            {
                                ((_callback) && (safelyCallBack(_callback, _arg_1, _message)));
                            }
                            else
                            {
                                next();
                            };
                        }));
                        return;
                    };
                    throw (new Error("Bad handler signature"));
                };
            };
        };
        ((this._callback) && (safelyCallBack(this._callback, null, this._message)));
    }


}


