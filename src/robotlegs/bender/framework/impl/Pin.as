// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.framework.impl.Pin

package robotlegs.bender.framework.impl
{
    import flash.utils.Dictionary;

    public class Pin 
    {

        private const _instances:Dictionary = new Dictionary(false);


        public function detain(_arg_1:Object):void
        {
            this._instances[_arg_1] = true;
        }

        public function release(_arg_1:Object):void
        {
            delete this._instances[_arg_1];
        }

        public function flush():void
        {
            var _local_1:Object;
            for (_local_1 in this._instances)
            {
                delete this._instances[_local_1];
            };
        }


    }
}//package robotlegs.bender.framework.impl

