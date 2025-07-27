package com.totaljerkface.game.editor
{
    import flash.display.Sprite;
    
    public class CircleShape extends RefShape
    {
        public function CircleShape(param1:Boolean = true, param2:Boolean = true, param3:Boolean = false, param4:Number = 1, param5:uint = 4032711, param6:int = -1, param7:* = 100, param8:int = 1, param9:* = 0)
        {
            super(param1,param2,param3,param4,param5,param6,param7,param8,param9);
            name = "circle shape";
        }
        
        override protected function drawShape() : void
        {
            graphics.clear();
            if(outlineColor >= 0)
            {
                graphics.lineStyle(0,_outlineColor,_opacity,true);
            }
            graphics.beginFill(_color,_opacity);
            graphics.drawCircle(0,0,50);
            if(_innerCutout > 0)
            {
                graphics.drawCircle(0,0,49 * _innerCutout / 100);
            }
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
            _loc1_.graphics.drawCircle(0,0,50);
            if(_innerCutout > 0)
            {
                _loc1_.graphics.drawCircle(0,0,49 * _innerCutout / 100);
            }
            _loc1_.graphics.endFill();
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.scaleX = scaleX;
            _loc1_.scaleY = scaleY;
            _loc1_.rotation = rotation;
            _loc1_.alpha = _opacity;
            return _loc1_;
        }
        
        override public function setAttributes() : void
        {
            if(_interactive)
            {
                _attributes = ["x","y","shapeWidth","shapeHeight","angle","color","outlineColor","opacity","interactive","immovable","collision","innerCutout"];
            }
            else
            {
                _attributes = ["x","y","shapeWidth","shapeHeight","angle","color","outlineColor","opacity","interactive","innerCutout"];
            }
            addTriggerProperties();
        }
        
        override public function getFullProperties() : Array
        {
            return ["x","y","shapeWidth","shapeHeight","angle","immovable","sleeping","density","color","outlineColor","opacity","collision","innerCutout"];
        }
        
        override public function set shapeWidth(param1:Number) : void
        {
            super.shapeWidth = param1;
            super.shapeHeight = param1;
        }
        
        override public function set shapeHeight(param1:Number) : void
        {
            super.shapeHeight = param1;
            super.shapeWidth = param1;
        }
        
        override public function set angle(param1:Number) : void
        {
            rotation = 0;
        }
    }
}

