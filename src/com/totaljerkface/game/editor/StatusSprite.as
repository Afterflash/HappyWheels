package com.totaljerkface.game.editor
{
    import com.totaljerkface.game.editor.ui.Window;
    import flash.display.Sprite;
    import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    
    public class StatusSprite extends Sprite
    {
        protected var textField:TextField;
        
        protected var bg:Sprite;
        
        protected var _window:Window;
        
        protected var bgWidth:int;
        
        protected var bgHeight:int = 100;
        
        public function StatusSprite(param1:String, param2:Boolean = true, param3:int = 200)
        {
            super();
            this.bgWidth = param3;
            this.createTextField();
            this.textField.htmlText = param1;
            this.createBg();
            this.createWindow(param2);
            this.adjustText();
        }
        
        protected function createBg() : void
        {
            this.bgHeight = Math.max(this.textField.height * 2,100);
            this.bg = new Sprite();
            this.bg.graphics.beginFill(13421772);
            this.bg.graphics.drawRect(0,0,this.bgWidth,this.bgHeight);
            this.bg.graphics.endFill();
            addChildAt(this.bg,0);
        }
        
        protected function createTextField() : void
        {
            var _loc1_:TextFormat = new TextFormat("HelveticaNeueLT Std",12,16777215,null,null,null,null,null,TextFormatAlign.CENTER);
            this.textField = new TextField();
            this.textField.defaultTextFormat = _loc1_;
            this.textField.width = this.bgWidth - 20;
            this.textField.height = 20;
            this.textField.autoSize = TextFieldAutoSize.LEFT;
            this.textField.multiline = true;
            this.textField.wordWrap = true;
            this.textField.selectable = false;
            this.textField.embedFonts = true;
            this.textField.antiAliasType = AntiAliasType.ADVANCED;
            addChild(this.textField);
        }
        
        protected function adjustText() : void
        {
            this.textField.x = (this.bgWidth - this.textField.width) / 2;
            this.textField.y = (this.bgHeight - this.textField.height) / 2;
        }
        
        protected function createWindow(param1:*) : void
        {
            this._window = new Window(false,this,param1);
        }
        
        public function get window() : Window
        {
            return this._window;
        }
        
        public function die() : void
        {
            this._window.closeWindow();
        }
    }
}

