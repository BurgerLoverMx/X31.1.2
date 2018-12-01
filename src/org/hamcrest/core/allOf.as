// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.hamcrest.core.allOf

package org.hamcrest.core
{
    import org.hamcrest.Matcher;

    public function allOf(... _args):Matcher
    {
        var _local_2:Array = _args;
        if (((_args.length == 1) && (_args[0] is Array)))
        {
            _local_2 = _args[0];
        };
        return (new AllOfMatcher(_local_2));
    }

}//package org.hamcrest.core

