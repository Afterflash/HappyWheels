package com.totaljerkface.game.editor.specials
{
    import com.totaljerkface.game.editor.*;
    import flash.display.*;
    import flash.events.Event;
    import flash.text.*;
    import flash.utils.Dictionary;
    
    public class TextBoxRef extends Special
    {
        private const MIN_SIZE:int = 10;
        
        private const MAX_SIZE:int = 100;
        
        private const MIN_TEXT_DIMENSION:int = 20;
        
        private const MAX_TEXT_DIMENSION:int = 1000;
        
        protected var textField:TextField;
        
        protected var textFormat:TextFormat;
        
        protected var bg:Sprite;
        
        protected var _caption:String = "HERE\'S SOME TEXT";
        
        protected var _fontSize:int = 15;
        
        protected var _align:int = 1;
        
        protected var _font:int = 2;
        
        protected var _color:uint = 0;
        
        protected var _opacity:Number = 1;
        
        protected var _editing:Boolean = false;
        
        public function TextBoxRef()
        {
            _triggerable = true;
            _triggers = new Array();
            _triggerActions = new Dictionary();
            _triggerActionList = ["change opacity","slide"];
            _triggerActionListProperties = [["newOpacities","opacityTimes"],["slideTimes","newX","newY"]];
            _triggerString = "triggerActionsText";
            super();
            name = "text field";
            _shapesUsed = 0;
            _rotatable = true;
            _scalable = false;
            _joinable = false;
            _groupable = true;
            _keyedPropertyObject[_triggerString] = _triggerActions;
            doubleClickEnabled = true;
            this.createTextField();
        }
        
        public static function getAlignment(param1:int) : String
        {
            var _loc2_:String = null;
            switch(param1)
            {
                case 1:
                    _loc2_ = TextFormatAlign.LEFT;
                    break;
                case 2:
                    _loc2_ = TextFormatAlign.CENTER;
                    break;
                case 3:
                    _loc2_ = TextFormatAlign.RIGHT;
            }
            return _loc2_;
        }
        
        public static function getFontName(param1:int) : String
        {
            var _loc2_:String = null;
            switch(param1)
            {
                case 1:
                    _loc2_ = "HelveticaNeueLT Std";
                    break;
                case 2:
                    _loc2_ = "HelveticaNeueLT Std Med";
                    break;
                case 3:
                    _loc2_ = "HelveticaNeueLT Std";
                    break;
                case 4:
                    _loc2_ = "Clarendon LT Std";
                    break;
                case 5:
                    _loc2_ = "Clarendon LT Std";
            }
            return _loc2_;
        }
        
        public static function getFontBold(param1:int) : Boolean
        {
            var _loc2_:Boolean = false;
            switch(param1)
            {
                case 1:
                    _loc2_ = false;
                    break;
                case 2:
                    _loc2_ = false;
                    break;
                case 3:
                    _loc2_ = true;
                    break;
                case 4:
                    _loc2_ = false;
                    break;
                case 5:
                    _loc2_ = true;
            }
            return _loc2_;
        }
        
        override public function setAttributes() : void
        {
            _type = "TextBoxRef";
            _attributes = ["x","y","angle","color","opacity","font","fontSize","align"];
            addTriggerProperties();
        }
        
        override public function getFullProperties() : Array
        {
            return ["x","y","angle","color","font","fontSize","align","caption","opacity"];
        }
        
        protected function createTextField() : void
        {
            this.textFormat = new TextFormat(getFontName(this._font),this._fontSize,this._color,getFontBold(this._font),null,null,null,null,getAlignment(this._align));
            this.textField = new TextField();
            this.textField.defaultTextFormat = this.textFormat;
            this.textField.type = TextFieldType.INPUT;
            this.textField.multiline = true;
            this.textField.autoSize = TextFieldAutoSize.LEFT;
            this.textField.wordWrap = false;
            this.textField.selectable = true;
            this.textField.embedFonts = true;
            this.textField.antiAliasType = AntiAliasType.ADVANCED;
            this.textField.maxChars = 200;
            this.textField.restrict = "a-z A-Z 0-9 !@#$%\\^&*()_+\\-=;\'|?/,.<> \"";
            this.textField.alpha = this._opacity;
            this.textField.addEventListener(Event.CHANGE,this.adjustBg,false,0,true);
            this.bg = new Sprite();
            this.bg.graphics.lineStyle(0,16613761,1,true);
            this.bg.graphics.drawRect(0,0,100,100);
            this.bg.width = this.textField.width;
            this.bg.height = this.textField.height;
            addChildAt(this.bg,0);
            addChild(this.textField);
            this.caption = this._caption;
        }
        
        private function adjustBg(param1:Event = null) : void
        {
            this.bg.width = this.textField.width;
            this.bg.height = this.textField.height;
            if(_selected)
            {
                drawBoundingBox();
            }
        }
        
        public function selectAllText() : void
        {
            if(!this._editing)
            {
                return;
            }
            this.textField.setSelection(0,this.textField.length);
        }
        
        public function get editing() : Boolean
        {
            return this._editing;
        }
        
        public function set editing(param1:Boolean) : void
        {
            var _loc2_:int = 0;
            this._editing = param1;
            if(this._editing)
            {
                mouseChildren = true;
                stage.focus = this.textField;
                _loc2_ = this.textField.length;
                this.textField.setSelection(_loc2_,_loc2_);
            }
            else
            {
                mouseChildren = false;
                stage.focus = stage;
            }
        }
        
        public function get caption() : String
        {
            return this._caption;
        }
        
        public function set caption(param1:String) : void
        {
            this._caption = param1;
            this.textField.text = this._caption;
            this.adjustBg();
            if(_selected)
            {
                drawBoundingBox();
            }
            x = x;
            y = y;
        }
        
        public function get currentText() : String
        {
            return this.textField.text;
        }
        
        public function get fontSize() : int
        {
            return this._fontSize;
        }
        
        public function set fontSize(param1:int) : void
        {
            this._fontSize = param1;
            if(this._fontSize < this.MIN_SIZE)
            {
                this._fontSize = this.MIN_SIZE;
            }
            if(this._fontSize > this.MAX_SIZE)
            {
                this._fontSize = this.MAX_SIZE;
            }
            this.textFormat.size = this._fontSize;
            this.textField.defaultTextFormat = this.textFormat;
            this.textField.setTextFormat(this.textFormat);
            this.adjustBg();
            x = x;
            y = y;
        }
        
        public function get align() : int
        {
            return this._align;
        }
        
        public function set align(param1:int) : void
        {
            this._align = param1;
            if(this._align < 1)
            {
                this._align = 1;
            }
            if(this._align > 3)
            {
                this._align = 3;
            }
            this.textFormat.align = getAlignment(this._align);
            this.textField.defaultTextFormat = this.textFormat;
            this.textField.setTextFormat(this.textFormat);
            this.adjustBg();
            x = x;
            y = y;
        }
        
        public function get font() : int
        {
            return this._font;
        }
        
        public function set font(param1:int) : void
        {
            this._font = param1;
            if(this._font < 1)
            {
                this._font = 1;
            }
            if(this._font > 5)
            {
                this._font = 5;
            }
            this.textFormat.font = getFontName(this._font);
            this.textFormat.bold = getFontBold(this._font);
            this.textField.defaultTextFormat = this.textFormat;
            this.textField.setTextFormat(this.textFormat);
            this.adjustBg();
            x = x;
            y = y;
        }
        
        public function get color() : uint
        {
            return this._color;
        }
        
        public function set color(param1:uint) : void
        {
            if(this._color == param1)
            {
                return;
            }
            this._color = param1;
            this.textFormat.color = this._color;
            this.textField.defaultTextFormat = this.textFormat;
            this.textField.setTextFormat(this.textFormat);
        }
        
        public function get opacity() : Number
        {
            return Math.round(this._opacity * 100);
        }
        
        public function set opacity(param1:Number) : void
        {
            if(param1 < 0)
            {
                param1 = 0;
            }
            if(param1 > 100)
            {
                param1 = 100;
            }
            this._opacity = param1 * 0.01;
            this.textField.alpha = this._opacity;
        }
        
        override public function clone() : RefSprite
        {
            var _loc1_:TextBoxRef = new TextBoxRef();
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.angle = angle;
            _loc1_.fontSize = this.fontSize;
            _loc1_.font = this.font;
            _loc1_.align = this.align;
            _loc1_.color = this.color;
            _loc1_.opacity = this.opacity;
            _loc1_.caption = this.caption;
            transferKeyedProperties(_loc1_);
            return _loc1_;
        }
        
        public function get triggerActionsText() : Dictionary
        {
            return _triggerActions;
        }
    }
}

