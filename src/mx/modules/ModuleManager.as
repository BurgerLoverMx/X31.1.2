// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//mx.modules.ModuleManager

package mx.modules
{
    import mx.core.mx_internal;
    import mx.core.IFlexModuleFactory;

    use namespace mx_internal;

    public class ModuleManager 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";


        public static function getModule(_arg_1:String):IModuleInfo
        {
            return (getSingleton().getModule(_arg_1));
        }

        public static function getAssociatedFactory(_arg_1:Object):IFlexModuleFactory
        {
            return (getSingleton().getAssociatedFactory(_arg_1));
        }

        private static function getSingleton():Object
        {
            if (!ModuleManagerGlobals.managerSingleton)
            {
                ModuleManagerGlobals.managerSingleton = new ModuleManagerImpl();
            };
            return (ModuleManagerGlobals.managerSingleton);
        }


    }
}//package mx.modules

import flash.events.EventDispatcher;
import flash.utils.Dictionary;
import flash.system.ApplicationDomain;
import flash.utils.getQualifiedClassName;
import mx.core.IFlexModuleFactory;
import mx.modules.IModuleInfo;
import flash.display.Loader;
import flash.net.URLRequest;
import flash.system.LoaderContext;
import flash.system.Security;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.system.SecurityDomain;
import flash.utils.ByteArray;
import mx.events.ModuleEvent;
import mx.events.Request;
import flash.events.ErrorEvent;

class ModuleManagerImpl extends EventDispatcher 
{

    /*private*/ var moduleDictionary:Dictionary = new Dictionary(true);


    public function getAssociatedFactory(_arg_1:Object):IFlexModuleFactory
    {
        var _local_3:Object;
        var _local_4:ModuleInfo;
        var _local_5:ApplicationDomain;
        var _local_6:Class;
        var _local_2:String = getQualifiedClassName(_arg_1);
        for (_local_3 in this.moduleDictionary)
        {
            _local_4 = (_local_3 as ModuleInfo);
            if (_local_4.ready)
            {
                _local_5 = _local_4.applicationDomain;
                if (_local_5.hasDefinition(_local_2))
                {
                    _local_6 = Class(_local_5.getDefinition(_local_2));
                    if (((_local_6) && (_arg_1 is _local_6)))
                    {
                        return (_local_4.factory);
                    };
                };
            };
        };
        return (null);
    }

    public function getModule(_arg_1:String):IModuleInfo
    {
        var _local_3:Object;
        var _local_4:ModuleInfo;
        var _local_2:ModuleInfo;
        for (_local_3 in this.moduleDictionary)
        {
            _local_4 = (_local_3 as ModuleInfo);
            if (this.moduleDictionary[_local_4] == _arg_1)
            {
                _local_2 = _local_4;
                break;
            };
        };
        if (!_local_2)
        {
            _local_2 = new ModuleInfo(_arg_1);
            this.moduleDictionary[_local_2] = _arg_1;
        };
        return (new ModuleInfoProxy(_local_2));
    }


}

class ModuleInfo extends EventDispatcher 
{

    /*private*/ var factoryInfo:FactoryInfo;
    /*private*/ var loader:Loader;
    /*private*/ var numReferences:int = 0;
    /*private*/ var parentModuleFactory:IFlexModuleFactory;
    /*private*/ var _error:Boolean = false;
    /*private*/ var _loaded:Boolean = false;
    /*private*/ var _ready:Boolean = false;
    /*private*/ var _setup:Boolean = false;
    /*private*/ var _url:String;

    public function ModuleInfo(_arg_1:String)
    {
        this._url = _arg_1;
    }

    public function get applicationDomain():ApplicationDomain
    {
        return ((this.factoryInfo) ? this.factoryInfo.applicationDomain : null);
    }

    public function get error():Boolean
    {
        return (this._error);
    }

    public function get factory():IFlexModuleFactory
    {
        return ((this.factoryInfo) ? this.factoryInfo.factory : null);
    }

    public function get loaded():Boolean
    {
        return (this._loaded);
    }

    public function get ready():Boolean
    {
        return (this._ready);
    }

    public function get setup():Boolean
    {
        return (this._setup);
    }

    public function get size():int
    {
        return ((this.factoryInfo) ? this.factoryInfo.bytesTotal : 0);
    }

    public function get url():String
    {
        return (this._url);
    }

    public function load(_arg_1:ApplicationDomain=null, _arg_2:SecurityDomain=null, _arg_3:ByteArray=null, _arg_4:IFlexModuleFactory=null):void
    {
        if (this._loaded)
        {
            return;
        };
        this._loaded = true;
        this.parentModuleFactory = _arg_4;
        if (_arg_3)
        {
            this.loadBytes(_arg_1, _arg_3);
            return;
        };
        if (this._url.indexOf("published://") == 0)
        {
            return;
        };
        var _local_5:URLRequest = new URLRequest(this._url);
        var _local_6:LoaderContext = new LoaderContext();
        _local_6.applicationDomain = ((_arg_1) ? _arg_1 : new ApplicationDomain(ApplicationDomain.currentDomain));
        if (((!(_arg_2 == null)) && (Security.sandboxType == Security.REMOTE)))
        {
            _local_6.securityDomain = _arg_2;
        };
        this.loader = new Loader();
        this.loader.contentLoaderInfo.addEventListener(Event.INIT, this.initHandler);
        this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.completeHandler);
        this.loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.progressHandler);
        this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.errorHandler);
        this.loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.errorHandler);
        this.loader.load(_local_5, _local_6);
    }

    /*private*/ function loadBytes(_arg_1:ApplicationDomain, _arg_2:ByteArray):void
    {
        var _local_3:LoaderContext = new LoaderContext();
        _local_3.applicationDomain = ((_arg_1) ? _arg_1 : new ApplicationDomain(ApplicationDomain.currentDomain));
        if (("allowLoadBytesCodeExecution" in _local_3))
        {
            _local_3["allowLoadBytesCodeExecution"] = true;
        };
        this.loader = new Loader();
        this.loader.contentLoaderInfo.addEventListener(Event.INIT, this.initHandler);
        this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.completeHandler);
        this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.errorHandler);
        this.loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.errorHandler);
        this.loader.loadBytes(_arg_2, _local_3);
    }

    public function resurrect():void
    {
        if (!this._ready)
        {
            return;
        };
        if (!this.factoryInfo)
        {
            if (this._loaded)
            {
                dispatchEvent(new ModuleEvent(ModuleEvent.UNLOAD));
            };
            this.loader = null;
            this._loaded = false;
            this._setup = false;
            this._ready = false;
            this._error = false;
        };
    }

    public function release():void
    {
        if (!this._ready)
        {
            this.unload();
        };
    }

    /*private*/ function clearLoader():void
    {
        if (this.loader)
        {
            if (this.loader.contentLoaderInfo)
            {
                this.loader.contentLoaderInfo.removeEventListener(Event.INIT, this.initHandler);
                this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.completeHandler);
                this.loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, this.progressHandler);
                this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.errorHandler);
                this.loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.errorHandler);
            };
            try
            {
                if (this.loader.content)
                {
                    this.loader.content.removeEventListener("ready", this.readyHandler);
                    this.loader.content.removeEventListener("error", this.moduleErrorHandler);
                };
            }
            catch(error:Error)
            {
            };
            if (this._loaded)
            {
                try
                {
                    this.loader.close();
                }
                catch(error:Error)
                {
                };
            };
            try
            {
                this.loader.unload();
            }
            catch(error:Error)
            {
            };
            this.loader = null;
        };
    }

    public function unload():void
    {
        this.clearLoader();
        if (this._loaded)
        {
            dispatchEvent(new ModuleEvent(ModuleEvent.UNLOAD));
        };
        this.factoryInfo = null;
        this.parentModuleFactory = null;
        this._loaded = false;
        this._setup = false;
        this._ready = false;
        this._error = false;
    }

    public function publish(_arg_1:IFlexModuleFactory):void
    {
        if (this.factoryInfo)
        {
            return;
        };
        if (this._url.indexOf("published://") != 0)
        {
            return;
        };
        this.factoryInfo = new FactoryInfo();
        this.factoryInfo.factory = _arg_1;
        this._loaded = true;
        this._setup = true;
        this._ready = true;
        this._error = false;
        dispatchEvent(new ModuleEvent(ModuleEvent.SETUP));
        dispatchEvent(new ModuleEvent(ModuleEvent.PROGRESS));
        dispatchEvent(new ModuleEvent(ModuleEvent.READY));
    }

    public function addReference():void
    {
        this.numReferences++;
    }

    public function removeReference():void
    {
        this.numReferences--;
        if (this.numReferences == 0)
        {
            this.release();
        };
    }

    public function initHandler(_arg_1:Event):void
    {
        var _local_2:ModuleEvent;
        this.factoryInfo = new FactoryInfo();
        try
        {
            this.factoryInfo.factory = (this.loader.content as IFlexModuleFactory);
        }
        catch(error:Error)
        {
        };
        if (!this.factoryInfo.factory)
        {
            _local_2 = new ModuleEvent(ModuleEvent.ERROR, _arg_1.bubbles, _arg_1.cancelable);
            _local_2.bytesLoaded = 0;
            _local_2.bytesTotal = 0;
            _local_2.errorText = "SWF is not a loadable module";
            dispatchEvent(_local_2);
            return;
        };
        this.loader.content.addEventListener("ready", this.readyHandler);
        this.loader.content.addEventListener("error", this.moduleErrorHandler);
        this.loader.content.addEventListener(Request.GET_PARENT_FLEX_MODULE_FACTORY_REQUEST, this.getFlexModuleFactoryRequestHandler, false, 0, true);
        try
        {
            this.factoryInfo.applicationDomain = this.loader.contentLoaderInfo.applicationDomain;
        }
        catch(error:Error)
        {
        };
        this._setup = true;
        dispatchEvent(new ModuleEvent(ModuleEvent.SETUP));
    }

    public function progressHandler(_arg_1:ProgressEvent):void
    {
        var _local_2:ModuleEvent = new ModuleEvent(ModuleEvent.PROGRESS, _arg_1.bubbles, _arg_1.cancelable);
        _local_2.bytesLoaded = _arg_1.bytesLoaded;
        _local_2.bytesTotal = _arg_1.bytesTotal;
        dispatchEvent(_local_2);
    }

    public function completeHandler(_arg_1:Event):void
    {
        var _local_2:ModuleEvent = new ModuleEvent(ModuleEvent.PROGRESS, _arg_1.bubbles, _arg_1.cancelable);
        _local_2.bytesLoaded = this.loader.contentLoaderInfo.bytesLoaded;
        _local_2.bytesTotal = this.loader.contentLoaderInfo.bytesTotal;
        dispatchEvent(_local_2);
    }

    public function errorHandler(_arg_1:ErrorEvent):void
    {
        this._error = true;
        var _local_2:ModuleEvent = new ModuleEvent(ModuleEvent.ERROR, _arg_1.bubbles, _arg_1.cancelable);
        _local_2.bytesLoaded = 0;
        _local_2.bytesTotal = 0;
        _local_2.errorText = _arg_1.text;
        dispatchEvent(_local_2);
    }

    public function getFlexModuleFactoryRequestHandler(_arg_1:Request):void
    {
        _arg_1.value = this.parentModuleFactory;
    }

    public function readyHandler(_arg_1:Event):void
    {
        this._ready = true;
        this.factoryInfo.bytesTotal = this.loader.contentLoaderInfo.bytesTotal;
        var _local_2:ModuleEvent = new ModuleEvent(ModuleEvent.READY);
        _local_2.bytesLoaded = this.loader.contentLoaderInfo.bytesLoaded;
        _local_2.bytesTotal = this.loader.contentLoaderInfo.bytesTotal;
        this.clearLoader();
        dispatchEvent(_local_2);
    }

    public function moduleErrorHandler(_arg_1:Event):void
    {
        var _local_2:ModuleEvent;
        this._ready = true;
        this.factoryInfo.bytesTotal = this.loader.contentLoaderInfo.bytesTotal;
        this.clearLoader();
        if ((_arg_1 is ModuleEvent))
        {
            _local_2 = ModuleEvent(_arg_1);
        }
        else
        {
            _local_2 = new ModuleEvent(ModuleEvent.ERROR);
        };
        dispatchEvent(_local_2);
    }


}

class FactoryInfo 
{

    public var factory:IFlexModuleFactory;
    public var applicationDomain:ApplicationDomain;
    public var bytesTotal:int = 0;


}

class ModuleInfoProxy extends EventDispatcher implements IModuleInfo 
{

    /*private*/ var info:ModuleInfo;
    /*private*/ var referenced:Boolean = false;
    /*private*/ var _data:Object;

    public function ModuleInfoProxy(_arg_1:ModuleInfo)
    {
        this.info = _arg_1;
        _arg_1.addEventListener(ModuleEvent.SETUP, this.moduleEventHandler, false, 0, true);
        _arg_1.addEventListener(ModuleEvent.PROGRESS, this.moduleEventHandler, false, 0, true);
        _arg_1.addEventListener(ModuleEvent.READY, this.moduleEventHandler, false, 0, true);
        _arg_1.addEventListener(ModuleEvent.ERROR, this.moduleEventHandler, false, 0, true);
        _arg_1.addEventListener(ModuleEvent.UNLOAD, this.moduleEventHandler, false, 0, true);
    }

    public function get data():Object
    {
        return (this._data);
    }

    public function set data(_arg_1:Object):void
    {
        this._data = _arg_1;
    }

    public function get error():Boolean
    {
        return (this.info.error);
    }

    public function get factory():IFlexModuleFactory
    {
        return (this.info.factory);
    }

    public function get loaded():Boolean
    {
        return (this.info.loaded);
    }

    public function get ready():Boolean
    {
        return (this.info.ready);
    }

    public function get setup():Boolean
    {
        return (this.info.setup);
    }

    public function get url():String
    {
        return (this.info.url);
    }

    public function publish(_arg_1:IFlexModuleFactory):void
    {
        this.info.publish(_arg_1);
    }

    public function load(_arg_1:ApplicationDomain=null, _arg_2:SecurityDomain=null, _arg_3:ByteArray=null, _arg_4:IFlexModuleFactory=null):void
    {
        var _local_5:ModuleEvent;
        this.info.resurrect();
        if (!this.referenced)
        {
            this.info.addReference();
            this.referenced = true;
        };
        if (this.info.error)
        {
            dispatchEvent(new ModuleEvent(ModuleEvent.ERROR));
        }
        else
        {
            if (this.info.loaded)
            {
                if (this.info.setup)
                {
                    dispatchEvent(new ModuleEvent(ModuleEvent.SETUP));
                    if (this.info.ready)
                    {
                        _local_5 = new ModuleEvent(ModuleEvent.PROGRESS);
                        _local_5.bytesLoaded = this.info.size;
                        _local_5.bytesTotal = this.info.size;
                        dispatchEvent(_local_5);
                        dispatchEvent(new ModuleEvent(ModuleEvent.READY));
                    };
                };
            }
            else
            {
                this.info.load(_arg_1, _arg_2, _arg_3, _arg_4);
            };
        };
    }

    public function release():void
    {
        if (this.referenced)
        {
            this.info.removeReference();
            this.referenced = false;
        };
    }

    public function unload():void
    {
        this.info.unload();
        this.info.removeEventListener(ModuleEvent.SETUP, this.moduleEventHandler);
        this.info.removeEventListener(ModuleEvent.PROGRESS, this.moduleEventHandler);
        this.info.removeEventListener(ModuleEvent.READY, this.moduleEventHandler);
        this.info.removeEventListener(ModuleEvent.ERROR, this.moduleEventHandler);
        this.info.removeEventListener(ModuleEvent.UNLOAD, this.moduleEventHandler);
    }

    /*private*/ function moduleEventHandler(_arg_1:ModuleEvent):void
    {
        dispatchEvent(_arg_1);
    }


}


