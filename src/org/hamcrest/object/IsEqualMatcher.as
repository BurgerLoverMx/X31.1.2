// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.hamcrest.object.IsEqualMatcher

package org.hamcrest.object
{
    import org.hamcrest.BaseMatcher;
    import org.hamcrest.Description;

    public class IsEqualMatcher extends BaseMatcher 
    {

        private var _value:Object;

        public function IsEqualMatcher(_arg_1:Object)
        {
            _value = _arg_1;
        }

        private function areEqual(_arg_1:Object, _arg_2:Object):Boolean
        {
            if (isNaN((_arg_1 as Number)))
            {
                return (isNaN((_arg_2 as Number)));
            };
            if (_arg_1 == null)
            {
                return (_arg_2 == null);
            };
            if ((_arg_1 is Array))
            {
                return ((_arg_2 is Array) && (areArraysEqual((_arg_1 as Array), (_arg_2 as Array))));
            };
            return (_arg_1 == _arg_2);
        }

        private function areArraysEqual(_arg_1:Array, _arg_2:Array):Boolean
        {
            return ((areArraysLengthsEqual(_arg_1, _arg_2)) && (areArrayElementsEqual(_arg_1, _arg_2)));
        }

        override public function describeTo(_arg_1:Description):void
        {
            _arg_1.appendValue(_value);
        }

        private function areArrayElementsEqual(_arg_1:Array, _arg_2:Array):Boolean
        {
            var _local_3:int;
            var _local_4:int = _arg_1.length;
            while (_local_3 < _local_4)
            {
                if (!areEqual(_arg_1[_local_3], _arg_2[_local_3]))
                {
                    return (false);
                };
                _local_3++;
            };
            return (true);
        }

        override public function matches(_arg_1:Object):Boolean
        {
            return (areEqual(_arg_1, _value));
        }

        private function areArraysLengthsEqual(_arg_1:Array, _arg_2:Array):Boolean
        {
            return (_arg_1.length == _arg_2.length);
        }


    }
}//package org.hamcrest.object

