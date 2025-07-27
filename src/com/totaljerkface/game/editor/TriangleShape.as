package com.totaljerkface.game.editor
{
    import flash.display.Sprite;
    
    public class TriangleShape extends RefShape
    {
        public function TriangleShape(param1:Boolean = true, param2:Boolean = true, param3:Boolean = false, param4:Number = 1, param5:uint = 4032711, param6:int = -1, param7:* = 100, param8:int = 1)
        {
            super(param1,param2,param3,param4,param5,param6,param7,param8);
            name = "triangle shape";
            maxDimension = 15;
        }
        
        override protected function drawShape() : void
        {
            graphics.clear();
            if(outlineColor >= 0)
            {
                graphics.lineStyle(0,_outlineColor,_opacity,true);
            }
            graphics.beginFill(_color,_opacity);
            graphics.moveTo(0,-200);
            graphics.lineTo(50,100);
            graphics.lineTo(-50,100);
            graphics.lineTo(0,-200);
            graphics.endFill();
        }
        
        override public function getFlatSprite() : Sprite
        {
            var _loc1_:Sprite = null;
            _loc1_ = new Sprite();
            if(_opacity == 0 || _outlineColor < 0 && _color < 0)
            {
                _loc1_.visible = false;
            }
            if(outlineColor >= 0)
            {
                _loc1_.graphics.lineStyle(0,_outlineColor,1,true);
            }
            if(color >= 0)
            {
                _loc1_.graphics.beginFill(_color,_opacity);
            }
            _loc1_.graphics.moveTo(0,-200);
            _loc1_.graphics.lineTo(50,100);
            _loc1_.graphics.lineTo(-50,100);
            _loc1_.graphics.lineTo(0,-200);
            _loc1_.graphics.endFill();
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.scaleX = scaleX;
            _loc1_.scaleY = scaleY;
            _loc1_.rotation = rotation;
            _loc1_.alpha = _opacity;
            return _loc1_;
        }
        
        override public function get shapeHeight() : Number
        {
            return Math.round(scaleY * 300);
        }
        
        override public function set shapeHeight(param1:Number) : void
        {
            scaleY = param1 / 300;
        }
    }
}

