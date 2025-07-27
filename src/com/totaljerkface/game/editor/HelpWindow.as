package com.totaljerkface.game.editor
{
    import com.totaljerkface.game.editor.ui.SpecialListScroller;
    import com.totaljerkface.game.editor.ui.Window;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    
    public class HelpWindow extends Sprite
    {
        private static var _instance:HelpWindow;
        
        private static var windowX:Number;
        
        private static var windowY:Number;
        
        private const windowWidth:int = 200;
        
        private const windowHeight:int = 155;
        
        private var holder:Sprite;
        
        private var maskSprite:Sprite;
        
        private var textField:TextField;
        
        private var scroller:SpecialListScroller;
        
        private var _window:Window;
        
        public function HelpWindow()
        {
            super();
            if(_instance)
            {
                throw new Error("help window already exists");
            }
            _instance = this;
            this.init();
        }
        
        public static function get instance() : HelpWindow
        {
            return _instance;
        }
        
        private function init() : void
        {
            this.createWindow();
            this.createShit();
        }
        
        public function createWindow() : void
        {
            this._window = new Window(true,this);
            this._window.setDimensions(this.windowWidth,this.windowHeight);
            if(windowX)
            {
                this._window.x = windowX;
                this._window.y = windowY;
            }
            this._window.addEventListener(Window.WINDOW_CLOSED,this.windowClosed);
        }
        
        public function closeWindow() : void
        {
            windowX = this._window.x;
            windowY = this._window.y;
            this._window.removeEventListener(Window.WINDOW_CLOSED,this.windowClosed);
            this._window.closeWindow();
            this._window = null;
        }
        
        private function windowClosed(param1:Event) : void
        {
            windowX = this._window.x;
            windowY = this._window.y;
            this._window.removeEventListener(Window.WINDOW_CLOSED,this.windowClosed);
            this._window = null;
            dispatchEvent(new Event(Window.WINDOW_CLOSED));
        }
        
        private function createShit() : void
        {
            graphics.beginFill(16777215);
            graphics.drawRect(0,0,this.windowWidth,this.windowHeight);
            graphics.endFill();
            var _loc1_:TextFormat = new TextFormat("HelveticaNeueLT Std",12,0,null,null,null,null,null,TextFormatAlign.LEFT);
            this.textField = new TextField();
            this.textField.defaultTextFormat = _loc1_;
            this.textField.width = this.windowWidth - 12;
            this.textField.height = 20;
            this.textField.x = 0;
            this.textField.y = 0;
            this.textField.multiline = true;
            this.textField.autoSize = TextFieldAutoSize.LEFT;
            this.textField.wordWrap = true;
            this.textField.selectable = false;
            this.textField.embedFonts = true;
            this.textField.antiAliasType = AntiAliasType.ADVANCED;
            this.holder = new Sprite();
            addChild(this.holder);
            this.holder.addChild(this.textField);
            this.maskSprite = new Sprite();
            this.maskSprite.graphics.beginFill(0);
            this.maskSprite.graphics.drawRect(0,0,this.windowWidth - 12,this.windowHeight);
            this.maskSprite.graphics.endFill();
            addChild(this.maskSprite);
            this.holder.mask = this.maskSprite;
            this.scroller = new SpecialListScroller(this.holder,this.maskSprite,22);
            addChild(this.scroller);
            this.scroller.x = this.windowWidth - 12;
        }
        
        public function populate(param1:String) : void
        {
            this.textField.htmlText = param1;
            this.holder.y = 0;
            this.scroller.updateScrollTab();
        }
        
        public function get window() : Window
        {
            return this._window;
        }
        
        public function die() : void
        {
            _instance = null;
            this.scroller.die();
            if(this._window)
            {
                this._window.closeWindow();
            }
        }
    }
}

