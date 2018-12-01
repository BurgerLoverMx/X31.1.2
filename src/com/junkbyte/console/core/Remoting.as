// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.junkbyte.console.core.Remoting

package com.junkbyte.console.core
{
    import flash.net.LocalConnection;
    import flash.net.Socket;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import com.junkbyte.console.Console;
    import flash.events.StatusEvent;
    import flash.events.AsyncErrorEvent;
    import flash.system.Security;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.ProgressEvent;

    public class Remoting extends ConsoleCore 
    {

        public static const NONE:uint = 0;
        public static const SENDER:uint = 1;
        public static const RECIEVER:uint = 2;

        private var _callbacks:Object = new Object();
        private var _mode:uint;
        private var _local:LocalConnection;
        private var _socket:Socket;
        private var _sendBuffer:ByteArray = new ByteArray();
        private var _recBuffers:Object = new Object();
        private var _senders:Dictionary = new Dictionary();
        private var _lastLogin:String = "";
        private var _loggedIn:Boolean;
        private var _sendID:String;
        private var _lastReciever:String;

        public function Remoting(m:Console)
        {
            super(m);
            this.registerCallback("login", function (_arg_1:ByteArray):void
            {
                login(_arg_1.readUTF());
            });
            this.registerCallback("requestLogin", this.requestLogin);
            this.registerCallback("loginFail", this.loginFail);
            this.registerCallback("loginSuccess", this.loginSuccess);
        }

        public function update():void
        {
            var _local_1:String;
            var _local_2:ByteArray;
            var _local_3:String;
            var _local_4:ByteArray;
            if (this._sendBuffer.length)
            {
                if (((this._socket) && (this._socket.connected)))
                {
                    this._socket.writeBytes(this._sendBuffer);
                    this._sendBuffer = new ByteArray();
                }
                else
                {
                    if (this._local)
                    {
                        this._sendBuffer.position = 0;
                        if (this._sendBuffer.bytesAvailable < 38000)
                        {
                            _local_2 = this._sendBuffer;
                            this._sendBuffer = new ByteArray();
                        }
                        else
                        {
                            _local_2 = new ByteArray();
                            this._sendBuffer.readBytes(_local_2, 0, Math.min(38000, this._sendBuffer.bytesAvailable));
                            _local_4 = new ByteArray();
                            this._sendBuffer.readBytes(_local_4);
                            this._sendBuffer = _local_4;
                        };
                        _local_3 = (config.remotingConnectionName + ((this.remoting == Remoting.RECIEVER) ? SENDER : RECIEVER));
                        this._local.send(_local_3, "synchronize", this._sendID, _local_2);
                    }
                    else
                    {
                        this._sendBuffer = new ByteArray();
                    };
                };
            };
            for (_local_1 in this._recBuffers)
            {
                this.processRecBuffer(_local_1);
            };
        }

        private function processRecBuffer(id:String):void
        {
            var pointer:uint;
            var cmd:String;
            var arg:ByteArray;
            var callbackData:Object;
            var blen:uint;
            var recbuffer:ByteArray;
            if (!this._senders[id])
            {
                this._senders[id] = true;
                if (this._lastReciever)
                {
                    report((("Remote switched to new sender [" + id) + "] as primary."), -2);
                };
                this._lastReciever = id;
            };
            var buffer:ByteArray = this._recBuffers[id];
            try
            {
                pointer = (buffer.position = 0);
                while (buffer.bytesAvailable)
                {
                    cmd = buffer.readUTF();
                    arg = null;
                    if (buffer.bytesAvailable == 0) break;
                    if (buffer.readBoolean())
                    {
                        if (buffer.bytesAvailable == 0) break;
                        blen = buffer.readUnsignedInt();
                        if (buffer.bytesAvailable < blen) break;
                        arg = new ByteArray();
                        buffer.readBytes(arg, 0, blen);
                    };
                    callbackData = this._callbacks[cmd];
                    if (((!(callbackData.latest)) || (id == this._lastReciever)))
                    {
                        if (arg)
                        {
                            callbackData.fun(arg);
                        }
                        else
                        {
                            callbackData.fun();
                        };
                    };
                    pointer = buffer.position;
                };
                if (pointer < buffer.length)
                {
                    recbuffer = new ByteArray();
                    recbuffer.writeBytes(buffer, pointer);
                    this._recBuffers[id] = (buffer = recbuffer);
                }
                else
                {
                    delete this._recBuffers[id];
                };
            }
            catch(err:Error)
            {
                report(("Remoting sync error: " + err), 9);
            };
        }

        private function synchronize(_arg_1:String, _arg_2:Object):void
        {
            if (!(_arg_2 is ByteArray))
            {
                report(("Remoting sync error. Recieved non-ByteArray:" + _arg_2), 9);
                return;
            };
            var _local_3:ByteArray = (_arg_2 as ByteArray);
            var _local_4:ByteArray = this._recBuffers[_arg_1];
            if (_local_4)
            {
                _local_4.position = _local_4.length;
                _local_4.writeBytes(_local_3);
            }
            else
            {
                this._recBuffers[_arg_1] = _local_3;
            };
        }

        public function send(_arg_1:String, _arg_2:ByteArray=null):Boolean
        {
            if (this._mode == NONE)
            {
                return (false);
            };
            this._sendBuffer.position = this._sendBuffer.length;
            this._sendBuffer.writeUTF(_arg_1);
            if (_arg_2)
            {
                this._sendBuffer.writeBoolean(true);
                this._sendBuffer.writeUnsignedInt(_arg_2.length);
                this._sendBuffer.writeBytes(_arg_2);
            }
            else
            {
                this._sendBuffer.writeBoolean(false);
            };
            return (true);
        }

        public function get remoting():uint
        {
            return (this._mode);
        }

        public function get canSend():Boolean
        {
            return ((this._mode == SENDER) && (this._loggedIn));
        }

        public function set remoting(_arg_1:uint):void
        {
            var _local_2:String;
            if (_arg_1 == this._mode)
            {
                return;
            };
            this._sendID = this.generateId();
            if (_arg_1 == SENDER)
            {
                if (!this.startSharedConnection(SENDER))
                {
                    report("Could not create remoting client service. You will not be able to control this console with remote.", 10);
                };
                this._sendBuffer = new ByteArray();
                this._local.addEventListener(StatusEvent.STATUS, this.onSenderStatus, false, 0, true);
                report(("<b>Remoting started.</b> " + this.getInfo()), -1);
                this._loggedIn = this.checkLogin("");
                if (this._loggedIn)
                {
                    this.sendLoginSuccess();
                }
                else
                {
                    this.send("requestLogin");
                };
            }
            else
            {
                if (_arg_1 == RECIEVER)
                {
                    if (this.startSharedConnection(RECIEVER))
                    {
                        this._sendBuffer = new ByteArray();
                        this._local.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.onRemoteAsyncError, false, 0, true);
                        this._local.addEventListener(StatusEvent.STATUS, this.onRecieverStatus, false, 0, true);
                        report(("<b>Remote started.</b> " + this.getInfo()), -1);
                        _local_2 = Security.sandboxType;
                        if (((_local_2 == Security.LOCAL_WITH_FILE) || (_local_2 == Security.LOCAL_WITH_NETWORK)))
                        {
                            report("Untrusted local sandbox. You may not be able to listen for logs properly.", 10);
                            this.printHowToGlobalSetting();
                        };
                        this.login(this._lastLogin);
                    }
                    else
                    {
                        report("Could not create remote service. You might have a console remote already running.", 10);
                    };
                }
                else
                {
                    this.close();
                };
            };
            console.panels.updateMenu();
        }

        public function remotingSocket(_arg_1:String, _arg_2:int=0):void
        {
            if (((this._socket) && (this._socket.connected)))
            {
                this._socket.close();
                this._socket = null;
            };
            if (((_arg_1) && (_arg_2)))
            {
                this.remoting = SENDER;
                report(((("Connecting to socket " + _arg_1) + ":") + _arg_2));
                this._socket = new Socket();
                this._socket.addEventListener(Event.CLOSE, this.socketCloseHandler);
                this._socket.addEventListener(Event.CONNECT, this.socketConnectHandler);
                this._socket.addEventListener(IOErrorEvent.IO_ERROR, this.socketIOErrorHandler);
                this._socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.socketSecurityErrorHandler);
                this._socket.addEventListener(ProgressEvent.SOCKET_DATA, this.socketDataHandler);
                this._socket.connect(_arg_1, _arg_2);
            };
        }

        private function socketCloseHandler(_arg_1:Event):void
        {
            if (_arg_1.currentTarget == this._socket)
            {
                this._socket = null;
            };
        }

        private function socketConnectHandler(_arg_1:Event):void
        {
            report("Remoting socket connected.", -1);
            this._sendBuffer = new ByteArray();
            if (((this._loggedIn) || (this.checkLogin(""))))
            {
                this.sendLoginSuccess();
            }
            else
            {
                this.send("requestLogin");
            };
        }

        private function socketIOErrorHandler(_arg_1:Event):void
        {
            report(("Remoting socket error." + _arg_1), 9);
            this.remotingSocket(null);
        }

        private function socketSecurityErrorHandler(_arg_1:Event):void
        {
            report(("Remoting security error." + _arg_1), 9);
            this.remotingSocket(null);
        }

        private function socketDataHandler(_arg_1:Event):void
        {
            this.handleSocket((_arg_1.currentTarget as Socket));
        }

        public function handleSocket(_arg_1:Socket):void
        {
            if (!this._senders[_arg_1])
            {
                this._senders[_arg_1] = this.generateId();
                this._socket = _arg_1;
            };
            var _local_2:ByteArray = new ByteArray();
            _arg_1.readBytes(_local_2);
            this.synchronize(this._senders[_arg_1], _local_2);
        }

        private function onSenderStatus(_arg_1:StatusEvent):void
        {
            if (((_arg_1.level == "error") && (!((this._socket) && (this._socket.connected)))))
            {
                this._loggedIn = false;
            };
        }

        private function onRecieverStatus(_arg_1:StatusEvent):void
        {
            if (((this.remoting == Remoting.RECIEVER) && (_arg_1.level == "error")))
            {
                report("Problem communicating to client.", 10);
            };
        }

        private function onRemotingSecurityError(_arg_1:SecurityErrorEvent):void
        {
            report("Remoting security error.", 9);
            this.printHowToGlobalSetting();
        }

        private function onRemoteAsyncError(_arg_1:AsyncErrorEvent):void
        {
            report("Problem with remote sync. [<a href='event:remote'>Click here</a>] to restart.", 10);
            this.remoting = NONE;
        }

        private function getInfo():String
        {
            return (((("<p4>channel:" + config.remotingConnectionName) + " (") + Security.sandboxType) + ")</p4>");
        }

        private function printHowToGlobalSetting():void
        {
            report("Make sure your flash file is 'trusted' in Global Security Settings.", -2);
            report("Go to Settings Manager [<a href='event:settings'>click here</a>] &gt; 'Global Security Settings Panel' (on left) &gt; add the location of the local flash (swf) file.", -2);
        }

        private function generateId():String
        {
            return ((new Date().time + ".") + Math.floor((Math.random() * 100000)));
        }

        private function startSharedConnection(targetmode:uint):Boolean
        {
            this.close();
            this._mode = targetmode;
            this._local = new LocalConnection();
            this._local.client = {"synchronize":this.synchronize};
            if (config.allowedRemoteDomain)
            {
                this._local.allowDomain(config.allowedRemoteDomain);
                this._local.allowInsecureDomain(config.allowedRemoteDomain);
            };
            this._local.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onRemotingSecurityError, false, 0, true);
            try
            {
                this._local.connect((config.remotingConnectionName + this._mode));
            }
            catch(err:Error)
            {
                return (false);
            };
            return (true);
        }

        public function registerCallback(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            this._callbacks[_arg_1] = {
                "fun":_arg_2,
                "latest":_arg_3
            };
        }

        private function loginFail():void
        {
            if (this.remoting != Remoting.RECIEVER)
            {
                return;
            };
            report("Login Failed", 10);
            console.panels.mainPanel.requestLogin();
        }

        private function sendLoginSuccess():void
        {
            this._loggedIn = true;
            this.send("loginSuccess");
            dispatchEvent(new Event(Event.CONNECT));
        }

        private function loginSuccess():void
        {
            console.setViewingChannels();
            report("Login Successful", -1);
        }

        private function requestLogin():void
        {
            if (this.remoting != Remoting.RECIEVER)
            {
                return;
            };
            this._sendBuffer = new ByteArray();
            if (this._lastLogin)
            {
                this.login(this._lastLogin);
            }
            else
            {
                console.panels.mainPanel.requestLogin();
            };
        }

        public function login(_arg_1:String=""):void
        {
            var _local_2:ByteArray;
            if (this.remoting == Remoting.RECIEVER)
            {
                this._lastLogin = _arg_1;
                report("Attempting to login...", -1);
                _local_2 = new ByteArray();
                _local_2.writeUTF(_arg_1);
                this.send("login", _local_2);
            }
            else
            {
                if (((this._loggedIn) || (this.checkLogin(_arg_1))))
                {
                    this.sendLoginSuccess();
                }
                else
                {
                    this.send("loginFail");
                };
            };
        }

        private function checkLogin(_arg_1:String):Boolean
        {
            return ((((config.remotingPassword === null) && (config.keystrokePassword == _arg_1)) || (config.remotingPassword === "")) || (config.remotingPassword == _arg_1));
        }

        public function close():void
        {
            if (this._local)
            {
                try
                {
                    this._local.close();
                }
                catch(error:Error)
                {
                    report(("Remote.close: " + error), 10);
                };
            };
            this._mode = NONE;
            this._sendBuffer = new ByteArray();
            this._local = null;
        }


    }
}//package com.junkbyte.console.core

