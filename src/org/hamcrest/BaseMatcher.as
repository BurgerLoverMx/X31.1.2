// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.hamcrest.BaseMatcher

package org.hamcrest
{
    import flash.errors.IllegalOperationError;

    public class BaseMatcher implements Matcher 
    {


        public function describeMismatch(_arg_1:Object, _arg_2:Description):void
        {
            _arg_2.appendText("was ").appendValue(_arg_1);
        }

        public function matches(_arg_1:Object):Boolean
        {
            throw (new IllegalOperationError("BaseMatcher#matches must be override by subclass"));
        }

        public function describeTo(_arg_1:Description):void
        {
            throw (new IllegalOperationError("BaseMatcher#describeTo must be override by subclass"));
        }

        public function toString():String
        {
            return (StringDescription.toString(this));
        }


    }
}//package org.hamcrest

