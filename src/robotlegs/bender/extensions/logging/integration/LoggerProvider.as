// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.extensions.logging.integration.LoggerProvider

package robotlegs.bender.extensions.logging.integration
{
    import org.swiftsuspenders.dependencyproviders.DependencyProvider;
    import robotlegs.bender.framework.api.IContext;
    import org.swiftsuspenders.Injector;
    import flash.utils.Dictionary;

    public class LoggerProvider implements DependencyProvider 
    {

        private var _context:IContext;

        public function LoggerProvider(_arg_1:IContext)
        {
            this._context = _arg_1;
        }

        public function apply(_arg_1:Class, _arg_2:Injector, _arg_3:Dictionary):Object
        {
            return (this._context.getLogger(_arg_1));
        }

        public function destroy():void
        {
        }


    }
}//package robotlegs.bender.extensions.logging.integration

