package com.totaljerkface.game.menus
{
    import flash.display.CapsStyle;
    import flash.display.JointStyle;
    import flash.display.LineScaleMode;
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;

    [Embed(source="/_assets/assets.swf", symbol="symbol3029")]
    public class DropMenuItem extends Sprite
    {
        public var bg:Sprite;

        public var currText:TextField;

        private var _bgWidth:int;

        private var _index:int;

        public function DropMenuItem(param1:String, param2:int, param3:int = 100)
        {
            super();
            mouseChildren = false;
            buttonMode = true;
            this._index = param2;
            this.currText.autoSize = TextFieldAutoSize.LEFT;
            this.currText.wordWrap = false;
            this.currText.embedFonts = true;
            this.currText.selectable = false;
            this.currText.text = param1;
            this._bgWidth = param3;
            this.bg = new Sprite();
            addChildAt(this.bg, 0);
            this.rollOut();
        }

        private function drawBg(param1:uint):void
        {
            this.bg.graphics.clear();
            this.bg.graphics.lineStyle(1, 13421772, 1, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER, 3);
            this.bg.graphics.beginFill(param1);
            this.bg.graphics.drawRect(0, 0, this._bgWidth, 22);
            this.bg.graphics.endFill();
        }

        public function rollOver():void
        {
            this.drawBg(16777215);
            this.currText.textColor = 4032711;
        }

        public function rollOut():void
        {
            this.drawBg(15724527);
            this.currText.textColor = 8947848;
        }

        public function mouseDown():void
        {
            this.drawBg(13421772);
            this.currText.textColor = 16777215;
        }

        override public function get height():Number
        {
            return this.bg.height;
        }

        public function get index():int
        {
            return this._index;
        }

        public function get text():String
        {
            return this.currText.text;
        }

        public function get textWidth():Number
        {
            return this.currText.textWidth;
        }

        public function get bgWidth():Number
        {
            return this.bg.width;
        }

        public function set bgWidth(param1:Number):void
        {
            this._bgWidth = param1;
            this.rollOut();
        }
    }
}
