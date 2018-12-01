// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//robotlegs.bender.framework.impl.ObjectProcessor

package robotlegs.bender.framework.impl
{
    import org.hamcrest.Matcher;

    public class ObjectProcessor 
    {

        private const _handlers:Array = [];


        public function addObjectHandler(_arg_1:Matcher, _arg_2:Function):void
        {
            this._handlers.push(new ObjectHandler(_arg_1, _arg_2));
        }

        public function processObject(_arg_1:Object):void
        {
            var _local_2:ObjectHandler;
            for each (_local_2 in this._handlers)
            {
                _local_2.handle(_arg_1);
            };
        }


    }
}//package robotlegs.bender.framework.impl

import org.hamcrest.Matcher;

class ObjectHandler 
{

    /*private*/ var _matcher:Matcher;
    /*private*/ var _handler:Function;

    public function ObjectHandler(_arg_1:Matcher, _arg_2:Function)
    {
        this._matcher = _arg_1;
        this._handler = _arg_2;
    }

    public function handle(_arg_1:Object):void
    {
        ((this._matcher.matches(_arg_1)) && (this._handler(_arg_1)));
    }


}


