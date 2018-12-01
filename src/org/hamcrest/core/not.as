// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.hamcrest.core.not

package org.hamcrest.core
{
    import org.hamcrest.Matcher;
    import org.hamcrest.object.equalTo;

    public function not(_arg_1:Object):Matcher
    {
        if ((_arg_1 is Matcher))
        {
            return (new IsNotMatcher((_arg_1 as Matcher)));
        };
        return (not(equalTo(_arg_1)));
    }

}//package org.hamcrest.core

