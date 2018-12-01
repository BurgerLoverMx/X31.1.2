// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.swiftsuspenders.reflection.Reflector

package org.swiftsuspenders.reflection
{
    import org.swiftsuspenders.typedescriptions.TypeDescription;

    public interface Reflector 
    {

        function getClass(_arg_1:Object):Class;
        function getFQCN(_arg_1:*, _arg_2:Boolean=false):String;
        function typeImplements(_arg_1:Class, _arg_2:Class):Boolean;
        function describeInjections(_arg_1:Class):TypeDescription;

    }
}//package org.swiftsuspenders.reflection

