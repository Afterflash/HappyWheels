package com.totaljerkface.game.editor.ui
{
    import flash.display.Sprite;
    import flash.geom.ColorTransform;
    
    public class DropperCursor extends Sprite
    {
        public var changer:Sprite;
        
        private var _color:uint = 16777215;
        
        public function DropperCursor()
        {
            super();
        }
        
        public function get color() : uint
        {
            return this._color;
        }
        
        public function set color(param1:uint) : void
        {
            this._color = param1;
            var _loc2_:ColorTransform = new ColorTransform();
            _loc2_.color = param1;
            this.changer.transform.colorTransform = _loc2_;
        }
    }
}

