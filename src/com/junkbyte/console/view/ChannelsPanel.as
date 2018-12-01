﻿// Decompiled by AS3 Sorcerer 5.96
// www.as3sorcerer.com

//com.junkbyte.console.view.ChannelsPanel

package com.junkbyte.console.view
{
    import flash.text.TextFieldAutoSize;
    import com.junkbyte.console.Console;
    import flash.events.TextEvent;

    public class ChannelsPanel extends ConsolePanel 
    {

        public static const NAME:String = "channelsPanel";

        public function ChannelsPanel(_arg_1:Console)
        {
            super(_arg_1);
            name = NAME;
            init(10, 10, false);
            txtField = makeTF("channelsField");
            txtField.wordWrap = true;
            txtField.width = 160;
            txtField.multiline = true;
            txtField.autoSize = TextFieldAutoSize.LEFT;
            registerTFRoller(txtField, this.onMenuRollOver, this.linkHandler);
            registerDragger(txtField);
            addChild(txtField);
        }

        public function update():void
        {
            txtField.wordWrap = false;
            txtField.width = 80;
            var _local_1:String = ('<high><menu> <b><a href="event:close">X</a></b></menu> ' + console.panels.mainPanel.getChannelsLink());
            txtField.htmlText = (_local_1 + "</high>");
            if (txtField.width > 160)
            {
                txtField.wordWrap = true;
                txtField.width = 160;
            };
            width = (txtField.width + 4);
            height = txtField.height;
        }

        private function onMenuRollOver(_arg_1:TextEvent):void
        {
            console.panels.mainPanel.onMenuRollOver(_arg_1, this);
        }

        protected function linkHandler(_arg_1:TextEvent):void
        {
            txtField.setSelection(0, 0);
            if (_arg_1.text == "close")
            {
                console.panels.channelsPanel = false;
            }
            else
            {
                if (_arg_1.text.substring(0, 8) == "channel_")
                {
                    console.panels.mainPanel.onChannelPressed(_arg_1.text.substring(8));
                };
            };
            txtField.setSelection(0, 0);
            _arg_1.stopPropagation();
        }


    }
}//package com.junkbyte.console.view

