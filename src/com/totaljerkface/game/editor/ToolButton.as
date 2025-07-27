package com.totaljerkface.game.editor
{
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.filters.GlowFilter;
    
    public class ToolButton extends Sprite
    {
        public var icon:Sprite;
        
        public var bg:MovieClip;
        
        private var glowFilter:GlowFilter = new GlowFilter(4032711,1,10,10,2,3,true);
        
        private var _selected:Boolean;
        
        private var iconY:Number;
        
        public function ToolButton()
        {
            super();
            this.init();
        }
        
        private function init() : void
        {
            this.iconY = this.icon.y;
            mouseChildren = false;
            addEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
            addEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler);
        }
        
        private function mouseOverHandler(param1:MouseEvent) : void
        {
            if(this._selected)
            {
                return;
            }
            this.bg.gotoAndStop(2);
        }
        
        private function mouseOutHandler(param1:MouseEvent) : void
        {
            if(this._selected)
            {
                return;
            }
            this.bg.gotoAndStop(1);
        }
        
        public function get selected() : Boolean
        {
            return this._selected;
        }
        
        public function set selected(param1:Boolean) : void
        {
            this._selected = param1;
            if(param1)
            {
                this.bg.gotoAndStop(3);
                this.icon.filters = [this.glowFilter];
            }
            else
            {
                this.bg.gotoAndStop(1);
                this.icon.filters = [];
            }
        }
    }
}

