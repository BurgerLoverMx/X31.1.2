// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.swiftsuspenders.reflection.DescribeTypeReflector

package org.swiftsuspenders.reflection
{
    import flash.utils.describeType;
    import org.swiftsuspenders.typedescriptions.TypeDescription;
    import flash.utils.Dictionary;
    import org.swiftsuspenders.typedescriptions.NoParamsConstructorInjectionPoint;
    import org.swiftsuspenders.typedescriptions.ConstructorInjectionPoint;
    import org.swiftsuspenders.typedescriptions.PropertyInjectionPoint;
    import org.swiftsuspenders.typedescriptions.MethodInjectionPoint;
    import org.swiftsuspenders.typedescriptions.PostConstructInjectionPoint;
    import org.swiftsuspenders.typedescriptions.PreDestroyInjectionPoint;
    import org.swiftsuspenders.InjectorError;
    import flash.utils.*;

    public class DescribeTypeReflector extends ReflectorBase implements Reflector 
    {

        private var _currentFactoryXML:XML;


        public function typeImplements(type:Class, superType:Class):Boolean
        {
            if (type == superType)
            {
                return (true);
            };
            var factoryDescription:XML = describeType(type).factory[0];
            return (factoryDescription.children().((name() == "implementsInterface") || (name() == "extendsClass")).(attribute("type") == getQualifiedClassName(superType)).length() > 0);
        }

        public function describeInjections(_arg_1:Class):TypeDescription
        {
            this._currentFactoryXML = describeType(_arg_1).factory[0];
            var _local_2:TypeDescription = new TypeDescription(false);
            this.addCtorInjectionPoint(_local_2, _arg_1);
            this.addFieldInjectionPoints(_local_2);
            this.addMethodInjectionPoints(_local_2);
            this.addPostConstructMethodPoints(_local_2);
            this.addPreDestroyMethodPoints(_local_2);
            this._currentFactoryXML = null;
            return (_local_2);
        }

        private function addCtorInjectionPoint(description:TypeDescription, type:Class):void
        {
            var injectParameters:Dictionary;
            var parameters:Array;
            var node:XML = this._currentFactoryXML.constructor[0];
            if (!node)
            {
                if (((this._currentFactoryXML.parent().@name == "Object") || (this._currentFactoryXML.extendsClass.length() > 0)))
                {
                    description.ctor = new NoParamsConstructorInjectionPoint();
                };
                return;
            };
            injectParameters = this.extractNodeParameters(node.parent().metadata.arg);
            var parameterNames:Array = ((injectParameters.name) || ("")).split(",");
            var parameterNodes:XMLList = node.parameter;
            if (parameterNodes.(@type == "*").length() == parameterNodes.@type.length())
            {
                this.createDummyInstance(node, type);
            };
            parameters = this.gatherMethodParameters(parameterNodes, parameterNames);
            var requiredParameters:uint = parameters.required;
            delete parameters.required;
            description.ctor = new ConstructorInjectionPoint(parameters, requiredParameters, injectParameters);
        }

        private function extractNodeParameters(_arg_1:XMLList):Dictionary
        {
            var _local_5:XML;
            var _local_6:String;
            var _local_2:Dictionary = new Dictionary();
            var _local_3:uint = _arg_1.length();
            var _local_4:int;
            while (_local_4 < _local_3)
            {
                _local_5 = _arg_1[_local_4];
                _local_6 = _local_5.@key;
                _local_2[_local_6] = ((_local_2[_local_6]) ? ((_local_2[_local_6] + ",") + _local_5.attribute("value")) : _local_5.attribute("value"));
                _local_4++;
            };
            return (_local_2);
        }

        private function addFieldInjectionPoints(description:TypeDescription):void
        {
            var node:XML;
            var mappingId:String;
            var propertyName:String;
            var injectParameters:Dictionary;
            var injectionPoint:PropertyInjectionPoint;
            for each (node in this._currentFactoryXML.*.((name() == "variable") || (name() == "accessor")).metadata.(@name == "Inject"))
            {
                mappingId = ((node.parent().@type + "|") + node.arg.(@key == "name").attribute("value"));
                propertyName = node.parent().@name;
                injectParameters = this.extractNodeParameters(node.arg);
                injectionPoint = new PropertyInjectionPoint(mappingId, propertyName, (injectParameters.optional == "true"), injectParameters);
                description.addInjectionPoint(injectionPoint);
            };
        }

        private function addMethodInjectionPoints(description:TypeDescription):void
        {
            var node:XML;
            var injectParameters:Dictionary;
            var parameterNames:Array;
            var parameters:Array;
            var requiredParameters:uint;
            var injectionPoint:MethodInjectionPoint;
            for each (node in this._currentFactoryXML.method.metadata.(@name == "Inject"))
            {
                injectParameters = this.extractNodeParameters(node.arg);
                parameterNames = ((injectParameters.name) || ("")).split(",");
                parameters = this.gatherMethodParameters(node.parent().parameter, parameterNames);
                requiredParameters = parameters.required;
                delete parameters.required;
                injectionPoint = new MethodInjectionPoint(node.parent().@name, parameters, requiredParameters, (injectParameters.optional == "true"), injectParameters);
                description.addInjectionPoint(injectionPoint);
            };
        }

        private function addPostConstructMethodPoints(_arg_1:TypeDescription):void
        {
            var _local_2:Array = this.gatherOrderedInjectionPointsForTag(PostConstructInjectionPoint, "PostConstruct");
            var _local_3:int;
            var _local_4:int = _local_2.length;
            while (_local_3 < _local_4)
            {
                _arg_1.addInjectionPoint(_local_2[_local_3]);
                _local_3++;
            };
        }

        private function addPreDestroyMethodPoints(_arg_1:TypeDescription):void
        {
            var _local_2:Array = this.gatherOrderedInjectionPointsForTag(PreDestroyInjectionPoint, "PreDestroy");
            if (!_local_2.length)
            {
                return;
            };
            _arg_1.preDestroyMethods = _local_2[0];
            _arg_1.preDestroyMethods.last = _local_2[0];
            var _local_3:int = 1;
            var _local_4:int = _local_2.length;
            while (_local_3 < _local_4)
            {
                _arg_1.preDestroyMethods.last.next = _local_2[_local_3];
                _arg_1.preDestroyMethods.last = _local_2[_local_3];
                _local_3++;
            };
        }

        private function gatherMethodParameters(_arg_1:XMLList, _arg_2:Array):Array
        {
            var _local_4:uint;
            var _local_7:XML;
            var _local_8:String;
            var _local_9:String;
            var _local_10:Boolean;
            var _local_3:uint;
            _local_4 = _arg_1.length();
            var _local_5:Array = new Array(_local_4);
            var _local_6:int;
            while (_local_6 < _local_4)
            {
                _local_7 = _arg_1[_local_6];
                _local_8 = ((_arg_2[_local_6]) || (""));
                _local_9 = _local_7.@type;
                _local_10 = (_local_7.@optional == "true");
                if (_local_9 == "*")
                {
                    if (!_local_10)
                    {
                        throw (new InjectorError((('Error in method definition of injectee "' + this._currentFactoryXML.@type) + "Required parameters can't have type \"*\".")));
                    };
                    _local_9 = null;
                };
                if (!_local_10)
                {
                    _local_3++;
                };
                _local_5[_local_6] = ((_local_9 + "|") + _local_8);
                _local_6++;
            };
            _local_5.required = _local_3;
            return (_local_5);
        }

        private function gatherOrderedInjectionPointsForTag(injectionPointType:Class, tag:String):Array
        {
            var node:XML;
            var injectParameters:Dictionary;
            var parameterNames:Array;
            var parameters:Array;
            var requiredParameters:uint;
            var order:Number;
            var injectionPoints:Array = [];
            for each (node in this._currentFactoryXML..metadata.(@name == tag))
            {
                injectParameters = this.extractNodeParameters(node.arg);
                parameterNames = ((injectParameters.name) || ("")).split(",");
                parameters = this.gatherMethodParameters(node.parent().parameter, parameterNames);
                requiredParameters = parameters.required;
                delete parameters.required;
                order = parseInt(node.arg.(@key == "order").@value);
                injectionPoints.push(new (injectionPointType)(node.parent().@name, parameters, requiredParameters, ((isNaN(order)) ? int.MAX_VALUE : order)));
            };
            if (injectionPoints.length > 0)
            {
                injectionPoints.sortOn("order", Array.NUMERIC);
            };
            return (injectionPoints);
        }

        private function createDummyInstance(constructorNode:XML, clazz:Class):void
        {
            try
            {
                switch (constructorNode.children().length())
                {
                    case 0:
                        new (clazz)();
                        break;
                    case 1:
                        new (clazz)(null);
                        break;
                    case 2:
                        new (clazz)(null, null);
                        break;
                    case 3:
                        new (clazz)(null, null, null);
                        break;
                    case 4:
                        new (clazz)(null, null, null, null);
                        break;
                    case 5:
                        new (clazz)(null, null, null, null, null);
                        break;
                    case 6:
                        new (clazz)(null, null, null, null, null, null);
                        break;
                    case 7:
                        new (clazz)(null, null, null, null, null, null, null);
                        break;
                    case 8:
                        new (clazz)(null, null, null, null, null, null, null, null);
                        break;
                    case 9:
                        new (clazz)(null, null, null, null, null, null, null, null, null);
                        break;
                    case 10:
                        new (clazz)(null, null, null, null, null, null, null, null, null, null);
                        break;
                };
            }
            catch(error:Error)
            {
                trace(((((("Exception caught while trying to create dummy instance for constructor " + "injection. It's almost certainly ok to ignore this exception, but you ") + "might want to restructure your constructor to prevent errors from ") + "happening. See the Swiftsuspenders documentation for more details.\n") + "The caught exception was:\n") + error));
            };
            constructorNode.setChildren(describeType(clazz).factory.constructor[0].children());
        }


    }
}//package org.swiftsuspenders.reflection

