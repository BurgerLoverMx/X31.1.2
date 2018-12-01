// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.hamcrest.Description

package org.hamcrest
{
    public interface Description 
    {

        function appendValue(_arg_1:Object):Description;
        function appendList(_arg_1:String, _arg_2:String, _arg_3:String, _arg_4:Array):Description;
        function appendDescriptionOf(_arg_1:SelfDescribing):Description;
        function toString():String;
        function appendText(_arg_1:String):Description;
        function appendMismatchOf(_arg_1:Matcher, _arg_2:*):Description;

    }
}//package org.hamcrest

