// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.mediatorMap.api.IMediatorMap

package robotlegs.bender.extensions.mediatorMap.api
{
    import robotlegs.bender.extensions.matching.ITypeMatcher;
    import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMapper;
    import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorUnmapper;

    public interface IMediatorMap 
    {

        function mapMatcher(_arg_1:ITypeMatcher):IMediatorMapper;
        function map(_arg_1:Class):IMediatorMapper;
        function unmapMatcher(_arg_1:ITypeMatcher):IMediatorUnmapper;
        function unmap(_arg_1:Class):IMediatorUnmapper;
        function mediate(_arg_1:Object):void;
        function unmediate(_arg_1:Object):void;

    }
}//package robotlegs.bender.extensions.mediatorMap.api

