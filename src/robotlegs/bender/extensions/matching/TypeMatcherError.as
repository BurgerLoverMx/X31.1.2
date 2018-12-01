// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.matching.TypeMatcherError

package robotlegs.bender.extensions.matching
{
    public class TypeMatcherError extends Error 
    {

        public static const EMPTY_MATCHER:String = "An empty matcher will create a filter which matches nothing. You should specify at least one condition for the filter.";

        public function TypeMatcherError(_arg_1:String)
        {
            super(_arg_1);
        }

    }
}//package robotlegs.bender.extensions.matching

