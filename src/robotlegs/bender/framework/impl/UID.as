// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.framework.impl.UID

package robotlegs.bender.framework.impl
{
    import flash.utils.getQualifiedClassName;

    public class UID 
    {

        private static var _i:uint;


        public static function create(_arg_1:*=null):String
        {
            if ((_arg_1 is Class))
            {
                _arg_1 = getQualifiedClassName(_arg_1).split("::").pop();
            };
            return (((((_arg_1) ? (_arg_1 + "-") : "") + _i++.toString(16)) + "-") + (Math.random() * 0xFF).toString(16));
        }


    }
}//package robotlegs.bender.framework.impl

