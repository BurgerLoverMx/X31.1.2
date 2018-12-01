// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.framework.impl.applyHooks

package robotlegs.bender.framework.impl
{
    import org.swiftsuspenders.Injector;

    public function applyHooks(_arg_1:Array, _arg_2:Injector=null):void
    {
        var _local_3:Object;
        for each (_local_3 in _arg_1)
        {
            if ((_local_3 is Function))
            {
                ((_local_3 as Function)());
            }
            else
            {
                if ((_local_3 is Class))
                {
                    _local_3 = ((_arg_2) ? _arg_2.getInstance((_local_3 as Class)) : new ((_local_3 as Class))());
                };
                _local_3.hook();
            };
        };
    }

}//package robotlegs.bender.framework.impl

