package com.totaljerkface.game.menus
{
    import com.totaljerkface.game.Settings;
    import flash.display.BlendMode;
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.filters.GlowFilter;
    import flash.net.URLRequest;
    
    public class CharacterIcon extends Sprite
    {
        private static const fileString:String = "char";
        
        public static const iconWidth:int = 50;
        
        public static const iconHeight:int = 50;
        
        private var bg:Sprite;
        
        private var _index:int;
        
        private var loaderColor:Loader;
        
        private var loaderBW:Loader;
        
        private var _selected:Boolean;
        
        private var _selectable:Boolean;
        
        private var glowFilter:GlowFilter;
        
        public function CharacterIcon(param1:int)
        {
            super();
            this._index = param1;
            this.createBg();
            mouseChildren = false;
            if(param1 <= Settings.totalCharacters)
            {
                this.loadBitmaps();
                this.loaderBW.visible = true;
                this.loaderColor.visible = false;
                this._selectable = true;
                buttonMode = true;
            }
        }
        
        private function createBg() : void
        {
            this.bg = new Sprite();
            addChild(this.bg);
            this.bg.graphics.beginFill(16777215,0.1);
            this.bg.graphics.drawRect(0,0,iconWidth,iconHeight);
            this.bg.graphics.drawRect(5,5,iconWidth - 10,iconHeight - 10);
            this.bg.graphics.endFill();
            this.bg.graphics.beginFill(0,0.1);
            this.bg.graphics.drawRect(5,5,iconWidth - 10,iconHeight - 10);
            this.bg.graphics.endFill();
        }
        
        private function loadBitmaps() : void
        {
            trace("loadBitmap");
            this.loaderBW = new Loader();
            this.loaderColor = new Loader();
            var _loc1_:URLRequest = new URLRequest(Settings.pathPrefix + Settings.imagePath + fileString + this.index + "_bw.png");
            var _loc2_:URLRequest = new URLRequest(Settings.pathPrefix + Settings.imagePath + fileString + this.index + ".png");
            trace("urlReq " + _loc1_.url);
            this.loaderBW.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.IOErrorHandler,false,0,true);
            this.loaderColor.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.IOErrorHandler,false,0,true);
            this.loaderBW.load(_loc1_);
            this.loaderColor.load(_loc2_);
            this.loaderBW.x = this.loaderColor.x = 5;
            this.loaderBW.y = this.loaderColor.y = 5;
            addChild(this.loaderBW);
            addChild(this.loaderColor);
        }
        
        private function bitmapLoaded(param1:Event) : void
        {
        }
        
        private function IOErrorHandler(param1:IOErrorEvent) : void
        {
            trace(param1.text);
        }
        
        public function get selected() : Boolean
        {
            return this._selected;
        }
        
        public function get selectable() : Boolean
        {
            return this._selectable;
        }
        
        public function set selected(param1:Boolean) : void
        {
            if(param1 == this._selected)
            {
                return;
            }
            this._selected = param1;
            if(this._selected)
            {
                this.bg.graphics.clear();
                this.bg.graphics.beginFill(16777215,1);
                this.bg.graphics.drawRect(0,0,iconWidth,iconHeight);
                this.bg.graphics.drawRect(5,5,iconWidth - 10,iconHeight - 10);
                this.bg.graphics.endFill();
                this.bg.graphics.beginFill(0,0.7);
                this.bg.graphics.drawRect(5,5,iconWidth - 10,iconHeight - 10);
                this.bg.graphics.endFill();
                this.bg.blendMode = BlendMode.OVERLAY;
                this.glowFilter = new GlowFilter(16777215,1,10,10,2,3);
                this.bg.filters = [this.glowFilter];
                this.loaderBW.visible = false;
                this.loaderColor.visible = true;
            }
            else
            {
                this.bg.graphics.clear();
                this.bg.graphics.beginFill(16777215,0.1);
                this.bg.graphics.drawRect(0,0,iconWidth,iconHeight);
                this.bg.graphics.drawRect(5,5,iconWidth - 10,iconHeight - 10);
                this.bg.graphics.endFill();
                this.bg.graphics.beginFill(0,0.1);
                this.bg.graphics.drawRect(5,5,iconWidth - 10,iconHeight - 10);
                this.bg.graphics.endFill();
                this.bg.blendMode = BlendMode.NORMAL;
                this.bg.filters = [];
                this.loaderBW.visible = true;
                this.loaderColor.visible = false;
            }
        }
        
        public function get index() : int
        {
            return this._index;
        }
    }
}

