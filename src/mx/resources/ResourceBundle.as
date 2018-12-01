// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//mx.resources.ResourceBundle

package mx.resources
{
    import mx.core.mx_internal;
    import flash.system.ApplicationDomain;

    use namespace mx_internal;

    public class ResourceBundle implements IResourceBundle 
    {

        mx_internal static const VERSION:String = "4.6.0.0";
        mx_internal static var locale:String;
        mx_internal static var backupApplicationDomain:ApplicationDomain;

        mx_internal var _bundleName:String;
        private var _content:Object = {};
        mx_internal var _locale:String;

        public function ResourceBundle(_arg_1:String=null, _arg_2:String=null)
        {
            this._locale = _arg_1;
            this._bundleName = _arg_2;
            this._content = this.getContent();
        }

        private static function getClassByName(_arg_1:String, _arg_2:ApplicationDomain):Class
        {
            var _local_3:Class;
            if (_arg_2.hasDefinition(_arg_1))
            {
                _local_3 = (_arg_2.getDefinition(_arg_1) as Class);
            };
            return (_local_3);
        }


        public function get bundleName():String
        {
            return (this._bundleName);
        }

        public function get content():Object
        {
            return (this._content);
        }

        public function get locale():String
        {
            return (this._locale);
        }

        protected function getContent():Object
        {
            return ({});
        }

        private function _getObject(_arg_1:String):Object
        {
            var _local_2:Object = this.content[_arg_1];
            if (!_local_2)
            {
                throw (new Error(((("Key " + _arg_1) + " was not found in resource bundle ") + this.bundleName)));
            };
            return (_local_2);
        }


    }
}//package mx.resources

