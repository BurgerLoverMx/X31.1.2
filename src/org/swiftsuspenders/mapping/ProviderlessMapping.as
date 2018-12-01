// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.swiftsuspenders.mapping.ProviderlessMapping

package org.swiftsuspenders.mapping
{
    import org.swiftsuspenders.dependencyproviders.DependencyProvider;

    public interface ProviderlessMapping 
    {

        function toType(_arg_1:Class):UnsealedMapping;
        function toValue(_arg_1:Object):UnsealedMapping;
        function toSingleton(_arg_1:Class):UnsealedMapping;
        function asSingleton():UnsealedMapping;
        function toProvider(_arg_1:DependencyProvider):UnsealedMapping;
        function seal():Object;

    }
}//package org.swiftsuspenders.mapping

