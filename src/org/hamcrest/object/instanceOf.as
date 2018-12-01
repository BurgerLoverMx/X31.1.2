// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.hamcrest.object.instanceOf

package org.hamcrest.object
{
    import org.hamcrest.Matcher;

    public function instanceOf(_arg_1:Class):Matcher
    {
        return (new IsInstanceOfMatcher(_arg_1));
    }

}//package org.hamcrest.object

