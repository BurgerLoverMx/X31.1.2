// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//mx.core.RSLData

package mx.core
{
    public class RSLData 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";

        private var _applicationDomainTarget:String;
        private var _digest:String;
        private var _hashType:String;
        private var _isSigned:Boolean;
        private var _moduleFactory:IFlexModuleFactory;
        private var _policyFileURL:String;
        private var _rslURL:String;
        private var _verifyDigest:Boolean;

        public function RSLData(_arg_1:String=null, _arg_2:String=null, _arg_3:String=null, _arg_4:String=null, _arg_5:Boolean=false, _arg_6:Boolean=false, _arg_7:String="default")
        {
            this._rslURL = _arg_1;
            this._policyFileURL = _arg_2;
            this._digest = _arg_3;
            this._hashType = _arg_4;
            this._isSigned = _arg_5;
            this._verifyDigest = _arg_6;
            this._applicationDomainTarget = _arg_7;
            this._moduleFactory = this.moduleFactory;
        }

        public function get applicationDomainTarget():String
        {
            return (this._applicationDomainTarget);
        }

        public function get digest():String
        {
            return (this._digest);
        }

        public function get hashType():String
        {
            return (this._hashType);
        }

        public function get isSigned():Boolean
        {
            return (this._isSigned);
        }

        public function get moduleFactory():IFlexModuleFactory
        {
            return (this._moduleFactory);
        }

        public function set moduleFactory(_arg_1:IFlexModuleFactory):void
        {
            this._moduleFactory = _arg_1;
        }

        public function get policyFileURL():String
        {
            return (this._policyFileURL);
        }

        public function get rslURL():String
        {
            return (this._rslURL);
        }

        public function get verifyDigest():Boolean
        {
            return (this._verifyDigest);
        }


    }
}//package mx.core

