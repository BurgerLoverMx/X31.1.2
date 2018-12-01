// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.framework.impl.guardsApprove

package robotlegs.bender.framework.impl
{
    import org.swiftsuspenders.Injector;

    public function guardsApprove(_arg_1:Array, _arg_2:Injector=null):Boolean
    {
        var _local_3:Object;
        for each (_local_3 in _arg_1)
        {
            if ((_local_3 is Function))
            {
                if ((_local_3 as Function)()) continue;
                return (false);
            };
            if ((_local_3 is Class))
            {
                _local_3 = ((_arg_2) ? _arg_2.getInstance((_local_3 as Class)) : new ((_local_3 as Class))());
            };
            if (_local_3.approve() == false)
            {
                return (false);
            };
        };
        return (true);
    }

}//package robotlegs.bender.framework.impl

