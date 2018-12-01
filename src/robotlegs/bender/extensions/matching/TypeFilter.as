// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.matching.TypeFilter

package robotlegs.bender.extensions.matching
{
    import __AS3__.vec.Vector;
    import flash.utils.getQualifiedClassName;
    import __AS3__.vec.*;

    public class TypeFilter implements ITypeFilter 
    {

        protected var _allOfTypes:Vector.<Class>;
        protected var _anyOfTypes:Vector.<Class>;
        protected var _descriptor:String;
        protected var _noneOfTypes:Vector.<Class>;

        public function TypeFilter(_arg_1:Vector.<Class>, _arg_2:Vector.<Class>, _arg_3:Vector.<Class>)
        {
            if ((((!(_arg_1)) || (!(_arg_2))) || (!(_arg_3))))
            {
                throw (ArgumentError("TypeFilter parameters can not be null"));
            };
            this._allOfTypes = _arg_1;
            this._anyOfTypes = _arg_2;
            this._noneOfTypes = _arg_3;
        }

        public function get allOfTypes():Vector.<Class>
        {
            return (this._allOfTypes);
        }

        public function get anyOfTypes():Vector.<Class>
        {
            return (this._anyOfTypes);
        }

        public function get descriptor():String
        {
            return (this._descriptor = ((this._descriptor) || (this.createDescriptor())));
        }

        public function get noneOfTypes():Vector.<Class>
        {
            return (this._noneOfTypes);
        }

        public function matches(_arg_1:*):Boolean
        {
            var _local_2:uint = this._allOfTypes.length;
            while (_local_2--)
            {
                if (!(_arg_1 is this._allOfTypes[_local_2]))
                {
                    return (false);
                };
            };
            _local_2 = this._noneOfTypes.length;
            while (_local_2--)
            {
                if ((_arg_1 is this._noneOfTypes[_local_2]))
                {
                    return (false);
                };
            };
            if (((this._anyOfTypes.length == 0) && ((this._allOfTypes.length > 0) || (this._noneOfTypes.length > 0))))
            {
                return (true);
            };
            _local_2 = this._anyOfTypes.length;
            while (_local_2--)
            {
                if ((_arg_1 is this._anyOfTypes[_local_2]))
                {
                    return (true);
                };
            };
            return (false);
        }

        protected function alphabetiseCaseInsensitiveFCQNs(_arg_1:Vector.<Class>):Vector.<String>
        {
            var _local_2:String;
            var _local_3:Vector.<String> = new Vector.<String>(0);
            var _local_4:uint = _arg_1.length;
            var _local_5:uint;
            while (_local_5 < _local_4)
            {
                _local_2 = getQualifiedClassName(_arg_1[_local_5]);
                _local_3[_local_3.length] = _local_2;
                _local_5++;
            };
            _local_3.sort(this.stringSort);
            return (_local_3);
        }

        protected function createDescriptor():String
        {
            var _local_1:Vector.<String> = this.alphabetiseCaseInsensitiveFCQNs(this.allOfTypes);
            var _local_2:Vector.<String> = this.alphabetiseCaseInsensitiveFCQNs(this.anyOfTypes);
            var _local_3:Vector.<String> = this.alphabetiseCaseInsensitiveFCQNs(this.noneOfTypes);
            return ((((("all of: " + _local_1.toString()) + ", any of: ") + _local_2.toString()) + ", none of: ") + _local_3.toString());
        }

        protected function stringSort(_arg_1:String, _arg_2:String):int
        {
            if (_arg_1 < _arg_2)
            {
                return (1);
            };
            return (-1);
        }


    }
}//package robotlegs.bender.extensions.matching

