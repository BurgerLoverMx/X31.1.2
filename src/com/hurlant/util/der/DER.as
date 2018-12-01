// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.hurlant.util.der.DER

package com.hurlant.util.der
{
    import flash.utils.ByteArray;

    public class DER 
    {

        public static var indent:String = "";


        public static function parse(_arg_1:ByteArray, _arg_2:*=null):IAsn1Type
        {
            var _local_3:int;
            var _local_5:int;
            var _local_6:ByteArray;
            var _local_7:int;
            var _local_8:int;
            var _local_9:Sequence;
            var _local_10:Array;
            var _local_11:Set;
            var _local_12:ByteString;
            var _local_13:PrintableString;
            var _local_14:UTCTime;
            var _local_15:Object;
            var _local_16:Boolean;
            var _local_17:Boolean;
            var _local_18:String;
            var _local_19:*;
            var _local_20:IAsn1Type;
            var _local_21:int;
            var _local_22:ByteArray;
            _local_3 = _arg_1.readUnsignedByte();
            var _local_4:* = (!((_local_3 & 0x20) == 0));
            _local_3 = (_local_3 & 0x1F);
            _local_5 = _arg_1.readUnsignedByte();
            if (_local_5 >= 128)
            {
                _local_7 = (_local_5 & 0x7F);
                _local_5 = 0;
                while (_local_7 > 0)
                {
                    _local_5 = ((_local_5 << 8) | _arg_1.readUnsignedByte());
                    _local_7--;
                };
            };
            switch (_local_3)
            {
                case 0:
                case 16:
                    _local_8 = _arg_1.position;
                    _local_9 = new Sequence(_local_3, _local_5);
                    _local_10 = (_arg_2 as Array);
                    if (_local_10 != null)
                    {
                        _local_10 = _local_10.concat();
                    };
                    while (_arg_1.position < (_local_8 + _local_5))
                    {
                        _local_15 = null;
                        if (_local_10 != null)
                        {
                            _local_15 = _local_10.shift();
                        };
                        if (_local_15 != null)
                        {
                            while (((_local_15) && (_local_15.optional)))
                            {
                                _local_16 = (_local_15.value is Array);
                                _local_17 = isConstructedType(_arg_1);
                                if (_local_16 != _local_17)
                                {
                                    _local_9.push(_local_15.defaultValue);
                                    _local_9[_local_15.name] = _local_15.defaultValue;
                                    _local_15 = _local_10.shift();
                                }
                                else
                                {
                                    break;
                                };
                            };
                        };
                        if (_local_15 != null)
                        {
                            _local_18 = _local_15.name;
                            _local_19 = _local_15.value;
                            if (_local_15.extract)
                            {
                                _local_21 = getLengthOfNextElement(_arg_1);
                                _local_22 = new ByteArray();
                                _local_22.writeBytes(_arg_1, _arg_1.position, _local_21);
                                _local_9[(_local_18 + "_bin")] = _local_22;
                            };
                            _local_20 = DER.parse(_arg_1, _local_19);
                            _local_9.push(_local_20);
                            _local_9[_local_18] = _local_20;
                        }
                        else
                        {
                            _local_9.push(DER.parse(_arg_1));
                        };
                    };
                    return (_local_9);
                case 17:
                    _local_8 = _arg_1.position;
                    _local_11 = new Set(_local_3, _local_5);
                    while (_arg_1.position < (_local_8 + _local_5))
                    {
                        _local_11.push(DER.parse(_arg_1));
                    };
                    return (_local_11);
                case 2:
                    _local_6 = new ByteArray();
                    _arg_1.readBytes(_local_6, 0, _local_5);
                    _local_6.position = 0;
                    return (new Integer(_local_3, _local_5, _local_6));
                case 6:
                    _local_6 = new ByteArray();
                    _arg_1.readBytes(_local_6, 0, _local_5);
                    _local_6.position = 0;
                    return (new ObjectIdentifier(_local_3, _local_5, _local_6));
                default:
                    trace(("I DONT KNOW HOW TO HANDLE DER stuff of TYPE " + _local_3));
                case 3:
                    if (_arg_1[_arg_1.position] == 0)
                    {
                        _arg_1.position++;
                        _local_5--;
                    };
                case 4:
                    _local_12 = new ByteString(_local_3, _local_5);
                    _arg_1.readBytes(_local_12, 0, _local_5);
                    return (_local_12);
                case 5:
                    return (null);
                case 19:
                    _local_13 = new PrintableString(_local_3, _local_5);
                    _local_13.setString(_arg_1.readMultiByte(_local_5, "US-ASCII"));
                    return (_local_13);
                case 34:
                case 20:
                    _local_13 = new PrintableString(_local_3, _local_5);
                    _local_13.setString(_arg_1.readMultiByte(_local_5, "latin1"));
                    return (_local_13);
                case 23:
                    _local_14 = new UTCTime(_local_3, _local_5);
                    _local_14.setUTCTime(_arg_1.readMultiByte(_local_5, "US-ASCII"));
                    return (_local_14);
            };
        }

        private static function getLengthOfNextElement(_arg_1:ByteArray):int
        {
            var _local_4:int;
            var _local_2:uint = _arg_1.position;
            _arg_1.position++;
            var _local_3:int = _arg_1.readUnsignedByte();
            if (_local_3 >= 128)
            {
                _local_4 = (_local_3 & 0x7F);
                _local_3 = 0;
                while (_local_4 > 0)
                {
                    _local_3 = ((_local_3 << 8) | _arg_1.readUnsignedByte());
                    _local_4--;
                };
            };
            _local_3 = (_local_3 + (_arg_1.position - _local_2));
            _arg_1.position = _local_2;
            return (_local_3);
        }

        private static function isConstructedType(_arg_1:ByteArray):Boolean
        {
            var _local_2:int = _arg_1[_arg_1.position];
            return (!((_local_2 & 0x20) == 0));
        }

        public static function wrapDER(_arg_1:int, _arg_2:ByteArray):ByteArray
        {
            var _local_3:ByteArray = new ByteArray();
            _local_3.writeByte(_arg_1);
            var _local_4:int = _arg_2.length;
            if (_local_4 < 128)
            {
                _local_3.writeByte(_local_4);
            }
            else
            {
                if (_local_4 < 0x0100)
                {
                    _local_3.writeByte((0x01 | 0x80));
                    _local_3.writeByte(_local_4);
                }
                else
                {
                    if (_local_4 < 0x10000)
                    {
                        _local_3.writeByte((0x02 | 0x80));
                        _local_3.writeByte((_local_4 >> 8));
                        _local_3.writeByte(_local_4);
                    }
                    else
                    {
                        if (_local_4 < (0x10000 * 0x0100))
                        {
                            _local_3.writeByte((0x03 | 0x80));
                            _local_3.writeByte((_local_4 >> 16));
                            _local_3.writeByte((_local_4 >> 8));
                            _local_3.writeByte(_local_4);
                        }
                        else
                        {
                            _local_3.writeByte((0x04 | 0x80));
                            _local_3.writeByte((_local_4 >> 24));
                            _local_3.writeByte((_local_4 >> 16));
                            _local_3.writeByte((_local_4 >> 8));
                            _local_3.writeByte(_local_4);
                        };
                    };
                };
            };
            _local_3.writeBytes(_arg_2);
            _local_3.position = 0;
            return (_local_3);
        }


    }
}//package com.hurlant.util.der

