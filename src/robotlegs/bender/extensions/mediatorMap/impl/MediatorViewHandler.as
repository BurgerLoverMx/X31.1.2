// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.mediatorMap.impl.MediatorViewHandler

package robotlegs.bender.extensions.mediatorMap.impl
{
    import robotlegs.bender.extensions.mediatorMap.api.IMediatorViewHandler;
    import flash.utils.Dictionary;
    import robotlegs.bender.extensions.mediatorMap.api.IMediatorFactory;
    import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;
    import flash.display.DisplayObject;

    public class MediatorViewHandler implements IMediatorViewHandler 
    {

        private const _mappings:Array = [];

        private var _knownMappings:Dictionary = new Dictionary(true);
        private var _factory:IMediatorFactory;

        public function MediatorViewHandler(_arg_1:IMediatorFactory):void
        {
            this._factory = _arg_1;
        }

        public function addMapping(_arg_1:IMediatorMapping):void
        {
            var _local_2:int = this._mappings.indexOf(_arg_1);
            if (_local_2 > -1)
            {
                return;
            };
            this._mappings.push(_arg_1);
            this.flushCache();
        }

        public function removeMapping(_arg_1:IMediatorMapping):void
        {
            var _local_2:int = this._mappings.indexOf(_arg_1);
            if (_local_2 == -1)
            {
                return;
            };
            this._mappings.splice(_local_2, 1);
            this.flushCache();
        }

        public function handleView(_arg_1:DisplayObject, _arg_2:Class):void
        {
            var _local_3:Array = this.getInterestedMappingsFor(_arg_1, _arg_2);
            if (_local_3)
            {
                this._factory.createMediators(_arg_1, _arg_2, _local_3);
            };
        }

        public function handleItem(_arg_1:Object, _arg_2:Class):void
        {
            var _local_3:Array = this.getInterestedMappingsFor(_arg_1, _arg_2);
            if (_local_3)
            {
                this._factory.createMediators(_arg_1, _arg_2, _local_3);
            };
        }

        private function flushCache():void
        {
            this._knownMappings = new Dictionary(true);
        }

        private function getInterestedMappingsFor(_arg_1:Object, _arg_2:Class):Array
        {
            var _local_3:IMediatorMapping;
            if (this._knownMappings[_arg_2] === false)
            {
                return (null);
            };
            if (this._knownMappings[_arg_2] == undefined)
            {
                this._knownMappings[_arg_2] = false;
                for each (_local_3 in this._mappings)
                {
                    _local_3.validate();
                    if (_local_3.matcher.matches(_arg_1))
                    {
                        this._knownMappings[_arg_2] = ((this._knownMappings[_arg_2]) || ([]));
                        this._knownMappings[_arg_2].push(_local_3);
                    };
                };
                if (this._knownMappings[_arg_2] === false)
                {
                    return (null);
                };
            };
            return (this._knownMappings[_arg_2] as Array);
        }


    }
}//package robotlegs.bender.extensions.mediatorMap.impl

