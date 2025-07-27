package com.totaljerkface.game.editor.ui
{
    import flash.display.CapsStyle;
    import flash.display.JointStyle;
    import flash.display.LineScaleMode;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    
    public class SpecialListItem extends Sprite
    {
        public var bg:Sprite;
        
        public var textField:TextField;
        
        protected const indentPixels:int = 13;
        
        protected var _parentItem:SpecialExpandItem;
        
        protected var _selected:Boolean;
        
        protected var _bgWidth:int;
        
        protected var _bgHeight:int = 22;
        
        protected var _value:String;
        
        protected var _defBgColor:uint = 13421772;
        
        protected var _overBgColor:uint = 14540253;
        
        protected var _downBgColor:uint = 4032711;
        
        protected var _defTextColor:uint = 16777215;
        
        protected var _overTextColor:uint = 10066329;
        
        protected var _downTextColor:uint = 16777215;
        
        public function SpecialListItem(param1:String, param2:String, param3:int = 0, param4:int = 100)
        {
            var _loc5_:Number = NaN;
            super();
            this._value = param2;
            this.createTextField();
            this.textField.text = param1;
            this.textField.x = 5 + param3 * this.indentPixels;
            if(param3 > 0)
            {
                _loc5_ = 1118481 * param3;
                this._defBgColor -= _loc5_;
                this._overBgColor -= _loc5_;
                this._downBgColor -= _loc5_;
                this._defTextColor -= _loc5_;
                this._overTextColor -= _loc5_;
                this._downTextColor -= _loc5_;
            }
            this._bgWidth = param4;
            this.bg = new Sprite();
            addChildAt(this.bg,0);
            this.bg.mouseEnabled = this.textField.mouseEnabled = false;
            this.rollOut();
        }
        
        protected function createTextField() : void
        {
            var _loc1_:TextFormat = new TextFormat("HelveticaNeueLT Std",12,this._defTextColor,null,null,null,null,null,TextFormatAlign.LEFT);
            this.textField = new TextField();
            this.textField.defaultTextFormat = _loc1_;
            this.textField.autoSize = TextFieldAutoSize.LEFT;
            this.textField.width = this._bgWidth;
            this.textField.height = 20;
            this.textField.y = 3;
            this.textField.multiline = false;
            this.textField.selectable = false;
            this.textField.embedFonts = true;
            this.textField.antiAliasType = AntiAliasType.ADVANCED;
            addChild(this.textField);
        }
        
        protected function drawBg(param1:uint) : void
        {
            this.bg.graphics.clear();
            this.bg.graphics.lineStyle(1,10066329,1,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.MITER,3);
            this.bg.graphics.beginFill(param1);
            this.bg.graphics.drawRect(0,0,this._bgWidth,this._bgHeight);
            this.bg.graphics.endFill();
        }
        
        public function rollOver(param1:MouseEvent = null) : void
        {
            if(this._selected)
            {
                return;
            }
            this.drawBg(this._overBgColor);
            this.textField.textColor = this._overTextColor;
            this.drawSymbol();
            if(this._parentItem)
            {
                this._parentItem.rollOver();
            }
        }
        
        public function rollOut(param1:MouseEvent = null) : void
        {
            if(this._selected)
            {
                return;
            }
            this.drawBg(this._defBgColor);
            this.textField.textColor = this._defTextColor;
            this.drawSymbol();
            if(this._parentItem)
            {
                this._parentItem.rollOut();
            }
        }
        
        public function mouseDown() : void
        {
            this.drawBg(this._downBgColor);
            this.textField.textColor = this._downTextColor;
            this.drawSymbol();
        }
        
        protected function drawSymbol() : void
        {
        }
        
        public function get selected() : Boolean
        {
            return this._selected;
        }
        
        public function set selected(param1:Boolean) : void
        {
            if(this._selected == param1)
            {
                return;
            }
            this._selected = param1;
            if(this._selected)
            {
                this.mouseDown();
            }
            else
            {
                this.rollOut();
            }
            if(this._parentItem)
            {
                this._parentItem.selected = this._selected;
            }
        }
        
        override public function get height() : Number
        {
            return this._bgHeight;
        }
        
        public function get value() : String
        {
            return this._value;
        }
        
        public function get text() : String
        {
            return this.textField.text;
        }
        
        public function get textWidth() : Number
        {
            return this.textField.textWidth;
        }
        
        public function get bgWidth() : Number
        {
            return this.bg.width;
        }
        
        public function set bgWidth(param1:Number) : void
        {
            this._bgWidth = param1;
            this.rollOut();
        }
        
        public function get parentItem() : SpecialExpandItem
        {
            return this._parentItem;
        }
        
        public function set parentItem(param1:SpecialExpandItem) : void
        {
            this._parentItem = param1;
            if(this._selected)
            {
                this._parentItem.selected = true;
            }
        }
    }
}

