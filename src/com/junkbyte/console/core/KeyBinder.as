// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.junkbyte.console.core.KeyBinder

package com.junkbyte.console.core
{
    import com.junkbyte.console.Console;
    import com.junkbyte.console.KeyBind;
    import flash.events.KeyboardEvent;
    import flash.text.TextField;
    import flash.text.TextFieldType;

    public class KeyBinder extends ConsoleCore 
    {

        private var _passInd:int;
        private var _binds:Object = {};
        private var _warns:uint;

        public function KeyBinder(_arg_1:Console)
        {
            super(_arg_1);
            _arg_1.cl.addCLCmd("keybinds", this.printBinds, "List all keybinds used");
        }

        public function bindKey(_arg_1:KeyBind, _arg_2:Function, _arg_3:Array=null):void
        {
            if (((config.keystrokePassword) && ((!(_arg_1.useKeyCode)) && (_arg_1.key.charAt(0) == config.keystrokePassword.charAt(0)))))
            {
                report((("Error: KeyBind [" + _arg_1.key) + "] is conflicting with Console password."), 9);
                return;
            };
            if (_arg_2 == null)
            {
                delete this._binds[_arg_1.key];
            }
            else
            {
                this._binds[_arg_1.key] = [_arg_2, _arg_3];
            };
        }

        public function keyDownHandler(_arg_1:KeyboardEvent):void
        {
            this.handleKeyEvent(_arg_1, false);
        }

        public function keyUpHandler(_arg_1:KeyboardEvent):void
        {
            this.handleKeyEvent(_arg_1, true);
        }

        private function handleKeyEvent(_arg_1:KeyboardEvent, _arg_2:Boolean):void
        {
            var _local_4:KeyBind;
            var _local_3:String = String.fromCharCode(_arg_1.charCode);
            if (((((_arg_2) && (!(config.keystrokePassword == null))) && (_local_3)) && (_local_3 == config.keystrokePassword.substring(this._passInd, (this._passInd + 1)))))
            {
                this._passInd++;
                if (this._passInd >= config.keystrokePassword.length)
                {
                    this._passInd = 0;
                    if (this.canTrigger())
                    {
                        if (((console.visible) && (!(console.panels.mainPanel.visible))))
                        {
                            console.panels.mainPanel.visible = true;
                        }
                        else
                        {
                            console.visible = (!(console.visible));
                        };
                        if (((console.visible) && (console.panels.mainPanel.visible)))
                        {
                            console.panels.mainPanel.visible = true;
                            console.panels.mainPanel.moveBackSafePosition();
                        };
                    }
                    else
                    {
                        if (this._warns < 3)
                        {
                            this._warns++;
                            report("Password did not trigger because you have focus on an input TextField.", 8);
                        };
                    };
                };
            }
            else
            {
                if (_arg_2)
                {
                    this._passInd = 0;
                };
                _local_4 = new KeyBind(_arg_1.keyCode, _arg_1.shiftKey, _arg_1.ctrlKey, _arg_1.altKey, _arg_2);
                this.tryRunKey(_local_4.key);
                if (_local_3)
                {
                    _local_4 = new KeyBind(_local_3, _arg_1.shiftKey, _arg_1.ctrlKey, _arg_1.altKey, _arg_2);
                    this.tryRunKey(_local_4.key);
                };
            };
        }

        private function printBinds(... _args):void
        {
            var _local_3:String;
            report("Key binds:", -2);
            var _local_2:uint;
            for (_local_3 in this._binds)
            {
                _local_2++;
                report(_local_3, -2);
            };
            report(("--- Found " + _local_2), -2);
        }

        private function tryRunKey(_arg_1:String):void
        {
            var _local_2:Array = this._binds[_arg_1];
            if (((config.keyBindsEnabled) && (_local_2)))
            {
                if (this.canTrigger())
                {
                    (_local_2[0] as Function).apply(null, _local_2[1]);
                }
                else
                {
                    if (this._warns < 3)
                    {
                        this._warns++;
                        report((("Key bind [" + _arg_1) + "] did not trigger because you have focus on an input TextField."), 8);
                    };
                };
            };
        }

        private function canTrigger():Boolean
        {
            var _local_1:TextField;
            try
            {
                if (((console.stage) && (console.stage.focus is TextField)))
                {
                    _local_1 = (console.stage.focus as TextField);
                    if (_local_1.type == TextFieldType.INPUT)
                    {
                        return (false);
                    };
                };
            }
            catch(err:Error)
            {
            };
            return (true);
        }


    }
}//package com.junkbyte.console.core

