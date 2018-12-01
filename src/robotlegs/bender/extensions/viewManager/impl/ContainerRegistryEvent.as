// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.viewManager.impl.ContainerRegistryEvent

package robotlegs.bender.extensions.viewManager.impl
{
    import flash.events.Event;
    import flash.display.DisplayObjectContainer;

    public class ContainerRegistryEvent extends Event 
    {

        public static const CONTAINER_ADD:String = "containerAdd";
        public static const CONTAINER_REMOVE:String = "containerRemove";
        public static const ROOT_CONTAINER_ADD:String = "rootContainerAdd";
        public static const ROOT_CONTAINER_REMOVE:String = "rootContainerRemove";

        private var _container:DisplayObjectContainer;

        public function ContainerRegistryEvent(_arg_1:String, _arg_2:DisplayObjectContainer)
        {
            super(_arg_1);
            this._container = _arg_2;
        }

        public function get container():DisplayObjectContainer
        {
            return (this._container);
        }

        override public function clone():Event
        {
            return (new ContainerRegistryEvent(type, this._container));
        }


    }
}//package robotlegs.bender.extensions.viewManager.impl

