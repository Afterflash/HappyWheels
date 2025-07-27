package com.totaljerkface.game.editor.ui
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;

    [Embed(source="/_assets/assets.swf", symbol="symbol814")]
    public class ColorInput extends InputObject
    {
        public var colorBorder:Sprite;

        public var noColorSprite:Sprite;

        protected var labelText:TextField;

        private var colorSprite:Sprite;

        private var colorSelector:ColorSelector;

        private var _color:int;

        private var _minusColor:Boolean;

        public function ColorInput(param1:String, param2:String, param3:Boolean, param4:Boolean = false)
        {
            super();
            this.createLabel(param1);
            this.attribute = param2;
            childInputs = new Array();
            this.editable = param3;
            this._minusColor = param4;
            this._color = 0;
            this.init();
        }

        private function init():void
        {
            this.colorSprite = new Sprite();
            addChild(this.colorSprite);
            this.colorSprite.x = this.colorBorder.x + 2;
            this.colorSprite.y = this.colorBorder.y + 2;
            this.colorSprite.mouseEnabled = this.noColorSprite.mouseEnabled = false;
            this.drawColorSprite();
            this.colorBorder.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
        }

        protected function createLabel(param1:String):void
        {
            var _loc2_:TextFormat = new TextFormat("HelveticaNeueLT Std", 11, 16777215, null, null, null, null, null, TextFormatAlign.LEFT);
            this.labelText = new TextField();
            this.labelText.defaultTextFormat = _loc2_;
            this.labelText.autoSize = TextFieldAutoSize.LEFT;
            this.labelText.width = 10;
            this.labelText.height = 17;
            this.labelText.x = 0;
            this.labelText.y = 0;
            this.labelText.multiline = false;
            this.labelText.selectable = false;
            this.labelText.embedFonts = true;
            this.labelText.antiAliasType = AntiAliasType.ADVANCED;
            this.labelText.text = param1 + ":";
            addChild(this.labelText);
        }

        private function drawColorSprite():void
        {
            if (this._color < 0)
            {
                this.noColorSprite.visible = true;
                this.colorSprite.visible = false;
            }
            else
            {
                this.noColorSprite.visible = false;
                this.colorSprite.visible = true;
                this.colorSprite.graphics.clear();
                this.colorSprite.graphics.beginFill(this._color);
                this.colorSprite.graphics.drawRect(0, 0, this.colorBorder.width - 4, this.colorBorder.height - 4);
                this.colorSprite.graphics.endFill();
            }
        }

        public function get color():int
        {
            return this._color;
        }

        public function set color(param1:int):void
        {
            if (!editable)
            {
                return;
            }
            _ambiguous = false;
            this._color = param1;
            this.drawColorSprite();
        }

        override public function setValue(param1:*):void
        {
            this.color = param1;
        }

        private function mouseUpHandler(param1:MouseEvent):void
        {
            if (this.colorSelector)
            {
                return;
            }
            this.colorSelector = new ColorSelector(this._color, this._minusColor);
            stage.addChild(this.colorSelector);
            var _loc2_:Point = localToGlobal(new Point(this.colorBorder.x - 5, this.colorBorder.y - 5));
            this.colorSelector.x = _loc2_.x;
            this.colorSelector.y = _loc2_.y;
            this.colorSelector.addEventListener(ColorSelector.COLOR_SELECTED, this.colorSelected);
            this.colorSelector.addEventListener(ColorSelector.ROLL_OUT, this.colorSelectorRollOut);
        }

        private function colorSelected(param1:Event):void
        {
            this.color = this.colorSelector.currentColor;
            dispatchEvent(new ValueEvent(ValueEvent.VALUE_CHANGE, this, this.color, false));
        }

        private function colorSelectorRollOut(param1:Event):void
        {
            this.color = this.colorSelector.currentColor;
            this.closeColorSelector();
            dispatchEvent(new ValueEvent(ValueEvent.VALUE_CHANGE, this, this.color));
        }

        public function closeColorSelector(param1:MouseEvent = null):void
        {
            if (!this.colorSelector)
            {
                return;
            }
            this.colorSelector.die();
            this.colorSelector.removeEventListener(ColorSelector.COLOR_SELECTED, this.colorSelected);
            this.colorSelector.removeEventListener(ColorSelector.ROLL_OUT, this.colorSelectorRollOut);
            stage.removeChild(this.colorSelector);
            this.colorSelector = null;
        }

        override public function get height():Number
        {
            return 25;
        }

        override public function die():void
        {
            super.die();
            this.closeColorSelector();
            this.colorBorder.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
        }
    }
}
