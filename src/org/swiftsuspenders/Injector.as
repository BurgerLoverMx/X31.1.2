// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//org.swiftsuspenders.Injector

package org.swiftsuspenders
{
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
    import org.swiftsuspenders.utils.SsInternal;
    import flash.system.ApplicationDomain;
    import org.swiftsuspenders.utils.TypeDescriptor;
    import org.swiftsuspenders.reflection.Reflector;
    import avmplus.DescribeTypeJSON;
    import org.swiftsuspenders.reflection.DescribeTypeJSONReflector;
    import org.swiftsuspenders.reflection.DescribeTypeReflector;
    import flash.utils.getQualifiedClassName;
    import org.swiftsuspenders.mapping.InjectionMapping;
    import org.swiftsuspenders.mapping.MappingEvent;
    import org.swiftsuspenders.errors.InjectorMissingMappingError;
    import org.swiftsuspenders.typedescriptions.ConstructorInjectionPoint;
    import org.swiftsuspenders.dependencyproviders.DependencyProvider;
    import org.swiftsuspenders.typedescriptions.TypeDescription;
    import org.swiftsuspenders.typedescriptions.PreDestroyInjectionPoint;
    import org.swiftsuspenders.errors.InjectorInterfaceConstructionError;
    import org.swiftsuspenders.dependencyproviders.SoftDependencyProvider;
    import org.swiftsuspenders.dependencyproviders.LocalOnlyProvider;
    import flash.utils.getDefinitionByName;
    import org.swiftsuspenders.dependencyproviders.ClassProvider;
    import org.swiftsuspenders.typedescriptions.InjectionPoint;

    use namespace SsInternal;

    public class Injector extends EventDispatcher 
    {

        private static var INJECTION_POINTS_CACHE:Dictionary = new Dictionary(true);

        SsInternal const providerMappings:Dictionary = new Dictionary();

        private var _parentInjector:Injector;
        private var _applicationDomain:ApplicationDomain;
        private var _classDescriptor:TypeDescriptor;
        private var _mappings:Dictionary;
        private var _mappingsInProcess:Dictionary;
        private var _defaultProviders:Dictionary;
        private var _managedObjects:Dictionary;
        private var _reflector:Reflector;

        public function Injector()
        {
            super();
            this._mappings = new Dictionary();
            this._mappingsInProcess = new Dictionary();
            this._defaultProviders = new Dictionary();
            this._managedObjects = new Dictionary();
            try
            {
                this._reflector = ((DescribeTypeJSON.available) ? new DescribeTypeJSONReflector() : new DescribeTypeReflector());
            }
            catch(e:Error)
            {
                _reflector = new DescribeTypeReflector();
            };
            this._classDescriptor = new TypeDescriptor(this._reflector, INJECTION_POINTS_CACHE);
            this._applicationDomain = ApplicationDomain.currentDomain;
        }

        SsInternal static function purgeInjectionPointsCache():void
        {
            INJECTION_POINTS_CACHE = new Dictionary(true);
        }


        public function map(_arg_1:Class, _arg_2:String=""):InjectionMapping
        {
            var _local_3:String = ((getQualifiedClassName(_arg_1) + "|") + _arg_2);
            return ((this._mappings[_local_3]) || (this.createMapping(_arg_1, _arg_2, _local_3)));
        }

        public function unmap(_arg_1:Class, _arg_2:String=""):void
        {
            var _local_3:String = ((getQualifiedClassName(_arg_1) + "|") + _arg_2);
            var _local_4:InjectionMapping = this._mappings[_local_3];
            if (((_local_4) && (_local_4.isSealed)))
            {
                throw (new InjectorError("Can't unmap a sealed mapping"));
            };
            if (!_local_4)
            {
                throw (new InjectorError((("Error while removing an injector mapping: " + "No mapping defined for dependency ") + _local_3)));
            };
            _local_4.getProvider().destroy();
            delete this._mappings[_local_3];
            delete this.providerMappings[_local_3];
            ((hasEventListener(MappingEvent.POST_MAPPING_REMOVE)) && (dispatchEvent(new MappingEvent(MappingEvent.POST_MAPPING_REMOVE, _arg_1, _arg_2, null))));
        }

        public function satisfies(_arg_1:Class, _arg_2:String=""):Boolean
        {
            return (!(this.getProvider(((getQualifiedClassName(_arg_1) + "|") + _arg_2)) == null));
        }

        public function satisfiesDirectly(_arg_1:Class, _arg_2:String=""):Boolean
        {
            return (!(this.providerMappings[((getQualifiedClassName(_arg_1) + "|") + _arg_2)] == null));
        }

        public function getMapping(_arg_1:Class, _arg_2:String=""):InjectionMapping
        {
            var _local_3:String = ((getQualifiedClassName(_arg_1) + "|") + _arg_2);
            var _local_4:InjectionMapping = this._mappings[_local_3];
            if (!_local_4)
            {
                throw (new InjectorMissingMappingError((("Error while retrieving an injector mapping: " + "No mapping defined for dependency ") + _local_3)));
            };
            return (_local_4);
        }

        public function injectInto(_arg_1:Object):void
        {
            var _local_2:Class = this._reflector.getClass(_arg_1);
            this.applyInjectionPoints(_arg_1, _local_2, this._classDescriptor.getDescription(_local_2));
        }

        public function getInstance(_arg_1:Class, _arg_2:String="", _arg_3:Class=null):*
        {
            var _local_4:String;
            var _local_6:ConstructorInjectionPoint;
            _local_4 = ((getQualifiedClassName(_arg_1) + "|") + _arg_2);
            var _local_5:DependencyProvider = this.getProvider(_local_4, false);
            if (_local_5)
            {
                _local_6 = this._classDescriptor.getDescription(_arg_1).ctor;
                return (_local_5.apply(_arg_3, this, ((_local_6) ? _local_6.injectParameters : null)));
            };
            if (_arg_2)
            {
                throw (new InjectorMissingMappingError((("No mapping found for request " + _local_4) + ". getInstance only creates an unmapped instance if no name is given.")));
            };
            return (this.instantiateUnmapped(_arg_1));
        }

        public function destroyInstance(_arg_1:Object):void
        {
            var _local_2:Class;
            if (!_arg_1)
            {
                return;
            };
            _local_2 = this._reflector.getClass(_arg_1);
            var _local_3:TypeDescription = this.getTypeDescription(_local_2);
            var _local_4:PreDestroyInjectionPoint = _local_3.preDestroyMethods;
            while (_local_4)
            {
                _local_4.applyInjection(_arg_1, _local_2, this);
                _local_4 = PreDestroyInjectionPoint(_local_4.next);
            };
        }

        public function teardown():void
        {
            var _local_1:InjectionMapping;
            var _local_2:Object;
            for each (_local_1 in this._mappings)
            {
                _local_1.getProvider().destroy();
            };
            for each (_local_2 in this._managedObjects)
            {
                this.destroyInstance(_local_2);
            };
            this._mappings = new Dictionary();
            this._mappingsInProcess = new Dictionary();
            this._defaultProviders = new Dictionary();
            this._managedObjects = new Dictionary();
        }

        public function createChildInjector(_arg_1:ApplicationDomain=null):Injector
        {
            var _local_2:Injector = new Injector();
            _local_2.applicationDomain = ((_arg_1) || (this.applicationDomain));
            _local_2.parentInjector = this;
            return (_local_2);
        }

        public function set parentInjector(_arg_1:Injector):void
        {
            this._parentInjector = _arg_1;
        }

        public function get parentInjector():Injector
        {
            return (this._parentInjector);
        }

        public function set applicationDomain(_arg_1:ApplicationDomain):void
        {
            this._applicationDomain = ((_arg_1) || (ApplicationDomain.currentDomain));
        }

        public function get applicationDomain():ApplicationDomain
        {
            return (this._applicationDomain);
        }

        public function addTypeDescription(_arg_1:Class, _arg_2:TypeDescription):void
        {
            this._classDescriptor.addDescription(_arg_1, _arg_2);
        }

        public function getTypeDescription(_arg_1:Class):TypeDescription
        {
            return (this._reflector.describeInjections(_arg_1));
        }

        SsInternal function instantiateUnmapped(_arg_1:Class):Object
        {
            var _local_2:TypeDescription = this._classDescriptor.getDescription(_arg_1);
            if (!_local_2.ctor)
            {
                throw (new InjectorInterfaceConstructionError(("Can't instantiate interface " + getQualifiedClassName(_arg_1))));
            };
            var _local_3:* = _local_2.ctor.createInstance(_arg_1, this);
            ((hasEventListener(InjectionEvent.POST_INSTANTIATE)) && (dispatchEvent(new InjectionEvent(InjectionEvent.POST_INSTANTIATE, _local_3, _arg_1))));
            this.applyInjectionPoints(_local_3, _arg_1, _local_2);
            return (_local_3);
        }

        SsInternal function getProvider(_arg_1:String, _arg_2:Boolean=true):DependencyProvider
        {
            var _local_3:DependencyProvider;
            var _local_5:DependencyProvider;
            var _local_4:Injector = this;
            while (_local_4)
            {
                _local_5 = _local_4.providerMappings[_arg_1];
                if (_local_5)
                {
                    if ((_local_5 is SoftDependencyProvider))
                    {
                        _local_3 = _local_5;
                        _local_4 = _local_4.parentInjector;
                        continue;
                    };
                    if (((_local_5 is LocalOnlyProvider) && (!(_local_4 === this))))
                    {
                        _local_4 = _local_4.parentInjector;
                        continue;
                    };
                    return (_local_5);
                };
                _local_4 = _local_4.parentInjector;
            };
            if (_local_3)
            {
                return (_local_3);
            };
            return ((_arg_2) ? this.getDefaultProvider(_arg_1) : null);
        }

        SsInternal function getDefaultProvider(mappingId:String):DependencyProvider
        {
            var parts:Array;
            var definition:Object;
            if (mappingId === "String|")
            {
                return (null);
            };
            parts = mappingId.split("|");
            var name:String = parts.pop();
            if (name.length !== 0)
            {
                return (null);
            };
            var typeName:String = parts.pop();
            try
            {
                definition = ((this._applicationDomain.hasDefinition(typeName)) ? this._applicationDomain.getDefinition(typeName) : getDefinitionByName(typeName));
            }
            catch(e:Error)
            {
                return (null);
            };
            if (((!(definition)) || (!(definition is Class))))
            {
                return (null);
            };
            var type:Class = Class(definition);
            var description:TypeDescription = this._classDescriptor.getDescription(type);
            if (!description.ctor)
            {
                return (null);
            };
            return (this._defaultProviders[type] = ((this._defaultProviders[type]) || (new ClassProvider(type))));
        }

        private function createMapping(_arg_1:Class, _arg_2:String, _arg_3:String):InjectionMapping
        {
            var _local_4:InjectionMapping;
            if (this._mappingsInProcess[_arg_3])
            {
                throw (new InjectorError("Can't change a mapping from inside a listener to it's creation event"));
            };
            this._mappingsInProcess[_arg_3] = true;
            ((hasEventListener(MappingEvent.PRE_MAPPING_CREATE)) && (dispatchEvent(new MappingEvent(MappingEvent.PRE_MAPPING_CREATE, _arg_1, _arg_2, null))));
            _local_4 = new InjectionMapping(this, _arg_1, _arg_2, _arg_3);
            this._mappings[_arg_3] = _local_4;
            var _local_5:Object = _local_4.seal();
            ((hasEventListener(MappingEvent.POST_MAPPING_CREATE)) && (dispatchEvent(new MappingEvent(MappingEvent.POST_MAPPING_CREATE, _arg_1, _arg_2, _local_4))));
            delete this._mappingsInProcess[_arg_3];
            _local_4.unseal(_local_5);
            return (_local_4);
        }

        private function applyInjectionPoints(_arg_1:Object, _arg_2:Class, _arg_3:TypeDescription):void
        {
            var _local_4:InjectionPoint = _arg_3.injectionPoints;
            ((hasEventListener(InjectionEvent.PRE_CONSTRUCT)) && (dispatchEvent(new InjectionEvent(InjectionEvent.PRE_CONSTRUCT, _arg_1, _arg_2))));
            while (_local_4)
            {
                _local_4.applyInjection(_arg_1, _arg_2, this);
                _local_4 = _local_4.next;
            };
            if (_arg_3.preDestroyMethods)
            {
                this._managedObjects[_arg_1] = _arg_1;
            };
            ((hasEventListener(InjectionEvent.POST_CONSTRUCT)) && (dispatchEvent(new InjectionEvent(InjectionEvent.POST_CONSTRUCT, _arg_1, _arg_2))));
        }


    }
}//package org.swiftsuspenders

