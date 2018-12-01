// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.viewManager.StageObserverExtension

package robotlegs.bender.extensions.viewManager
{
    import robotlegs.bender.framework.api.IExtension;
    import robotlegs.bender.extensions.viewManager.impl.StageObserver;
    import robotlegs.bender.framework.impl.UID;
    import org.swiftsuspenders.Injector;
    import robotlegs.bender.framework.api.IContext;
    import robotlegs.bender.extensions.viewManager.impl.ContainerRegistry;

    public class StageObserverExtension implements IExtension 
    {

        private static var _stageObserver:StageObserver;
        private static var _installCount:uint;

        private const _uid:String = UID.create(StageObserverExtension);

        private var _injector:Injector;


        public function extend(_arg_1:IContext):void
        {
            _installCount++;
            this._injector = _arg_1.injector;
            _arg_1.lifecycle.whenInitializing(this.whenInitializing);
            _arg_1.lifecycle.whenDestroying(this.whenDestroying);
        }

        public function toString():String
        {
            return (this._uid);
        }

        private function whenInitializing():void
        {
            var _local_1:ContainerRegistry;
            if (_stageObserver == null)
            {
                _local_1 = this._injector.getInstance(ContainerRegistry);
                _stageObserver = new StageObserver(_local_1);
            };
        }

        private function whenDestroying():void
        {
            _installCount--;
            if (_installCount == 0)
            {
                _stageObserver.destroy();
                _stageObserver = null;
            };
        }


    }
}//package robotlegs.bender.extensions.viewManager

