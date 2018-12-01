// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.viewManager.impl.ContainerBinding

package robotlegs.bender.extensions.viewManager.impl
{
    import flash.events.EventDispatcher;
    import __AS3__.vec.Vector;
    import robotlegs.bender.extensions.viewManager.api.IViewHandler;
    import flash.display.DisplayObjectContainer;
    import flash.display.DisplayObject;
    import __AS3__.vec.*;

    public class ContainerBinding extends EventDispatcher 
    {

        private const _handlers:Vector.<IViewHandler> = new Vector.<IViewHandler>();

        private var _parent:ContainerBinding;
        private var _container:DisplayObjectContainer;

        public function ContainerBinding(_arg_1:DisplayObjectContainer)
        {
            this._container = _arg_1;
        }

        public function get parent():ContainerBinding
        {
            return (this._parent);
        }

        public function set parent(_arg_1:ContainerBinding):void
        {
            this._parent = _arg_1;
        }

        public function get container():DisplayObjectContainer
        {
            return (this._container);
        }

        public function get numHandlers():uint
        {
            return (this._handlers.length);
        }

        public function addHandler(_arg_1:IViewHandler):void
        {
            if (this._handlers.indexOf(_arg_1) > -1)
            {
                return;
            };
            this._handlers.push(_arg_1);
        }

        public function removeHandler(_arg_1:IViewHandler):void
        {
            var _local_2:int = this._handlers.indexOf(_arg_1);
            if (_local_2 > -1)
            {
                this._handlers.splice(_local_2, 1);
                if (this._handlers.length == 0)
                {
                    dispatchEvent(new ContainerBindingEvent(ContainerBindingEvent.BINDING_EMPTY));
                };
            };
        }

        public function handleView(_arg_1:DisplayObject, _arg_2:Class):void
        {
            var _local_5:IViewHandler;
            var _local_3:uint = this._handlers.length;
            var _local_4:int;
            while (_local_4 < _local_3)
            {
                _local_5 = (this._handlers[_local_4] as IViewHandler);
                _local_5.handleView(_arg_1, _arg_2);
                _local_4++;
            };
        }


    }
}//package robotlegs.bender.extensions.viewManager.impl

