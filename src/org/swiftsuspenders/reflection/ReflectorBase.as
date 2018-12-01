// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.swiftsuspenders.reflection.ReflectorBase

package org.swiftsuspenders.reflection
{
    import flash.utils.Proxy;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;

    public class ReflectorBase 
    {


        public function getClass(_arg_1:Object):Class
        {
            if (((((_arg_1 is Proxy) || (_arg_1 is Number)) || (_arg_1 is XML)) || (_arg_1 is XMLList)))
            {
                return (Class(getDefinitionByName(getQualifiedClassName(_arg_1))));
            };
            return (_arg_1.constructor);
        }

        public function getFQCN(_arg_1:*, _arg_2:Boolean=false):String
        {
            var _local_3:String;
            var _local_4:int;
            if ((_arg_1 is String))
            {
                _local_3 = _arg_1;
                if (((!(_arg_2)) && (_local_3.indexOf("::") == -1)))
                {
                    _local_4 = _local_3.lastIndexOf(".");
                    if (_local_4 == -1)
                    {
                        return (_local_3);
                    };
                    return ((_local_3.substring(0, _local_4) + "::") + _local_3.substring((_local_4 + 1)));
                };
            }
            else
            {
                _local_3 = getQualifiedClassName(_arg_1);
            };
            return ((_arg_2) ? _local_3.replace("::", ".") : _local_3);
        }


    }
}//package org.swiftsuspenders.reflection

