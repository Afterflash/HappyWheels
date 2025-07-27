package com.totaljerkface.game.editor
{
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filters.DropShadowFilter;
    import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    
    public class MouseHelper extends Sprite
    {
        private static var _instance:MouseHelper;
        
        private var textField:TextField;
        
        private var bg:Sprite;
        
        private var wMax:int = 200;
        
        private const delayDefault:int = 10;
        
        private var _delay:int;
        
        private var _counter:int = 0;
        
        private var _resetCounter:int;
        
        private var _target:DisplayObject;
        
        public function MouseHelper()
        {
            super();
            if(_instance)
            {
                throw new Error("mouse helper already exists");
            }
            _instance = this;
            this.init();
        }
        
        public static function get instance() : MouseHelper
        {
            return _instance;
        }
        
        private function init() : void
        {
            visible = false;
            var _loc1_:DropShadowFilter = new DropShadowFilter(10,90,0,1,7,7,0.2,3);
            filters = [_loc1_];
            mouseEnabled = false;
            mouseChildren = false;
            var _loc2_:TextFormat = new TextFormat("HelveticaNeueLT Std Med",10,6710886,null,null,null,null,null,TextFormatAlign.JUSTIFY);
            this.textField = new TextField();
            this.textField.defaultTextFormat = _loc2_;
            this.textField.wordWrap = true;
            this.textField.width = 20;
            this.textField.height = 20;
            this.textField.x = 3;
            this.textField.y = 2;
            this.textField.multiline = true;
            this.textField.selectable = false;
            this.textField.embedFonts = true;
            this.textField.antiAliasType = AntiAliasType.ADVANCED;
            this.bg = new Sprite();
            addChild(this.bg);
            addChild(this.textField);
        }
        
        private function drawBg() : void
        {
            this.bg.graphics.clear();
            this.bg.graphics.beginFill(16776805,1);
            this.bg.graphics.drawRect(0,0,Math.ceil(this.textField.width) + 8,Math.ceil(this.textField.height) + 4);
            this.bg.graphics.endFill();
        }
        
        public function show(param1:String, param2:DisplayObject, param3:int = 10) : void
        {
            this.textField.htmlText = param1;
            this.textField.width = 10;
            this.textField.autoSize = TextFieldAutoSize.LEFT;
            this.textField.wordWrap = false;
            if(this.textField.width > this.wMax)
            {
                this.textField.wordWrap = true;
                this.textField.width = this.wMax;
            }
            this.drawBg();
            if(this._target)
            {
                this._target.removeEventListener(MouseEvent.ROLL_OUT,this.rollOutTarget);
            }
            this._target = param2;
            this._delay = param3;
            if(stage)
            {
                stage.addChild(this);
            }
            this.followMouse();
            addEventListener(Event.ENTER_FRAME,this.followMouse);
            this._target.addEventListener(MouseEvent.ROLL_OUT,this.rollOutTarget);
            removeEventListener(Event.ENTER_FRAME,this.resetCounter);
        }
        
        public function hide() : void
        {
            visible = false;
            this._resetCounter = 0;
            removeEventListener(Event.ENTER_FRAME,this.followMouse);
            this._target.removeEventListener(MouseEvent.ROLL_OUT,this.rollOutTarget);
            this._target = null;
            addEventListener(Event.ENTER_FRAME,this.resetCounter);
        }
        
        private function followMouse(param1:Event = null) : void
        {
            if(!visible)
            {
                if(this._counter >= this._delay)
                {
                    visible = true;
                }
                this._counter += 1;
            }
            x = parent.mouseX + 20;
            y = parent.mouseY + 10;
            if(y + height > 500)
            {
                y = Math.max(500 - height);
            }
            if(x + width > 900)
            {
                x = Math.max(900 - width);
            }
        }
        
        private function resetCounter(param1:Event) : void
        {
            if(this._resetCounter == this._delay)
            {
                this._counter = 0;
                removeEventListener(Event.ENTER_FRAME,this.resetCounter);
            }
            this._resetCounter += 1;
        }
        
        private function rollOutTarget(param1:MouseEvent) : void
        {
            this.hide();
        }
        
        public function die() : void
        {
            _instance = null;
            removeEventListener(Event.ENTER_FRAME,this.resetCounter);
            removeEventListener(Event.ENTER_FRAME,this.followMouse);
        }
    }
}

