// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.hurlant.crypto.hash.IHash

package com.hurlant.crypto.hash
{
    import flash.utils.ByteArray;

    public interface IHash 
    {

        function getInputSize():uint;
        function getHashSize():uint;
        function hash(_arg_1:ByteArray):ByteArray;
        function toString():String;
        function getPadSize():int;

    }
}//package com.hurlant.crypto.hash

