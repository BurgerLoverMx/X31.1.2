// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.matching.TypeMatcher

package robotlegs.bender.extensions.matching
{
    import __AS3__.vec.Vector;
    import flash.errors.IllegalOperationError;
    import __AS3__.vec.*;

    public class TypeMatcher implements ITypeMatcher, ITypeMatcherFactory 
    {

        protected const _allOfTypes:Vector.<Class> = new Vector.<Class>();
        protected const _anyOfTypes:Vector.<Class> = new Vector.<Class>();
        protected const _noneOfTypes:Vector.<Class> = new Vector.<Class>();

        protected var _typeFilter:ITypeFilter;


        public function allOf(... _args):TypeMatcher
        {
            this.pushAddedTypesTo(_args, this._allOfTypes);
            return (this);
        }

        public function anyOf(... _args):TypeMatcher
        {
            this.pushAddedTypesTo(_args, this._anyOfTypes);
            return (this);
        }

        public function noneOf(... _args):TypeMatcher
        {
            this.pushAddedTypesTo(_args, this._noneOfTypes);
            return (this);
        }

        public function createTypeFilter():ITypeFilter
        {
            return (this._typeFilter = ((this._typeFilter) || (this.buildTypeFilter())));
        }

        public function lock():ITypeMatcherFactory
        {
            this.createTypeFilter();
            return (this);
        }

        public function clone():TypeMatcher
        {
            return (new TypeMatcher().allOf(this._allOfTypes).anyOf(this._anyOfTypes).noneOf(this._noneOfTypes));
        }

        protected function buildTypeFilter():ITypeFilter
        {
            if ((((this._allOfTypes.length == 0) && (this._anyOfTypes.length == 0)) && (this._noneOfTypes.length == 0)))
            {
                throw (new TypeMatcherError(TypeMatcherError.EMPTY_MATCHER));
            };
            return (new TypeFilter(this._allOfTypes, this._anyOfTypes, this._noneOfTypes));
        }

        protected function pushAddedTypesTo(_arg_1:Array, _arg_2:Vector.<Class>):void
        {
            ((this._typeFilter) && (this.throwSealedMatcherError()));
            this.pushValuesToClassVector(_arg_1, _arg_2);
        }

        protected function throwSealedMatcherError():void
        {
            throw (new IllegalOperationError("This TypeMatcher has been sealed and can no longer be configured"));
        }

        protected function pushValuesToClassVector(_arg_1:Array, _arg_2:Vector.<Class>):void
        {
            var _local_3:Class;
            if (((_arg_1.length == 1) && ((_arg_1[0] is Array) || (_arg_1[0] is Vector.<Class>))))
            {
                for each (_local_3 in _arg_1[0])
                {
                    _arg_2.push(_local_3);
                };
            }
            else
            {
                for each (_local_3 in _arg_1)
                {
                    _arg_2.push(_local_3);
                };
            };
        }


    }
}//package robotlegs.bender.extensions.matching

