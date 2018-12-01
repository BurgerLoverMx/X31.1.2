// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//mx.resources.ResourceManagerImpl

package mx.resources
{
    import flash.events.EventDispatcher;
    import mx.core.mx_internal;
    import flash.utils.Dictionary;
    import mx.managers.SystemManagerGlobals;
    import flash.events.Event;
    import mx.events.FlexEvent;
    import flash.system.ApplicationDomain;
    import flash.events.FocusEvent;
    import mx.modules.IModuleInfo;
    import flash.utils.Timer;
    import mx.modules.ModuleManager;
    import mx.events.ModuleEvent;
    import mx.events.ResourceEvent;
    import flash.events.TimerEvent;
    import flash.system.SecurityDomain;
    import flash.events.IEventDispatcher;
    import mx.utils.StringUtil;
    import flash.system.Capabilities;

    use namespace mx_internal;

    public class ResourceManagerImpl extends EventDispatcher implements IResourceManager 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";
        private static var instance:IResourceManager;

        private var ignoreMissingBundles:Boolean;
        private var bundleDictionary:Dictionary;
        private var localeMap:Object = {};
        private var resourceModules:Object = {};
        private var initializedForNonFrameworkApp:Boolean = false;
        private var _localeChain:Array;

        public function ResourceManagerImpl()
        {
            if (SystemManagerGlobals.topLevelSystemManagers.length)
            {
                if (SystemManagerGlobals.topLevelSystemManagers[0].currentFrame == 1)
                {
                    this.ignoreMissingBundles = true;
                    SystemManagerGlobals.topLevelSystemManagers[0].addEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
                };
            };
            var _local_1:Object = SystemManagerGlobals.info;
            if (_local_1)
            {
                this.processInfo(_local_1, false);
            };
            this.ignoreMissingBundles = false;
            if (SystemManagerGlobals.topLevelSystemManagers.length)
            {
                SystemManagerGlobals.topLevelSystemManagers[0].addEventListener(FlexEvent.NEW_CHILD_APPLICATION, this.newChildApplicationHandler);
            };
        }

        public static function getInstance():IResourceManager
        {
            if (!instance)
            {
                instance = new (ResourceManagerImpl)();
            };
            return (instance);
        }


        public function get localeChain():Array
        {
            return (this._localeChain);
        }

        public function set localeChain(_arg_1:Array):void
        {
            this._localeChain = _arg_1;
            this.update();
        }

        public function installCompiledResourceBundles(_arg_1:ApplicationDomain, _arg_2:Array, _arg_3:Array, _arg_4:Boolean=false):Array
        {
            var _local_10:String;
            var _local_11:int;
            var _local_12:String;
            var _local_13:IResourceBundle;
            var _local_5:Array = [];
            var _local_6:uint;
            var _local_7:int = ((_arg_2) ? _arg_2.length : 0);
            var _local_8:int = ((_arg_3) ? _arg_3.length : 0);
            var _local_9:int;
            while (_local_9 < _local_7)
            {
                _local_10 = _arg_2[_local_9];
                _local_11 = 0;
                while (_local_11 < _local_8)
                {
                    _local_12 = _arg_3[_local_11];
                    _local_13 = this.installCompiledResourceBundle(_arg_1, _local_10, _local_12, _arg_4);
                    if (_local_13)
                    {
                        var _local_14:* = _local_6++;
                        _local_5[_local_14] = _local_13;
                    };
                    _local_11++;
                };
                _local_9++;
            };
            return (_local_5);
        }

        private function installCompiledResourceBundle(_arg_1:ApplicationDomain, _arg_2:String, _arg_3:String, _arg_4:Boolean=false):IResourceBundle
        {
            var _local_5:String;
            var _local_6:String = _arg_3;
            var _local_7:int = _arg_3.indexOf(":");
            if (_local_7 != -1)
            {
                _local_5 = _arg_3.substring(0, _local_7);
                _local_6 = _arg_3.substring((_local_7 + 1));
            };
            var _local_8:IResourceBundle = this.getResourceBundleInternal(_arg_2, _arg_3, _arg_4);
            if (_local_8)
            {
                return (_local_8);
            };
            var _local_9:* = (((_arg_2 + "$") + _local_6) + "_properties");
            if (_local_5 != null)
            {
                _local_9 = ((_local_5 + ".") + _local_9);
            };
            var _local_10:Class;
            if (_arg_1.hasDefinition(_local_9))
            {
                _local_10 = Class(_arg_1.getDefinition(_local_9));
            };
            if (!_local_10)
            {
                _local_9 = _arg_3;
                if (_arg_1.hasDefinition(_local_9))
                {
                    _local_10 = Class(_arg_1.getDefinition(_local_9));
                };
            };
            if (!_local_10)
            {
                _local_9 = (_arg_3 + "_properties");
                if (_arg_1.hasDefinition(_local_9))
                {
                    _local_10 = Class(_arg_1.getDefinition(_local_9));
                };
            };
            if (!_local_10)
            {
                if (this.ignoreMissingBundles)
                {
                    return (null);
                };
                throw (new Error((((("Could not find compiled resource bundle '" + _arg_3) + "' for locale '") + _arg_2) + "'.")));
            };
            _local_8 = ResourceBundle(new (_local_10)());
            ResourceBundle(_local_8)._locale = _arg_2;
            ResourceBundle(_local_8)._bundleName = _arg_3;
            this.addResourceBundle(_local_8, _arg_4);
            return (_local_8);
        }

        private function newChildApplicationHandler(_arg_1:FocusEvent):void
        {
            var _local_2:Object = _arg_1.relatedObject["info"]();
            var _local_3:Boolean;
            if (("_resourceBundles" in _arg_1.relatedObject))
            {
                _local_3 = true;
            };
            var _local_4:Array = this.processInfo(_local_2, _local_3);
            if (_local_3)
            {
                _arg_1.relatedObject["_resourceBundles"] = _local_4;
            };
        }

        private function processInfo(_arg_1:Object, _arg_2:Boolean):Array
        {
            var _local_3:Array = _arg_1["compiledLocales"];
            ResourceBundle.locale = (((!(_local_3 == null)) && (_local_3.length > 0)) ? _local_3[0] : "en_US");
            var _local_4:String = SystemManagerGlobals.parameters["localeChain"];
            if (((!(_local_4 == null)) && (!(_local_4 == ""))))
            {
                this.localeChain = _local_4.split(",");
            };
            var _local_5:ApplicationDomain = _arg_1["currentDomain"];
            var _local_6:Array = _arg_1["compiledResourceBundleNames"];
            var _local_7:Array = this.installCompiledResourceBundles(_local_5, _local_3, _local_6, _arg_2);
            if (!this.localeChain)
            {
                this.initializeLocaleChain(_local_3);
            };
            return (_local_7);
        }

        public function initializeLocaleChain(_arg_1:Array):void
        {
            this.localeChain = LocaleSorter.sortLocalesByPreference(_arg_1, this.getSystemPreferredLocales(), null, true);
        }

        public function loadResourceModule(url:String, updateFlag:Boolean=true, applicationDomain:ApplicationDomain=null, securityDomain:SecurityDomain=null):IEventDispatcher
        {
            var moduleInfo:IModuleInfo;
            var resourceEventDispatcher:ResourceEventDispatcher;
            var timer:Timer;
            var timerHandler:Function;
            moduleInfo = ModuleManager.getModule(url);
            resourceEventDispatcher = new ResourceEventDispatcher(moduleInfo);
            var readyHandler:Function = function (_arg_1:ModuleEvent):void
            {
                var _local_2:* = _arg_1.module.factory.create();
                resourceModules[_arg_1.module.url].resourceModule = _local_2;
                if (updateFlag)
                {
                    update();
                };
            };
            moduleInfo.addEventListener(ModuleEvent.READY, readyHandler, false, 0, true);
            var errorHandler:Function = function (_arg_1:ModuleEvent):void
            {
                var _local_3:ResourceEvent;
                var _local_2:String = ("Unable to load resource module from " + url);
                if (resourceEventDispatcher.willTrigger(ResourceEvent.ERROR))
                {
                    _local_3 = new ResourceEvent(ResourceEvent.ERROR, _arg_1.bubbles, _arg_1.cancelable);
                    _local_3.bytesLoaded = 0;
                    _local_3.bytesTotal = 0;
                    _local_3.errorText = _local_2;
                    resourceEventDispatcher.dispatchEvent(_local_3);
                }
                else
                {
                    throw (new Error(_local_2));
                };
            };
            moduleInfo.addEventListener(ModuleEvent.ERROR, errorHandler, false, 0, true);
            this.resourceModules[url] = new ResourceModuleInfo(moduleInfo, readyHandler, errorHandler);
            timer = new Timer(0);
            timerHandler = function (_arg_1:TimerEvent):void
            {
                timer.removeEventListener(TimerEvent.TIMER, timerHandler);
                timer.stop();
                moduleInfo.load(applicationDomain, securityDomain);
            };
            timer.addEventListener(TimerEvent.TIMER, timerHandler, false, 0, true);
            timer.start();
            return (resourceEventDispatcher);
        }

        public function unloadResourceModule(_arg_1:String, _arg_2:Boolean=true):void
        {
            var _local_4:Array;
            var _local_5:int;
            var _local_6:int;
            var _local_7:String;
            var _local_8:String;
            var _local_3:ResourceModuleInfo = this.resourceModules[_arg_1];
            if (!_local_3)
            {
                return;
            };
            if (_local_3.resourceModule)
            {
                _local_4 = _local_3.resourceModule.resourceBundles;
                if (_local_4)
                {
                    _local_5 = _local_4.length;
                    _local_6 = 0;
                    while (_local_6 < _local_5)
                    {
                        _local_7 = _local_4[_local_6].locale;
                        _local_8 = _local_4[_local_6].bundleName;
                        this.removeResourceBundle(_local_7, _local_8);
                        _local_6++;
                    };
                };
            };
            this.resourceModules[_arg_1] = null;
            delete this.resourceModules[_arg_1];
            _local_3.moduleInfo.unload();
            if (_arg_2)
            {
                this.update();
            };
        }

        public function addResourceBundle(_arg_1:IResourceBundle, _arg_2:Boolean=false):void
        {
            var _local_3:String = _arg_1.locale;
            var _local_4:String = _arg_1.bundleName;
            if (!this.localeMap[_local_3])
            {
                this.localeMap[_local_3] = {};
            };
            if (_arg_2)
            {
                if (!this.bundleDictionary)
                {
                    this.bundleDictionary = new Dictionary(true);
                };
                this.bundleDictionary[_arg_1] = (_local_3 + _local_4);
                this.localeMap[_local_3][_local_4] = this.bundleDictionary;
            }
            else
            {
                this.localeMap[_local_3][_local_4] = _arg_1;
            };
        }

        public function getResourceBundle(_arg_1:String, _arg_2:String):IResourceBundle
        {
            return (this.getResourceBundleInternal(_arg_1, _arg_2, false));
        }

        private function getResourceBundleInternal(_arg_1:String, _arg_2:String, _arg_3:Boolean):IResourceBundle
        {
            var _local_7:String;
            var _local_8:Object;
            var _local_4:Object = this.localeMap[_arg_1];
            if (!_local_4)
            {
                return (null);
            };
            var _local_5:IResourceBundle;
            var _local_6:Object = _local_4[_arg_2];
            if ((_local_6 is Dictionary))
            {
                if (_arg_3)
                {
                    return (null);
                };
                _local_7 = (_arg_1 + _arg_2);
                for (_local_8 in _local_6)
                {
                    if (_local_6[_local_8] == _local_7)
                    {
                        _local_5 = (_local_8 as IResourceBundle);
                        break;
                    };
                };
            }
            else
            {
                _local_5 = (_local_6 as IResourceBundle);
            };
            return (_local_5);
        }

        public function removeResourceBundle(_arg_1:String, _arg_2:String):void
        {
            delete this.localeMap[_arg_1][_arg_2];
            if (this.getBundleNamesForLocale(_arg_1).length == 0)
            {
                delete this.localeMap[_arg_1];
            };
        }

        public function removeResourceBundlesForLocale(_arg_1:String):void
        {
            delete this.localeMap[_arg_1];
        }

        public function update():void
        {
            dispatchEvent(new Event(Event.CHANGE));
        }

        public function getLocales():Array
        {
            var _local_2:String;
            var _local_1:Array = [];
            for (_local_2 in this.localeMap)
            {
                _local_1.push(_local_2);
            };
            return (_local_1);
        }

        public function getPreferredLocaleChain():Array
        {
            return (LocaleSorter.sortLocalesByPreference(this.getLocales(), this.getSystemPreferredLocales(), null, true));
        }

        public function getBundleNamesForLocale(_arg_1:String):Array
        {
            var _local_3:String;
            var _local_2:Array = [];
            for (_local_3 in this.localeMap[_arg_1])
            {
                _local_2.push(_local_3);
            };
            return (_local_2);
        }

        public function findResourceBundleWithResource(_arg_1:String, _arg_2:String):IResourceBundle
        {
            var _local_5:String;
            var _local_6:Object;
            var _local_7:Object;
            var _local_8:IResourceBundle;
            var _local_9:String;
            var _local_10:Object;
            if (!this._localeChain)
            {
                return (null);
            };
            var _local_3:int = this._localeChain.length;
            var _local_4:int;
            while (_local_4 < _local_3)
            {
                _local_5 = this.localeChain[_local_4];
                _local_6 = this.localeMap[_local_5];
                if (_local_6)
                {
                    _local_7 = _local_6[_arg_1];
                    if (_local_7)
                    {
                        _local_8 = null;
                        if ((_local_7 is Dictionary))
                        {
                            _local_9 = (_local_5 + _arg_1);
                            for (_local_10 in _local_7)
                            {
                                if (_local_7[_local_10] == _local_9)
                                {
                                    _local_8 = (_local_10 as IResourceBundle);
                                    break;
                                };
                            };
                        }
                        else
                        {
                            _local_8 = (_local_7 as IResourceBundle);
                        };
                        if (((_local_8) && (_arg_2 in _local_8.content)))
                        {
                            return (_local_8);
                        };
                    };
                };
                _local_4++;
            };
            return (null);
        }

        [Bindable("change")]
        public function getObject(_arg_1:String, _arg_2:String, _arg_3:String=null):*
        {
            var _local_4:IResourceBundle = this.findBundle(_arg_1, _arg_2, _arg_3);
            if (!_local_4)
            {
                return (undefined);
            };
            return (_local_4.content[_arg_2]);
        }

        [Bindable("change")]
        public function getString(_arg_1:String, _arg_2:String, _arg_3:Array=null, _arg_4:String=null):String
        {
            var _local_5:IResourceBundle = this.findBundle(_arg_1, _arg_2, _arg_4);
            if (!_local_5)
            {
                return (null);
            };
            var _local_6:String = String(_local_5.content[_arg_2]);
            if (_arg_3)
            {
                _local_6 = StringUtil.substitute(_local_6, _arg_3);
            };
            return (_local_6);
        }

        [Bindable("change")]
        public function getStringArray(_arg_1:String, _arg_2:String, _arg_3:String=null):Array
        {
            var _local_4:IResourceBundle = this.findBundle(_arg_1, _arg_2, _arg_3);
            if (!_local_4)
            {
                return (null);
            };
            var _local_5:* = _local_4.content[_arg_2];
            var _local_6:Array = String(_local_5).split(",");
            var _local_7:int = _local_6.length;
            var _local_8:int;
            while (_local_8 < _local_7)
            {
                _local_6[_local_8] = StringUtil.trim(_local_6[_local_8]);
                _local_8++;
            };
            return (_local_6);
        }

        [Bindable("change")]
        public function getNumber(_arg_1:String, _arg_2:String, _arg_3:String=null):Number
        {
            var _local_4:IResourceBundle = this.findBundle(_arg_1, _arg_2, _arg_3);
            if (!_local_4)
            {
                return (NaN);
            };
            var _local_5:* = _local_4.content[_arg_2];
            return (Number(_local_5));
        }

        [Bindable("change")]
        public function getInt(_arg_1:String, _arg_2:String, _arg_3:String=null):int
        {
            var _local_4:IResourceBundle = this.findBundle(_arg_1, _arg_2, _arg_3);
            if (!_local_4)
            {
                return (0);
            };
            var _local_5:* = _local_4.content[_arg_2];
            return (int(_local_5));
        }

        [Bindable("change")]
        public function getUint(_arg_1:String, _arg_2:String, _arg_3:String=null):uint
        {
            var _local_4:IResourceBundle = this.findBundle(_arg_1, _arg_2, _arg_3);
            if (!_local_4)
            {
                return (0);
            };
            var _local_5:* = _local_4.content[_arg_2];
            return (uint(_local_5));
        }

        [Bindable("change")]
        public function getBoolean(_arg_1:String, _arg_2:String, _arg_3:String=null):Boolean
        {
            var _local_4:IResourceBundle = this.findBundle(_arg_1, _arg_2, _arg_3);
            if (!_local_4)
            {
                return (false);
            };
            var _local_5:* = _local_4.content[_arg_2];
            return (String(_local_5).toLowerCase() == "true");
        }

        [Bindable("change")]
        public function getClass(_arg_1:String, _arg_2:String, _arg_3:String=null):Class
        {
            var _local_4:IResourceBundle = this.findBundle(_arg_1, _arg_2, _arg_3);
            if (!_local_4)
            {
                return (null);
            };
            var _local_5:* = _local_4.content[_arg_2];
            return (_local_5 as Class);
        }

        private function findBundle(_arg_1:String, _arg_2:String, _arg_3:String):IResourceBundle
        {
            this.supportNonFrameworkApps();
            return ((_arg_3 != null) ? this.getResourceBundle(_arg_3, _arg_1) : this.findResourceBundleWithResource(_arg_1, _arg_2));
        }

        private function supportNonFrameworkApps():void
        {
            if (this.initializedForNonFrameworkApp)
            {
                return;
            };
            this.initializedForNonFrameworkApp = true;
            if (this.getLocales().length > 0)
            {
                return;
            };
            var _local_1:ApplicationDomain = ApplicationDomain.currentDomain;
            if (!_local_1.hasDefinition("_CompiledResourceBundleInfo"))
            {
                return;
            };
            var _local_2:Class = Class(_local_1.getDefinition("_CompiledResourceBundleInfo"));
            var _local_3:Array = _local_2.compiledLocales;
            var _local_4:Array = _local_2.compiledResourceBundleNames;
            this.installCompiledResourceBundles(_local_1, _local_3, _local_4);
            this.localeChain = _local_3;
        }

        private function getSystemPreferredLocales():Array
        {
            var _local_1:Array;
            if (Capabilities["languages"])
            {
                _local_1 = Capabilities["languages"];
            }
            else
            {
                _local_1 = [Capabilities.language];
            };
            return (_local_1);
        }

        private function dumpResourceModule(_arg_1:*):void
        {
            var _local_2:ResourceBundle;
            var _local_3:String;
            for each (_local_2 in _arg_1.resourceBundles)
            {
                trace(_local_2.locale, _local_2.bundleName);
                for (_local_3 in _local_2.content)
                {
                };
            };
        }

        private function enterFrameHandler(_arg_1:Event):void
        {
            if (SystemManagerGlobals.topLevelSystemManagers.length)
            {
                if (SystemManagerGlobals.topLevelSystemManagers[0].currentFrame == 2)
                {
                    SystemManagerGlobals.topLevelSystemManagers[0].removeEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
                }
                else
                {
                    return;
                };
            };
            var _local_2:Object = SystemManagerGlobals.info;
            if (_local_2)
            {
                this.processInfo(_local_2, false);
            };
        }


    }
}//package mx.resources

import mx.modules.IModuleInfo;
import mx.resources.IResourceModule;
import flash.events.EventDispatcher;
import mx.events.ModuleEvent;
import mx.events.ResourceEvent;

class ResourceModuleInfo 
{

    public var errorHandler:Function;
    public var moduleInfo:IModuleInfo;
    public var readyHandler:Function;
    public var resourceModule:IResourceModule;

    public function ResourceModuleInfo(_arg_1:IModuleInfo, _arg_2:Function, _arg_3:Function)
    {
        this.moduleInfo = _arg_1;
        this.readyHandler = _arg_2;
        this.errorHandler = _arg_3;
    }

}

class ResourceEventDispatcher extends EventDispatcher 
{

    public function ResourceEventDispatcher(_arg_1:IModuleInfo)
    {
        _arg_1.addEventListener(ModuleEvent.ERROR, this.moduleInfo_errorHandler, false, 0, true);
        _arg_1.addEventListener(ModuleEvent.PROGRESS, this.moduleInfo_progressHandler, false, 0, true);
        _arg_1.addEventListener(ModuleEvent.READY, this.moduleInfo_readyHandler, false, 0, true);
    }

    /*private*/ function moduleInfo_errorHandler(_arg_1:ModuleEvent):void
    {
        var _local_2:ResourceEvent = new ResourceEvent(ResourceEvent.ERROR, _arg_1.bubbles, _arg_1.cancelable);
        _local_2.bytesLoaded = _arg_1.bytesLoaded;
        _local_2.bytesTotal = _arg_1.bytesTotal;
        _local_2.errorText = _arg_1.errorText;
        dispatchEvent(_local_2);
    }

    /*private*/ function moduleInfo_progressHandler(_arg_1:ModuleEvent):void
    {
        var _local_2:ResourceEvent = new ResourceEvent(ResourceEvent.PROGRESS, _arg_1.bubbles, _arg_1.cancelable);
        _local_2.bytesLoaded = _arg_1.bytesLoaded;
        _local_2.bytesTotal = _arg_1.bytesTotal;
        dispatchEvent(_local_2);
    }

    /*private*/ function moduleInfo_readyHandler(_arg_1:ModuleEvent):void
    {
        var _local_2:ResourceEvent = new ResourceEvent(ResourceEvent.COMPLETE);
        dispatchEvent(_local_2);
    }


}


