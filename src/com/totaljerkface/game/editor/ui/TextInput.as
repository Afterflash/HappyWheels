package com.totaljerkface.game.editor.ui
{
    import flash.display.Sprite;
    import flash.events.KeyboardEvent;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFieldType;
    import flash.text.TextFormat;

    [Embed(source="/_assets/assets.swf", symbol="symbol722")]
    public class TextInput extends InputObject
    {
        public var labelText:TextField;

        public var inputText:TextField;

        public var bg:Sprite;

        protected var spacing:Number;

        protected var readOnly:Boolean;

        protected var currentString:String;

        public function TextInput(param1:String, param2:String, param3:int, param4:Boolean, param5:Boolean = false, param6:Number = 10, param7:Number = 60)
        {
            super();
            this.labelText.text = param1 + ":";
            this.attribute = param2;
            this.currentString = "";
            childInputs = new Array();
            this.inputText.maxChars = param3;
            this.inputText.width = param7;
            this.spacing = param6;
            this.readOnly = param5;
            this.editable = param4;
            this.init();
        }

        protected function init():void
        {
            var _loc1_:TextFormat = null;
            this.labelText.mouseEnabled = false;
            this.inputText.x = this.labelText.x + this.labelText.textWidth + this.spacing;
            this.inputText.wordWrap = this.labelText.wordWrap = false;
            this.inputText.autoSize = this.labelText.autoSize = TextFieldAutoSize.LEFT;
            if (this.readOnly)
            {
                _loc1_ = this.inputText.defaultTextFormat;
                _loc1_.color = 16777215;
                this.inputText.defaultTextFormat = _loc1_;
                this.inputText.selectable = false;
                this.inputText.mouseEnabled = false;
            }
            else
            {
                this.inputText.addEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler);
            }
        }

        protected function keyDownHandler(param1:KeyboardEvent):void
        {
            if (param1.keyCode == 13)
            {
                this.currentString = this.inputText.text;
                stage.focus = stage;
                dispatchEvent(new ValueEvent(ValueEvent.VALUE_CHANGE, this, this.currentString));
            }
            else if (param1.keyCode == 9 && !_ambiguous)
            {
                this.currentString = this.inputText.text;
                dispatchEvent(new ValueEvent(ValueEvent.VALUE_CHANGE, this, this.currentString));
            }
        }

        public function get text():String
        {
            return this.inputText.text;
        }

        public function set text(param1:String):void
        {
            if (!_editable)
            {
                this.currentString = param1;
                this.inputText.text = "-";
                return;
            }
            this.inputText.text = param1;
            _ambiguous = false;
        }

        public function set restrict(param1:String):void
        {
            this.inputText.restrict = param1;
        }

        protected function adjustBg():void
        {
            this.bg.width = this.inputText.width;
        }

        public function set maxChars(param1:int):void
        {
            this.inputText.maxChars = param1;
        }

        override public function set editable(param1:Boolean):void
        {
            _editable = param1;
            if (param1)
            {
                alpha = 1;
                this.inputText.text = this.currentString;
                this.inputText.defaultTextFormat.color = 13260;
                this.inputText.type = TextFieldType.INPUT;
                this.inputText.tabEnabled = true;
                this.inputText.mouseEnabled = true;
            }
            else
            {
                alpha = 0.5;
                this.inputText.text = "-";
                this.inputText.defaultTextFormat.color = 0;
                this.inputText.type = TextFieldType.DYNAMIC;
                this.inputText.tabEnabled = false;
                this.inputText.mouseEnabled = false;
            }
        }

        override public function setToAmbiguous():void
        {
            this.inputText.text = "-";
            _ambiguous = true;
        }

        override public function setValue(param1:*):void
        {
            this.text = param1;
        }

        override public function die():void
        {
            super.die();
            this.inputText.removeEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler);
        }
    }
}
