// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.hamcrest.DiagnosingMatcher

package org.hamcrest
{
    import flash.errors.IllegalOperationError;

    public class DiagnosingMatcher extends BaseMatcher 
    {


        override public function describeMismatch(_arg_1:Object, _arg_2:Description):void
        {
            matchesOrDescribesMismatch(_arg_1, _arg_2);
        }

        protected function matchesOrDescribesMismatch(_arg_1:Object, _arg_2:Description):Boolean
        {
            throw (new IllegalOperationError("DiagnosingMatcher#matches is abstract and must be overriden in a subclass"));
        }

        override public function matches(_arg_1:Object):Boolean
        {
            return (matchesOrDescribesMismatch(_arg_1, new NullDescription()));
        }


    }
}//package org.hamcrest

