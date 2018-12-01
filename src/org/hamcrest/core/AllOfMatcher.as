// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.hamcrest.core.AllOfMatcher

package org.hamcrest.core
{
    import org.hamcrest.DiagnosingMatcher;
    import org.hamcrest.Matcher;
    import org.hamcrest.Description;

    public class AllOfMatcher extends DiagnosingMatcher 
    {

        private var _matchers:Array;

        public function AllOfMatcher(_arg_1:Array)
        {
            _matchers = ((_arg_1) || ([]));
        }

        override protected function matchesOrDescribesMismatch(_arg_1:Object, _arg_2:Description):Boolean
        {
            var _local_3:Matcher;
            for each (_local_3 in _matchers)
            {
                if (!_local_3.matches(_arg_1))
                {
                    _arg_2.appendDescriptionOf(_local_3).appendText(" ").appendMismatchOf(_local_3, _arg_1);
                    return (false);
                };
            };
            return (true);
        }

        override public function describeTo(_arg_1:Description):void
        {
            _arg_1.appendList("(", " and ", ")", _matchers);
        }


    }
}//package org.hamcrest.core

