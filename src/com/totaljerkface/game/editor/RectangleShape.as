package com.totaljerkface.game.editor
{
    import flash.display.Sprite;
    
    public class RectangleShape extends RefShape
    {
        public function RectangleShape(param1:Boolean = true, param2:Boolean = true, param3:Boolean = false, param4:Number = 1, param5:uint = 4032711, param6:int = -1, param7:Number = 100, param8:int = 1)
        {
            super(param1,param2,param3,param4,param5,param6,param7,param8);
            name = "rectangle shape";
        }
        
        override protected function drawShape() : void
        {
            graphics.clear();
            if(outlineColor >= 0)
            {
                graphics.lineStyle(0,_outlineColor,_opacity,true);
            }
            graphics.beginFill(_color,_opacity);
            graphics.drawRect(-50,-50,100,100);
            graphics.endFill();
        }
        
        override public function getFlatSprite() : Sprite
        {
            var _loc1_:Sprite = new Sprite();
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
                _loc1_.graphics.beginFill(_color,1);
            }
            _loc1_.graphics.drawRect(-50,-50,100,100);
            _loc1_.graphics.endFill();
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.scaleX = scaleX;
            _loc1_.scaleY = scaleY;
            _loc1_.rotation = rotation;
            _loc1_.alpha = _opacity;
            return _loc1_;
        }
    }
}

