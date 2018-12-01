// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.swiftsuspenders.dependencyproviders.DependencyProvider

package org.swiftsuspenders.dependencyproviders
{
    import org.swiftsuspenders.Injector;
    import flash.utils.Dictionary;

    public interface DependencyProvider 
    {

        function apply(_arg_1:Class, _arg_2:Injector, _arg_3:Dictionary):Object;
        function destroy():void;

    }
}//package org.swiftsuspenders.dependencyproviders

