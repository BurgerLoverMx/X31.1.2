﻿// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.viewManager.impl.ContainerRegistry

package robotlegs.bender.extensions.viewManager.impl
{
    import flash.events.EventDispatcher;
    import __AS3__.vec.Vector;
    import flash.utils.Dictionary;
    import flash.display.DisplayObjectContainer;
    import flash.display.DisplayObject;
    import __AS3__.vec.*;

    public class ContainerRegistry extends EventDispatcher 
    {

        private const _bindings:Vector.<ContainerBinding> = new Vector.<ContainerBinding>();
        private const _rootBindings:Vector.<ContainerBinding> = new Vector.<ContainerBinding>();
        private const _bindingByContainer:Dictionary = new Dictionary();


        public function get bindings():Vector.<ContainerBinding>
        {
            return (this._bindings);
        }

        public function get rootBindings():Vector.<ContainerBinding>
        {
            return (this._rootBindings);
        }

        public function addContainer(_arg_1:DisplayObjectContainer):ContainerBinding
        {
            return (this._bindingByContainer[_arg_1] = ((this._bindingByContainer[_arg_1]) || (this.createBinding(_arg_1))));
        }

        public function removeContainer(_arg_1:DisplayObjectContainer):ContainerBinding
        {
            var _local_2:ContainerBinding = this._bindingByContainer[_arg_1];
            ((_local_2) && (this.removeBinding(_local_2)));
            return (_local_2);
        }

        public function findParentBinding(_arg_1:DisplayObject):ContainerBinding
        {
            var _local_3:ContainerBinding;
            var _local_2:DisplayObjectContainer = _arg_1.parent;
            while (_local_2)
            {
                _local_3 = this._bindingByContainer[_local_2];
                if (_local_3)
                {
                    return (_local_3);
                };
                _local_2 = _local_2.parent;
            };
            return (null);
        }

        public function getBinding(_arg_1:DisplayObjectContainer):ContainerBinding
        {
            return (this._bindingByContainer[_arg_1]);
        }

        private function createBinding(_arg_1:DisplayObjectContainer):ContainerBinding
        {
            var _local_3:ContainerBinding;
            var _local_2:ContainerBinding = new ContainerBinding(_arg_1);
            this._bindings.push(_local_2);
            _local_2.addEventListener(ContainerBindingEvent.BINDING_EMPTY, this.onBindingEmpty);
            _local_2.parent = this.findParentBinding(_arg_1);
            if (_local_2.parent == null)
            {
                this.addRootBinding(_local_2);
            };
            for each (_local_3 in this._bindingByContainer)
            {
                if (_arg_1.contains(_local_3.container))
                {
                    if (!_local_3.parent)
                    {
                        this.removeRootBinding(_local_3);
                        _local_3.parent = _local_2;
                    }
                    else
                    {
                        if (!_arg_1.contains(_local_3.parent.container))
                        {
                            _local_3.parent = _local_2;
                        };
                    };
                };
            };
            dispatchEvent(new ContainerRegistryEvent(ContainerRegistryEvent.CONTAINER_ADD, _local_2.container));
            return (_local_2);
        }

        private function removeBinding(_arg_1:ContainerBinding):void
        {
            var _local_3:ContainerBinding;
            delete this._bindingByContainer[_arg_1.container];
            var _local_2:int = this._bindings.indexOf(_arg_1);
            this._bindings.splice(_local_2, 1);
            _arg_1.removeEventListener(ContainerBindingEvent.BINDING_EMPTY, this.onBindingEmpty);
            if (!_arg_1.parent)
            {
                this.removeRootBinding(_arg_1);
            };
            for each (_local_3 in this._bindingByContainer)
            {
                if (_local_3.parent == _arg_1)
                {
                    _local_3.parent = _arg_1.parent;
                    if (!_local_3.parent)
                    {
                        this.addRootBinding(_local_3);
                    };
                };
            };
            dispatchEvent(new ContainerRegistryEvent(ContainerRegistryEvent.CONTAINER_REMOVE, _arg_1.container));
        }

        private function addRootBinding(_arg_1:ContainerBinding):void
        {
            this._rootBindings.push(_arg_1);
            dispatchEvent(new ContainerRegistryEvent(ContainerRegistryEvent.ROOT_CONTAINER_ADD, _arg_1.container));
        }

        private function removeRootBinding(_arg_1:ContainerBinding):void
        {
            var _local_2:int = this._rootBindings.indexOf(_arg_1);
            this._rootBindings.splice(_local_2, 1);
            dispatchEvent(new ContainerRegistryEvent(ContainerRegistryEvent.ROOT_CONTAINER_REMOVE, _arg_1.container));
        }

        private function onBindingEmpty(_arg_1:ContainerBindingEvent):void
        {
            this.removeBinding((_arg_1.target as ContainerBinding));
        }


    }
}//package robotlegs.bender.extensions.viewManager.impl

