// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.hamcrest.BaseDescription

package org.hamcrest
{
    import flash.errors.IllegalOperationError;

    public class BaseDescription implements Description 
    {

        private static const charToActionScriptSyntaxMap:Object = {
            '"':'\\"',
            "\n":"\\n",
            "\r":"\\r",
            "\t":"\\t"
        };


        public function appendDescriptionOf(_arg_1:SelfDescribing):Description
        {
            _arg_1.describeTo(this);
            return (this);
        }

        private function toActionScriptSyntax(_arg_1:Object):void
        {
            String(_arg_1).split("").forEach(charToActionScriptSyntax);
        }

        private function toSelfDescribingValue(_arg_1:Object, _arg_2:int=0, _arg_3:Array=null):SelfDescribingValue
        {
            return (new SelfDescribingValue(_arg_1));
        }

        public function appendMismatchOf(_arg_1:Matcher, _arg_2:*):Description
        {
            _arg_1.describeMismatch(_arg_2, this);
            return (this);
        }

        public function appendText(_arg_1:String):Description
        {
            append(_arg_1);
            return (this);
        }

        public function appendValueList(_arg_1:String, _arg_2:String, _arg_3:String, _arg_4:Array):Description
        {
            return (appendList(_arg_1, _arg_2, _arg_3, _arg_4.map(toSelfDescribingValue)));
        }

        public function appendValue(_arg_1:Object):Description
        {
            if (_arg_1 == null)
            {
                append("null");
            }
            else
            {
                if ((_arg_1 is String))
                {
                    append('"');
                    toActionScriptSyntax(_arg_1);
                    append('"');
                }
                else
                {
                    if ((_arg_1 is Number))
                    {
                        append("<");
                        append(_arg_1);
                        append(">");
                    }
                    else
                    {
                        if ((_arg_1 is int))
                        {
                            append("<");
                            append(_arg_1);
                            append(">");
                        }
                        else
                        {
                            if ((_arg_1 is uint))
                            {
                                append("<");
                                append(_arg_1);
                                append(">");
                            }
                            else
                            {
                                if ((_arg_1 is Array))
                                {
                                    appendValueList("[", ",", "]", (_arg_1 as Array));
                                }
                                else
                                {
                                    if ((_arg_1 is XML))
                                    {
                                        append(XML(_arg_1).toXMLString());
                                    }
                                    else
                                    {
                                        append("<");
                                        append(_arg_1);
                                        append(">");
                                    };
                                };
                            };
                        };
                    };
                };
            };
            return (this);
        }

        public function appendList(_arg_1:String, _arg_2:String, _arg_3:String, _arg_4:Array):Description
        {
            var _local_6:Object;
            var _local_5:Boolean;
            append(_arg_1);
            for each (_local_6 in _arg_4)
            {
                if (_local_5)
                {
                    append(_arg_2);
                };
                if ((_local_6 is SelfDescribing))
                {
                    appendDescriptionOf((_local_6 as SelfDescribing));
                }
                else
                {
                    appendValue(_local_6);
                };
                _local_5 = true;
            };
            append(_arg_3);
            return (this);
        }

        protected function append(_arg_1:Object):void
        {
            throw (new IllegalOperationError("BaseDescription#append is abstract and must be overriden by a subclass"));
        }

        public function toString():String
        {
            throw (new IllegalOperationError("BaseDescription#toString is abstract and must be overriden by a subclass"));
        }

        private function charToActionScriptSyntax(_arg_1:String, _arg_2:int=0, _arg_3:Array=null):void
        {
            append(((charToActionScriptSyntaxMap[_arg_1]) || (_arg_1)));
        }


    }
}//package org.hamcrest

import org.hamcrest.SelfDescribing;
import org.hamcrest.Description;

class SelfDescribingValue implements SelfDescribing 
{

    /*private*/ var _value:Object;

    public function SelfDescribingValue(_arg_1:Object)
    {
        _value = _arg_1;
    }

    public function describeTo(_arg_1:Description):void
    {
        _arg_1.appendValue(_value);
    }


}


