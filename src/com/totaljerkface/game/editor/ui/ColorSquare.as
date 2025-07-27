package com.totaljerkface.game.editor.ui
{
    import flash.display.Sprite;
    
    public class ColorSquare extends Sprite
    {
        public static var squareWidth:int = 6;
        
        private var _color:uint;
        
        public var id:int;
        
        public function ColorSquare(param1:uint)
        {
            super();
            this.color = param1;
            buttonMode = true;
            tabEnabled = false;
        }
        
        private function drawSquare() : void
        {
            graphics.clear();
            graphics.beginFill(this._color);
            graphics.drawRect(0,0,squareWidth,squareWidth);
            graphics.endFill();
        }
        
        public function get color() : uint
        {
            return this._color;
        }
        
        public function set color(param1:uint) : void
        {
            this._color = param1;
            this.drawSquare();
        }
    }
}

