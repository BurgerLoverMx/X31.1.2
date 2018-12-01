// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.commandCenter.impl.CommandMappingList

package robotlegs.bender.extensions.commandCenter.impl
{
    import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;

    public class CommandMappingList 
    {

        protected var _head:ICommandMapping;


        public function get head():ICommandMapping
        {
            return (this._head);
        }

        public function set head(_arg_1:ICommandMapping):void
        {
            if (_arg_1 !== this._head)
            {
                this._head = _arg_1;
            };
        }

        public function get tail():ICommandMapping
        {
            if (!this._head)
            {
                return (null);
            };
            var _local_1:ICommandMapping = this._head;
            while (_local_1.next)
            {
                _local_1 = _local_1.next;
            };
            return (_local_1);
        }

        public function remove(_arg_1:ICommandMapping):void
        {
            var _local_2:ICommandMapping = this._head;
            if (_local_2 == _arg_1)
            {
                this._head = _arg_1.next;
            };
            while (_local_2)
            {
                if (_local_2.next == _arg_1)
                {
                    _local_2.next = _arg_1.next;
                };
                _local_2 = _local_2.next;
            };
        }


    }
}//package robotlegs.bender.extensions.commandCenter.impl

