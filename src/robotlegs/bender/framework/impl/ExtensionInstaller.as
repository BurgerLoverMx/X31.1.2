// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.framework.impl.ExtensionInstaller

package robotlegs.bender.framework.impl
{
    import flash.utils.Dictionary;
    import org.swiftsuspenders.reflection.Reflector;
    import org.swiftsuspenders.reflection.DescribeTypeReflector;
    import robotlegs.bender.framework.api.IContext;
    import robotlegs.bender.framework.api.ILogger;

    public class ExtensionInstaller 
    {

        private const _uid:String = UID.create(ExtensionInstaller);
        private const _classes:Dictionary = new Dictionary(true);
        private const _reflector:Reflector = new DescribeTypeReflector();

        private var _context:IContext;
        private var _logger:ILogger;

        public function ExtensionInstaller(_arg_1:IContext)
        {
            this._context = _arg_1;
            this._logger = this._context.getLogger(this);
        }

        public function install(_arg_1:Object):void
        {
            var _local_2:Class;
            if ((_arg_1 is Class))
            {
                ((this._classes[_arg_1]) || (this.install(new ((_arg_1 as Class))())));
            }
            else
            {
                _local_2 = this._reflector.getClass(_arg_1);
                if (this._classes[_local_2])
                {
                    return;
                };
                this._logger.debug("Installing extension {0}", [_arg_1]);
                this._classes[_local_2] = true;
                _arg_1.extend(this._context);
            };
        }

        public function toString():String
        {
            return (this._uid);
        }


    }
}//package robotlegs.bender.framework.impl

