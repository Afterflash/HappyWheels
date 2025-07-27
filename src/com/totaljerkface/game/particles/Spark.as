package com.totaljerkface.game.particles
{
    import flash.display.Sprite;
    
    public class Spark extends Sprite
    {
        protected static const scaler:Number = 2.0833333333333335;
        
        protected static const gravityIncrement:Number = 0.6944444444444444;
        
        protected static const decayRate:Number = 0.65;
        
        protected var speedY:Number;
        
        protected var speedX:Number;
        
        protected var changeY:Number;
        
        protected var gravitySpeed:Number = 0;
        
        protected var color:uint;
        
        public function Spark(param1:Number, param2:Number)
        {
            super();
            this.speedY = param1 * scaler;
            this.speedX = param2 * scaler;
            this.color = 16776960 + Math.round(Math.random() * 255);
        }
        
        public function step() : Boolean
        {
            this.changeY = this.speedY + this.gravitySpeed;
            graphics.clear();
            graphics.lineStyle(1,this.color);
            graphics.moveTo(-this.speedX,-this.changeY);
            graphics.lineTo(0,0);
            y += this.changeY;
            x += this.speedX;
            this.speedX *= decayRate;
            this.speedY *= decayRate;
            this.gravitySpeed += gravityIncrement;
            if(Math.abs(this.speedY) < 1 && Math.abs(this.speedX) < 1)
            {
                return false;
            }
            return true;
        }
    }
}

