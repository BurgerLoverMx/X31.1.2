// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.hamcrest.Matcher

package org.hamcrest
{
    public interface Matcher extends SelfDescribing 
    {

        function describeMismatch(_arg_1:Object, _arg_2:Description):void;
        function matches(_arg_1:Object):Boolean;

    }
}//package org.hamcrest

