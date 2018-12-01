// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.swiftsuspenders.utils.TypeDescriptor

package org.swiftsuspenders.utils
{
    import flash.utils.Dictionary;
    import org.swiftsuspenders.reflection.Reflector;
    import org.swiftsuspenders.typedescriptions.TypeDescription;

    public class TypeDescriptor 
    {

        public var _descriptionsCache:Dictionary;
        private var _reflector:Reflector;

        public function TypeDescriptor(_arg_1:Reflector, _arg_2:Dictionary)
        {
            this._descriptionsCache = _arg_2;
            this._reflector = _arg_1;
        }

        public function getDescription(_arg_1:Class):TypeDescription
        {
            return (this._descriptionsCache[_arg_1] = ((this._descriptionsCache[_arg_1]) || (this._reflector.describeInjections(_arg_1))));
        }

        public function addDescription(_arg_1:Class, _arg_2:TypeDescription):void
        {
            this._descriptionsCache[_arg_1] = _arg_2;
        }


    }
}//package org.swiftsuspenders.utils

