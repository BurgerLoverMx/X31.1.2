// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.junkbyte.console.core.CommandLine

package com.junkbyte.console.core
{
    import com.junkbyte.console.vos.WeakObject;
    import com.junkbyte.console.vos.WeakRef;
    import flash.utils.ByteArray;
    import flash.events.Event;
    import com.junkbyte.console.Console;
    import flash.utils.getQualifiedClassName;
    import flash.display.DisplayObjectContainer;

    public class CommandLine extends ConsoleCore 
    {

        private static const DISABLED:String = "<b>Advanced CommandLine is disabled.</b>\nEnable by setting `Cc.config.commandLineAllowed = true;´\nType <b>/commands</b> for permitted commands.";
        private static const RESERVED:Array = [Executer.RETURNED, "base", "C"];

        private var _saved:WeakObject;
        private var _scope:*;
        private var _prevScope:WeakRef;
        private var _scopeStr:String = "";
        private var _slashCmds:Object;
        public var localCommands:Array = new Array("filter", "filterexp");

        public function CommandLine(m:Console)
        {
            super(m);
            this._saved = new WeakObject();
            this._scope = m;
            this._slashCmds = new Object();
            this._prevScope = new WeakRef(m);
            this._saved.set("C", m);
            remoter.registerCallback("cmd", function (_arg_1:ByteArray):void
            {
                run(_arg_1.readUTF());
            });
            remoter.registerCallback("scope", function (_arg_1:ByteArray):void
            {
                handleScopeEvent(_arg_1.readUnsignedInt());
            });
            remoter.registerCallback("cls", this.handleScopeString);
            remoter.addEventListener(Event.CONNECT, this.sendCmdScope2Remote);
            this.addCLCmd("help", this.printHelp, "How to use command line");
            this.addCLCmd("save|store", this.saveCmd, "Save current scope as weak reference. (same as Cc.store(...))");
            this.addCLCmd("savestrong|storestrong", this.saveStrongCmd, "Save current scope as strong reference");
            this.addCLCmd("saved|stored", this.savedCmd, "Show a list of all saved references");
            this.addCLCmd("string", this.stringCmd, "Create String, useful to paste complex strings without worrying about \" or '", false, null);
            this.addCLCmd("commands", this.cmdsCmd, "Show a list of all slash commands", true);
            this.addCLCmd("inspect", this.inspectCmd, "Inspect current scope");
            this.addCLCmd("explode", this.explodeCmd, "Explode current scope to its properties and values (similar to JSON)");
            this.addCLCmd("map", this.mapCmd, "Get display list map starting from current scope");
            this.addCLCmd("function", this.funCmd, "Create function. param is the commandline string to create as function. (experimental)");
            this.addCLCmd("autoscope", this.autoscopeCmd, "Toggle autoscoping.");
            this.addCLCmd("base", this.baseCmd, "Return to base scope");
            this.addCLCmd("/", this.prevCmd, "Return to previous scope");
        }

        public function set base(_arg_1:Object):void
        {
            if (this.base)
            {
                report(((("Set new commandLine base from " + this.base) + " to ") + _arg_1), 10);
            }
            else
            {
                this._prevScope.reference = this._scope;
                this._scope = _arg_1;
                this._scopeStr = LogReferences.ShortClassName(_arg_1, false);
            };
            this._saved.set("base", _arg_1);
        }

        public function get base():Object
        {
            return (this._saved.get("base"));
        }

        public function handleScopeString(_arg_1:ByteArray):void
        {
            this._scopeStr = _arg_1.readUTF();
        }

        public function handleScopeEvent(_arg_1:uint):void
        {
            var _local_2:ByteArray;
            var _local_3:*;
            if (remoter.remoting == Remoting.RECIEVER)
            {
                _local_2 = new ByteArray();
                _local_2.writeUnsignedInt(_arg_1);
                remoter.send("scope", _local_2);
            }
            else
            {
                _local_3 = console.refs.getRefById(_arg_1);
                if (_local_3)
                {
                    console.cl.setReturned(_local_3, true, false);
                }
                else
                {
                    console.report("Reference no longer exist.", -2);
                };
            };
        }

        public function store(_arg_1:String, _arg_2:Object, _arg_3:Boolean=false):void
        {
            if (!_arg_1)
            {
                report("ERROR: Give a name to save.", 10);
                return;
            };
            if ((_arg_2 is Function))
            {
                _arg_3 = true;
            };
            _arg_1 = _arg_1.replace(/[^\w]*/g, "");
            if (RESERVED.indexOf(_arg_1) >= 0)
            {
                report((("ERROR: The name [" + _arg_1) + "] is reserved"), 10);
                return;
            };
            this._saved.set(_arg_1, _arg_2, _arg_3);
        }

        public function getHintsFor(str:String, max:uint):Array
        {
            var X:String;
            var canadate:Array;
            var cmd:Object;
            var Y:String;
            var all:Array = new Array();
            for (X in this._slashCmds)
            {
                cmd = this._slashCmds[X];
                if (((config.commandLineAllowed) || (cmd.allow)))
                {
                    all.push([(("/" + X) + " "), ((cmd.d) ? cmd.d : null)]);
                };
            };
            if (config.commandLineAllowed)
            {
                for (Y in this._saved)
                {
                    all.push([("$" + Y), LogReferences.ShortClassName(this._saved.get(Y))]);
                };
                if (this._scope)
                {
                    all.push(["this", LogReferences.ShortClassName(this._scope)]);
                    all = all.concat(console.refs.getPossibleCalls(this._scope));
                };
            };
            str = str.toLowerCase();
            var hints:Array = new Array();
            for each (canadate in all)
            {
                if (canadate[0].toLowerCase().indexOf(str) == 0)
                {
                    hints.push(canadate);
                };
            };
            hints = hints.sort(function (_arg_1:Array, _arg_2:Array):int
            {
                if (_arg_1[0].length < _arg_2[0].length)
                {
                    return (-1);
                };
                if (_arg_1[0].length > _arg_2[0].length)
                {
                    return (1);
                };
                return (0);
            });
            if (((max > 0) && (hints.length > max)))
            {
                hints.splice(max);
                hints.push(["..."]);
            };
            return (hints);
        }

        public function get scopeString():String
        {
            return ((config.commandLineAllowed) ? this._scopeStr : "");
        }

        public function addCLCmd(_arg_1:String, _arg_2:Function, _arg_3:String, _arg_4:Boolean=false, _arg_5:String=";"):void
        {
            var _local_6:Array = _arg_1.split("|");
            var _local_7:int;
            while (_local_7 < _local_6.length)
            {
                _arg_1 = _local_6[_local_7];
                this._slashCmds[_arg_1] = new SlashCommand(_arg_1, _arg_2, _arg_3, false, _arg_4, _arg_5);
                if (_local_7 > 0)
                {
                    this._slashCmds.setPropertyIsEnumerable(_arg_1, false);
                };
                _local_7++;
            };
        }

        public function addSlashCommand(_arg_1:String, _arg_2:Function, _arg_3:String="", _arg_4:Boolean=true, _arg_5:String=";"):void
        {
            var _local_6:SlashCommand;
            _arg_1 = _arg_1.replace(/[^\w]*/g, "");
            if (this._slashCmds[_arg_1] != null)
            {
                _local_6 = this._slashCmds[_arg_1];
                if (!_local_6.user)
                {
                    throw (new Error((("Can not alter build-in slash command [" + _arg_1) + "]")));
                };
            };
            if (_arg_2 == null)
            {
                delete this._slashCmds[_arg_1];
            }
            else
            {
                this._slashCmds[_arg_1] = new SlashCommand(_arg_1, _arg_2, LogReferences.EscHTML(_arg_3), true, _arg_4, _arg_5);
            };
        }

        public function run(str:String, saves:Object=null):*
        {
            var bytes:ByteArray;
            var exe:Executer;
            var X:String;
            if (!str)
            {
                return;
            };
            str = str.replace(/\s*/, "");
            if (remoter.remoting == Remoting.RECIEVER)
            {
                if (str.charAt(0) == "~")
                {
                    str = str.substring(1);
                }
                else
                {
                    if (str.search(new RegExp(("/" + this.localCommands.join("|/")))) != 0)
                    {
                        report(("Run command at remote: " + str), -2);
                        bytes = new ByteArray();
                        bytes.writeUTF(str);
                        if (!console.remoter.send("cmd", bytes))
                        {
                            report("Command could not be sent to client.", 10);
                        };
                        return (null);
                    };
                };
            };
            report(("&gt; " + str), 4, false);
            var v:* = null;
            try
            {
                if (str.charAt(0) == "/")
                {
                    this.execCommand(str.substring(1));
                }
                else
                {
                    if (!config.commandLineAllowed)
                    {
                        report(DISABLED, 9);
                        return (null);
                    };
                    exe = new Executer();
                    exe.addEventListener(Event.COMPLETE, this.onExecLineComplete, false, 0, true);
                    if (saves)
                    {
                        for (X in this._saved)
                        {
                            if (!saves[X])
                            {
                                saves[X] = this._saved[X];
                            };
                        };
                    }
                    else
                    {
                        saves = this._saved;
                    };
                    exe.setStored(saves);
                    exe.setReserved(RESERVED);
                    exe.autoScope = config.commandLineAutoScope;
                    v = exe.exec(this._scope, str);
                };
            }
            catch(e:Error)
            {
                reportError(e);
            };
            return (v);
        }

        private function onExecLineComplete(_arg_1:Event):void
        {
            var _local_2:Executer = (_arg_1.currentTarget as Executer);
            if (this._scope == _local_2.scope)
            {
                this.setReturned(_local_2.returned);
            }
            else
            {
                if (_local_2.scope == _local_2.returned)
                {
                    this.setReturned(_local_2.scope, true);
                }
                else
                {
                    this.setReturned(_local_2.returned);
                    this.setReturned(_local_2.scope, true);
                };
            };
        }

        private function execCommand(str:String):void
        {
            var slashcmd:SlashCommand;
            var restStr:String;
            var endInd:int;
            var brk:int = str.search(/[^\w]/);
            var cmd:String = str.substring(0, ((brk > 0) ? brk : str.length));
            if (cmd == "")
            {
                this.setReturned(this._saved.get(Executer.RETURNED), true);
                return;
            };
            var param:String = ((brk > 0) ? str.substring((brk + 1)) : "");
            if (this._slashCmds[cmd] != null)
            {
                try
                {
                    slashcmd = this._slashCmds[cmd];
                    if (((!(config.commandLineAllowed)) && (!(slashcmd.allow))))
                    {
                        report(DISABLED, 9);
                        return;
                    };
                    if (slashcmd.endMarker)
                    {
                        endInd = param.indexOf(slashcmd.endMarker);
                        if (endInd >= 0)
                        {
                            restStr = param.substring((endInd + slashcmd.endMarker.length));
                            param = param.substring(0, endInd);
                        };
                    };
                    if (param.length == 0)
                    {
                        slashcmd.f();
                    }
                    else
                    {
                        slashcmd.f(param);
                    };
                    if (restStr)
                    {
                        this.run(restStr);
                    };
                }
                catch(err:Error)
                {
                    reportError(err);
                };
            }
            else
            {
                report("Undefined command <b>/commands</b> for list of all commands.", 10);
            };
        }

        public function setReturned(_arg_1:*, _arg_2:Boolean=false, _arg_3:Boolean=true):void
        {
            if (!config.commandLineAllowed)
            {
                report(DISABLED, 9);
                return;
            };
            if (_arg_1 !== undefined)
            {
                this._saved.set(Executer.RETURNED, _arg_1, true);
                if (((_arg_2) && (!(_arg_1 === this._scope))))
                {
                    this._prevScope.reference = this._scope;
                    this._scope = _arg_1;
                    if (remoter.remoting != Remoting.RECIEVER)
                    {
                        this._scopeStr = LogReferences.ShortClassName(this._scope, false);
                        this.sendCmdScope2Remote();
                    };
                    report(("Changed to " + console.refs.makeRefTyped(_arg_1)), -1);
                }
                else
                {
                    if (_arg_3)
                    {
                        report(("Returned " + console.refs.makeString(_arg_1)), -1);
                    };
                };
            }
            else
            {
                if (_arg_3)
                {
                    report("Exec successful, undefined return.", -1);
                };
            };
        }

        public function sendCmdScope2Remote(_arg_1:Event=null):void
        {
            var _local_2:ByteArray = new ByteArray();
            _local_2.writeUTF(this._scopeStr);
            console.remoter.send("cls", _local_2);
        }

        private function reportError(_arg_1:Error):void
        {
            var _local_10:String;
            var _local_2:String = console.refs.makeString(_arg_1);
            var _local_3:Array = _local_2.split(/\n\s*/);
            var _local_4:int = 10;
            var _local_5:int;
            var _local_6:int = _local_3.length;
            var _local_7:Array = [];
            var _local_8:RegExp = new RegExp((((("\\s*at\\s+(" + Executer.CLASSES) + "|") + getQualifiedClassName(this)) + ")"));
            var _local_9:int;
            while (_local_9 < _local_6)
            {
                _local_10 = _local_3[_local_9];
                if (_local_10.search(_local_8) == 0)
                {
                    if (((_local_5 > 0) && (_local_9 > 0))) break;
                    _local_5++;
                };
                _local_7.push((((((("<p" + _local_4) + "> ") + _local_10) + "</p") + _local_4) + ">"));
                if (_local_4 > 6)
                {
                    _local_4--;
                };
                _local_9++;
            };
            report(_local_7.join("\n"), 9);
        }

        private function saveCmd(_arg_1:String=null):void
        {
            this.store(_arg_1, this._scope, false);
        }

        private function saveStrongCmd(_arg_1:String=null):void
        {
            this.store(_arg_1, this._scope, true);
        }

        private function savedCmd(... _args):void
        {
            var _local_4:String;
            var _local_5:WeakRef;
            report("Saved vars: ", -1);
            var _local_2:uint;
            var _local_3:uint;
            for (_local_4 in this._saved)
            {
                _local_5 = this._saved.getWeakRef(_local_4);
                _local_2++;
                if (_local_5.reference == null)
                {
                    _local_3++;
                };
                report(((((((_local_5.strong) ? "strong" : "weak") + " <b>$") + _local_4) + "</b> = ") + console.refs.makeString(_local_5.reference)), -2);
            };
            report((((("Found " + _local_2) + " item(s), ") + _local_3) + " empty."), -1);
        }

        private function stringCmd(_arg_1:String):void
        {
            report((("String with " + _arg_1.length) + " chars entered. Use /save <i>(name)</i> to save."), -2);
            this.setReturned(_arg_1, true);
        }

        private function cmdsCmd(... _args):void
        {
            var _local_4:SlashCommand;
            var _local_2:Array = [];
            var _local_3:Array = [];
            for each (_local_4 in this._slashCmds)
            {
                if (((config.commandLineAllowed) || (_local_4.allow)))
                {
                    if (_local_4.user)
                    {
                        _local_3.push(_local_4);
                    }
                    else
                    {
                        _local_2.push(_local_4);
                    };
                };
            };
            _local_2 = _local_2.sortOn("n");
            report(("Built-in commands:" + ((config.commandLineAllowed) ? "" : " (limited permission)")), 4);
            for each (_local_4 in _local_2)
            {
                report((((("<b>/" + _local_4.n) + "</b> <p-1>") + _local_4.d) + "</p-1>"), -2);
            };
            if (_local_3.length)
            {
                _local_3 = _local_3.sortOn("n");
                report("User commands:", 4);
                for each (_local_4 in _local_3)
                {
                    report((((("<b>/" + _local_4.n) + "</b> <p-1>") + _local_4.d) + "</p-1>"), -2);
                };
            };
        }

        private function inspectCmd(... _args):void
        {
            console.refs.focus(this._scope);
        }

        private function explodeCmd(_arg_1:String="0"):void
        {
            var _local_2:int = int(_arg_1);
            console.explodech(console.panels.mainPanel.reportChannel, this._scope, ((_local_2 <= 0) ? 3 : _local_2));
        }

        private function mapCmd(_arg_1:String="0"):void
        {
            console.mapch(console.panels.mainPanel.reportChannel, (this._scope as DisplayObjectContainer), int(_arg_1));
        }

        private function funCmd(_arg_1:String=""):void
        {
            var _local_2:FakeFunction = new FakeFunction(this.run, _arg_1);
            report("Function created. Use /savestrong <i>(name)</i> to save.", -2);
            this.setReturned(_local_2.exec, true);
        }

        private function autoscopeCmd(... _args):void
        {
            config.commandLineAutoScope = (!(config.commandLineAutoScope));
            report((("Auto-scoping <b>" + ((config.commandLineAutoScope) ? "enabled" : "disabled")) + "</b>."), 10);
        }

        private function baseCmd(... _args):void
        {
            this.setReturned(this.base, true);
        }

        private function prevCmd(... _args):void
        {
            this.setReturned(this._prevScope.reference, true);
        }

        private function printHelp(... _args):void
        {
            report("____Command Line Help___", 10);
            report("/filter (text) = filter/search logs for matching text", 5);
            report("/commands to see all slash commands", 5);
            report("Press up/down arrow keys to recall previous line", 2);
            report("__Examples:", 10);
            report("<b>stage.stageWidth</b>", 5);
            report("<b>stage.scaleMode = flash.display.StageScaleMode.NO_SCALE</b>", 5);
            report("<b>stage.frameRate = 12</b>", 5);
            report("__________", 10);
        }


    }
}//package com.junkbyte.console.core

class FakeFunction 
{

    /*private*/ var line:String;
    /*private*/ var run:Function;

    public function FakeFunction(_arg_1:Function, _arg_2:String):void
    {
        this.run = _arg_1;
        this.line = _arg_2;
    }

    public function exec(... _args):*
    {
        return (this.run(this.line, _args));
    }


}

class SlashCommand 
{

    public var n:String;
    public var f:Function;
    public var d:String;
    public var user:Boolean;
    public var allow:Boolean;
    public var endMarker:String;

    public function SlashCommand(_arg_1:String, _arg_2:Function, _arg_3:String, _arg_4:Boolean, _arg_5:Boolean, _arg_6:String)
    {
        this.n = _arg_1;
        this.f = _arg_2;
        this.d = ((_arg_3) ? _arg_3 : "");
        this.user = _arg_4;
        this.allow = _arg_5;
        this.endMarker = _arg_6;
    }

}


