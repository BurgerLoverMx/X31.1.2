// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.viewManager.ManualStageObserverExtension

package robotlegs.bender.extensions.viewManager
{
    import robotlegs.bender.framework.api.IExtension;
    import robotlegs.bender.extensions.viewManager.impl.ManualStageObserver;
    import robotlegs.bender.framework.impl.UID;
    import org.swiftsuspenders.Injector;
    import robotlegs.bender.framework.api.IContext;
    import robotlegs.bender.extensions.viewManager.impl.ContainerRegistry;

    public class ManualStageObserverExtension implements IExtension 
    {

        private static var _manualStageObserver:ManualStageObserver;
        private static var _installCount:uint;

        private const _uid:String = UID.create(ManualStageObserverExtension);

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
            if (_manualStageObserver == null)
            {
                _local_1 = this._injector.getInstance(ContainerRegistry);
                _manualStageObserver = new ManualStageObserver(_local_1);
            };
        }

        private function whenDestroying():void
        {
            _installCount--;
            if (_installCount == 0)
            {
                _manualStageObserver.destroy();
                _manualStageObserver = null;
            };
        }


    }
}//package robotlegs.bender.extensions.viewManager

