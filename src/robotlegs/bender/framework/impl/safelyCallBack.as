// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.framework.impl.safelyCallBack

package robotlegs.bender.framework.impl
{
    public function safelyCallBack(_arg_1:Function, _arg_2:Object=null, _arg_3:Object=null):void
    {
        if (_arg_1.length == 0)
        {
            (_arg_1());
        }
        else
        {
            if (_arg_1.length == 1)
            {
                (_arg_1(_arg_2));
            }
            else
            {
                (_arg_1(_arg_2, _arg_3));
            };
        };
    }

}//package robotlegs.bender.framework.impl

