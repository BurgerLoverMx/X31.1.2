// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.hamcrest.object.equalTo

package org.hamcrest.object
{
    import org.hamcrest.Matcher;

    public function equalTo(_arg_1:Object):Matcher
    {
        return (new IsEqualMatcher(_arg_1));
    }

}//package org.hamcrest.object

