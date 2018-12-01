// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.hamcrest.core.IsNotMatcher

package org.hamcrest.core
{
    import org.hamcrest.BaseMatcher;
    import org.hamcrest.Matcher;
    import org.hamcrest.Description;

    public class IsNotMatcher extends BaseMatcher 
    {

        private var _matcher:Matcher;

        public function IsNotMatcher(_arg_1:Matcher)
        {
            _matcher = _arg_1;
        }

        override public function matches(_arg_1:Object):Boolean
        {
            return (!(_matcher.matches(_arg_1)));
        }

        override public function describeTo(_arg_1:Description):void
        {
            _arg_1.appendText("not ").appendDescriptionOf(_matcher);
        }


    }
}//package org.hamcrest.core

