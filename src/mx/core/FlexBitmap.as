// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//mx.core.FlexBitmap

package mx.core
{
    import flash.display.Bitmap;
    import mx.utils.NameUtil;
    import flash.display.BitmapData;

    public class FlexBitmap extends Bitmap 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";

        public function FlexBitmap(_arg_1:BitmapData=null, _arg_2:String="auto", _arg_3:Boolean=false)
        {
            super(_arg_1, _arg_2, _arg_3);
            try
            {
                name = NameUtil.createUniqueName(this);
            }
            catch(e:Error)
            {
            };
        }

        override public function toString():String
        {
            return (NameUtil.displayObjectToString(this));
        }


    }
}//package mx.core

