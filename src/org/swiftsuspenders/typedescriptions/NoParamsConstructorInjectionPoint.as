// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.swiftsuspenders.typedescriptions.NoParamsConstructorInjectionPoint

package org.swiftsuspenders.typedescriptions
{
    import org.swiftsuspenders.Injector;

    public class NoParamsConstructorInjectionPoint extends ConstructorInjectionPoint 
    {

        public function NoParamsConstructorInjectionPoint()
        {
            super([], 0, injectParameters);
        }

        override public function createInstance(_arg_1:Class, _arg_2:Injector):Object
        {
            return (new (_arg_1)());
        }


    }
}//package org.swiftsuspenders.typedescriptions

