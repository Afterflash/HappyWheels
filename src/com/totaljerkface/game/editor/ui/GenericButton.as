package com.totaljerkface.game.editor.ui
{
    import com.totaljerkface.game.editor.MouseHelper;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.filters.BevelFilter;
    import flash.filters.DropShadowFilter;
    import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    
    public class GenericButton extends Sprite
    {
        protected var textField:TextField;
        
        protected var bg:Sprite;
        
        protected var _bgColor:uint;
        
        protected var _bgWidth:Number;
        
        protected var _bgHeight:Number = 23;
        
        protected var _txtColor:uint;
        
        protected var _selected:Boolean;
        
        protected var offAlpha:Number = 0.7;
        
        protected var _disabled:Boolean;
        
        protected var _functionString:String;
        
        protected var _helpString:String;
        
        public function GenericButton(param1:String, param2:uint, param3:Number, param4:uint = 16777215)
        {
            super();
            mouseChildren = false;
            buttonMode = true;
            tabEnabled = false;
            this._bgColor = param2;
            this._bgWidth = param3;
            this._txtColor = param4;
            this.createTextField();
            this.textField.text = param1;
            this.createBg();
            this.selected = false;
            addEventListener(MouseEvent.ROLL_OVER,this.rollOverHandler,false,0,true);
            addEventListener(MouseEvent.ROLL_OUT,this.rollOutHandler,false,0,true);
        }
        
        protected function createTextField() : void
        {
            var _loc1_:TextFormat = new TextFormat("HelveticaNeueLT Std Med",12,this._txtColor,null,null,null,null,null,TextFormatAlign.CENTER);
            this.textField = new TextField();
            this.textField.defaultTextFormat = _loc1_;
            this.textField.width = this._bgWidth;
            this.textField.height = 20;
            this.textField.y = 3;
            this.textField.multiline = false;
            this.textField.selectable = false;
            this.textField.embedFonts = true;
            this.textField.antiAliasType = AntiAliasType.ADVANCED;
            addChild(this.textField);
        }
        
        protected function createBg() : void
        {
            this.bg = new Sprite();
            addChildAt(this.bg,0);
            this.bg.graphics.beginFill(this._bgColor);
            this.bg.graphics.drawRoundRect(0,0,this._bgWidth,this._bgHeight,5,5);
            this.bg.graphics.endFill();
            var _loc1_:BevelFilter = new BevelFilter(2,90,16777215,0.3,0,0.3,3,3,1,3);
            var _loc2_:DropShadowFilter = new DropShadowFilter(2,90,0,1,4,4,0.25,3);
            this.bg.filters = [_loc1_,_loc2_];
        }
        
        public function get selected() : Boolean
        {
            return this._selected;
        }
        
        public function set selected(param1:Boolean) : void
        {
            this._selected = param1;
            if(this._selected)
            {
                this.rollOverHandler();
            }
            else
            {
                this.rollOutHandler();
            }
        }
        
        protected function rollOverHandler(param1:MouseEvent = null) : void
        {
            this.textField.alpha = 1;
            if(this._helpString)
            {
                MouseHelper.instance.show(this._helpString,this,5);
            }
        }
        
        protected function rollOutHandler(param1:MouseEvent = null) : void
        {
            if(this._selected)
            {
                return;
            }
            this.textField.alpha = this.offAlpha;
        }
        
        public function get disabled() : Boolean
        {
            return this._disabled;
        }
        
        public function set disabled(param1:Boolean) : void
        {
            this._disabled = param1;
            if(param1)
            {
                removeEventListener(MouseEvent.ROLL_OVER,this.rollOverHandler);
                removeEventListener(MouseEvent.ROLL_OUT,this.rollOutHandler);
                mouseEnabled = false;
                buttonMode = false;
                alpha = 0.5;
            }
            else
            {
                addEventListener(MouseEvent.ROLL_OVER,this.rollOverHandler,false,0,true);
                addEventListener(MouseEvent.ROLL_OUT,this.rollOutHandler,false,0,true);
                mouseEnabled = true;
                buttonMode = true;
                alpha = 1;
            }
        }
        
        protected function mouseUpHandler(param1:MouseEvent) : void
        {
        }
        
        public function get functionString() : String
        {
            return this._functionString;
        }
        
        public function set functionString(param1:String) : void
        {
            this._functionString = param1;
        }
        
        public function get helpString() : String
        {
            return this._helpString;
        }
        
        public function set helpString(param1:String) : void
        {
            this._helpString = param1;
        }
    }
}

