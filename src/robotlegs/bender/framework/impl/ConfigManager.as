// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.framework.impl.ConfigManager

package robotlegs.bender.framework.impl
{
    import org.hamcrest.Matcher;
    import org.hamcrest.core.allOf;
    import org.hamcrest.object.instanceOf;
    import org.hamcrest.core.not;
    import flash.display.DisplayObject;
    import flash.utils.Dictionary;
    import org.swiftsuspenders.Injector;
    import robotlegs.bender.framework.api.ILogger;
    import robotlegs.bender.framework.api.LifecycleEvent;
    import robotlegs.bender.framework.api.IContext;
    import robotlegs.bender.framework.api.IConfig;

    public class ConfigManager 
    {

        private static const plainObjectMatcher:Matcher = allOf(instanceOf(Object), not(instanceOf(Class)), not(instanceOf(DisplayObject)));

        private const _uid:String = UID.create(ConfigManager);
        private const _objectProcessor:ObjectProcessor = new ObjectProcessor();
        private const _configs:Dictionary = new Dictionary();
        private const _queue:Array = [];

        private var _injector:Injector;
        private var _logger:ILogger;
        private var _initialized:Boolean;

        public function ConfigManager(_arg_1:IContext)
        {
            this._injector = _arg_1.injector;
            this._logger = _arg_1.getLogger(this);
            this.addConfigHandler(instanceOf(Class), this.handleClass);
            this.addConfigHandler(plainObjectMatcher, this.handleObject);
            _arg_1.lifecycle.addEventListener(LifecycleEvent.INITIALIZE, this.initialize, false, -100);
        }

        public function addConfig(_arg_1:Object):void
        {
            if (!this._configs[_arg_1])
            {
                this._configs[_arg_1] = true;
                this._objectProcessor.processObject(_arg_1);
            };
        }

        public function addConfigHandler(_arg_1:Matcher, _arg_2:Function):void
        {
            this._objectProcessor.addObjectHandler(_arg_1, _arg_2);
        }

        public function toString():String
        {
            return (this._uid);
        }

        private function initialize(_arg_1:LifecycleEvent):void
        {
            if (!this._initialized)
            {
                this._initialized = true;
                this.processQueue();
            };
        }

        private function handleClass(_arg_1:Class):void
        {
            if (this._initialized)
            {
                this._logger.debug("Already initialized. Instantiating config class {0}", [_arg_1]);
                this.processClass(_arg_1);
            }
            else
            {
                this._logger.debug("Not yet initialized. Queuing config class {0}", [_arg_1]);
                this._queue.push(_arg_1);
            };
        }

        private function handleObject(_arg_1:Object):void
        {
            if (this._initialized)
            {
                this._logger.debug("Already initialized. Injecting into config object {0}", [_arg_1]);
                this.processObject(_arg_1);
            }
            else
            {
                this._logger.debug("Not yet initialized. Queuing config object {0}", [_arg_1]);
                this._queue.push(_arg_1);
            };
        }

        private function processQueue():void
        {
            var _local_1:Object;
            for each (_local_1 in this._queue)
            {
                if ((_local_1 is Class))
                {
                    this._logger.debug("Now initializing. Instantiating config class {0}", [_local_1]);
                    this.processClass((_local_1 as Class));
                }
                else
                {
                    this._logger.debug("Now initializing. Injecting into config object {0}", [_local_1]);
                    this.processObject(_local_1);
                };
            };
            this._queue.length = 0;
        }

        private function processClass(_arg_1:Class):void
        {
            var _local_2:IConfig = (this._injector.getInstance(_arg_1) as IConfig);
            ((_local_2) && (_local_2.configure()));
        }

        private function processObject(_arg_1:Object):void
        {
            this._injector.injectInto(_arg_1);
            var _local_2:IConfig = (_arg_1 as IConfig);
            ((_local_2) && (_local_2.configure()));
        }


    }
}//package robotlegs.bender.framework.impl

