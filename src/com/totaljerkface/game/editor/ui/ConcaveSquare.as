package com.totaljerkface.game.editor.ui
{
    import flash.display.Sprite;
    import flash.geom.Rectangle;
    
    public class ConcaveSquare extends Sprite
    {
        private const topColor:uint = 9342606;
        
        private const sideColor:uint = 12040119;
        
        private const bottomColor:uint = 15132390;
        
        private var centerColor:uint;
        
        public function ConcaveSquare(param1:Number, param2:Number, param3:uint = 16777215)
        {
            super();
            this.centerColor = param3;
            graphics.beginFill(this.topColor);
            graphics.lineTo(10,0);
            graphics.lineTo(8,2);
            graphics.lineTo(2,2);
            graphics.lineTo(0,0);
            graphics.endFill();
            graphics.beginFill(this.sideColor);
            graphics.lineTo(2,2);
            graphics.lineTo(2,8);
            graphics.lineTo(0,10);
            graphics.lineTo(0,0);
            graphics.endFill();
            graphics.moveTo(10,0);
            graphics.beginFill(this.sideColor);
            graphics.lineTo(10,10);
            graphics.lineTo(8,8);
            graphics.lineTo(8,2);
            graphics.lineTo(10,0);
            graphics.endFill();
            graphics.moveTo(0,10);
            graphics.beginFill(this.bottomColor);
            graphics.lineTo(2,8);
            graphics.lineTo(8,8);
            graphics.lineTo(10,10);
            graphics.lineTo(0,10);
            graphics.endFill();
            graphics.beginFill(param3);
            graphics.drawRect(2,2,6,6);
            graphics.endFill();
            scale9Grid = new Rectangle(2,2,6,6);
            width = param1;
            height = param2;
        }
    }
}

