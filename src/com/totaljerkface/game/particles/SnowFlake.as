package com.totaljerkface.game.particles
{
    import com.totaljerkface.game.Settings;
    import flash.display.BitmapData;
    
    public class SnowFlake extends Particle
    {
        public const slowGrav:Number = 0.3472222222222222;
        
        public const MaxAirSpeed:Number = 20;
        
        protected var accelX:Number;
        
        public function SnowFlake(param1:Number, param2:Number, param3:BitmapData)
        {
            super(param1,param2,param3);
            this.accelX = Math.random() * 0.02 - 0.01;
        }
        
        override public function step() : Boolean
        {
            y += speedY;
            x += speedX;
            speedY += this.slowGrav;
            if(speedY > this.MaxAirSpeed)
            {
                speedY *= 0.9;
            }
            if(speedX > this.MaxAirSpeed)
            {
                speedX *= 0.9;
            }
            if(y > Settings.YParticleLimit)
            {
                return false;
            }
            return true;
        }
    }
}

