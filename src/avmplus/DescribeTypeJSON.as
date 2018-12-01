// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//avmplus.DescribeTypeJSON

package avmplus
{
    public class DescribeTypeJSON 
    {

        public static var available:Boolean = (!(describeTypeJSON == null));
        public static const INSTANCE_FLAGS:uint = (((((((((INCLUDE_BASES | INCLUDE_INTERFACES) | INCLUDE_VARIABLES) | INCLUDE_ACCESSORS) | INCLUDE_METHODS) | INCLUDE_METADATA) | INCLUDE_CONSTRUCTOR) | INCLUDE_TRAITS) | USE_ITRAITS) | HIDE_OBJECT);
        public static const CLASS_FLAGS:uint = ((((((INCLUDE_INTERFACES | INCLUDE_VARIABLES) | INCLUDE_ACCESSORS) | INCLUDE_METHODS) | INCLUDE_METADATA) | INCLUDE_TRAITS) | HIDE_OBJECT);


        public function describeType(_arg_1:Object, _arg_2:uint):Object
        {
            return (describeTypeJSON(_arg_1, _arg_2));
        }

        public function getInstanceDescription(_arg_1:Class):Object
        {
            return (describeTypeJSON(_arg_1, INSTANCE_FLAGS));
        }

        public function getClassDescription(_arg_1:Class):Object
        {
            return (describeTypeJSON(_arg_1, CLASS_FLAGS));
        }


    }
}//package avmplus

