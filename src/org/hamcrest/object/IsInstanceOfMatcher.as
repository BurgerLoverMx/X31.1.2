// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.hamcrest.object.IsInstanceOfMatcher

package org.hamcrest.object
{
    import org.hamcrest.BaseMatcher;
    import flash.utils.getQualifiedClassName;
    import org.hamcrest.Description;

    public class IsInstanceOfMatcher extends BaseMatcher 
    {

        private var _typeName:String;
        private var _type:Class;

        public function IsInstanceOfMatcher(_arg_1:Class)
        {
            _type = _arg_1;
            _typeName = getQualifiedClassName(_arg_1);
        }

        override public function describeTo(_arg_1:Description):void
        {
            _arg_1.appendText("an instance of ").appendText(_typeName);
        }

        override public function matches(_arg_1:Object):Boolean
        {
            return (_arg_1 is _type);
        }


    }
}//package org.hamcrest.object

